Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756631Ab0GDCGO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Jul 2010 22:06:14 -0400
Received: from client-adsl-93-121-138-180.mediaserv.net ([93.121.138.180]:59703
	"EHLO werner.loopback" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756535Ab0GDCGN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Jul 2010 22:06:13 -0400
X-Greylist: delayed 105923 seconds by postgrey-1.27 at vger.kernel.org; Sat, 03 Jul 2010 22:06:12 EDT
From: werner@guyane.dyn-o-saur.com
Subject: Re: 2.6.35-rc2,3 -- Problem with PS2 keyboard and mouse driver
To: Paulo Marques <pmarques@grupopie.com>, linux-kernel@vger.kernel.org
X-Originating-IP: 127.0.0.1
X-Mailer: Usermin 1.360
Message-Id: <1278103279.14731@guyane.dyn-o-saur.com>
In-Reply-To: <4C2DD625.2030903@grupopie.com>
Date: Fri, 02 Jul 2010 17:41:19 -0300 (GFT)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="bound1278103279"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.

--bound1278103279
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

I compiled 2.6.35-rc3-git7 applying this patch, but the problem continues.

I have an USB keyboard and mouse.     For BIOS and lilo the keyboard works normally.    However, when the kernel loads, it stops imediately.   I can check this by pressing repeatedly the key lock and observing when the light don't blink.

On -rc2 came arbitrarily characters (but only 1 por line) on the text screen. A PS2 keyboard blocks completely as explained above (and also the PS2 mouse t dont work), an USB keyboard worked almost normally in the grafic mode(also the PS2 mouse worked),  

But on -rc3 , no kind of keyboard didn't work anymore.   

Rebooting with 2.6.35-rc1, everything works normal.

Thus, the error entered between -rc1 and -rc2 , on something what was changed also till -rc3 so that it then become more worse.


Werner Landgraf

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
On 02/Jul/2010 09:05 Paulo Marques wrote ..
> werner@guyane.yi.org wrote:
> > 2.6.35-rc2,3,3-git1 -- Problem with PS2 keyboard and mouse driver
> > 
> > That problem continues at -git6 .
> > 
> > Since 2.6.35-rc2 the USB keyboard driver don't work longer, on
> > different mainboards and keyboards.
> > 
> > On 2.6.35-rc1 things still were (more or less) normal.
> > 
> > THIS IS AN ERROR WHICH ENTERED BETWEEN 2.6.35 -rc1 and -rc2 !!
> 
> The address 07200720 looks like a couple of gray spaces in a vga console
> and I've seen that before not long ago.
> 
> After a bit of searching, I've found it: it's in the thread that started
> with "Linux 2.6.35-rc2", and most importantly in the thread:
> 
> BUG kmalloc-4096: Poison overwritten (2.6.35-rc2)
> 
> where there is a patch that is supposed to fix this. I thought this was
> already applied upstream, though...
> 
> For your convenience, the patch in that thread is this one (might be
> white space mangled, as I just copy+pasted it, so you might need to
> apply it by hand):
> 
> ---
>  drivers/char/vt.c |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/char/vt.c b/drivers/char/vt.c
> index 1296c42..e123958 100644
> --- a/drivers/char/vt.c
> +++ b/drivers/char/vt.c
> @@ -304,8 +304,8 @@ static void scrup(struct vc_data *vc, unsigned int
> t, unsigned int b, int nr)
>  	d =3D (unsigned short *)(vc->vc_origin + vc->vc_size_row * t);
>  	s =3D (unsigned short *)(vc->vc_origin + vc->vc_size_row * (t + nr));
>  	scr_memmovew(d, s, (b - t - nr) * vc->vc_size_row);
> -	scr_memsetw(d + (b - t - nr) * vc->vc_size_row, vc->vc_video_erase_char,
> -		    vc->vc_size_row * nr);
> +	scr_memsetw((void *)d + (b - t - nr) * vc->vc_size_row,
> +			vc->vc_video_erase_char, vc->vc_size_row * nr);
>  }
> 
>  static void scrdown(struct vc_data *vc, unsigned int t, unsigned int b,
> int nr)
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
*** guyane.dyn-o-saur.com / copaya.yi.org / SYS-Linux.yi.org ***
O =FAnico servidor comunit=E1rio na Guiana-Francesa.  Situado no local, r=E1pido, gratuito, imuno contra guerras / desastres na Europa.   Servi=E7o n=E3o-comercial e gratuito de:  http (forum, p=E1gina web), irc (chat), ftp (download), name (subdomain) .


*** Usa nosso  SYS  Sistema operacional !   Seguro e gratuito ***
Ulima Versao:  SYS 0.23+  do  5/2/09
'current' SYS_Linux.iso   do 17/3/09

Refer=EAncia:
http ://linux.softpedia.com/get/System/Operating-Systems/Linux-Distributions/SYS-34168.shtml 
http ://www .linuxquestions.org/reviews/showproduct.php?product=3D834
http ://www. distromania.com/distro_info.php?distro=3D1185 
http ://sys-linux.yi.org/forum/index.php  (F=F3rum de Apoio)

Telecarregar:    (favor usa c/prefer=EAncia os mirros) (Install-DVD: .../SYS_Linux.iso)
 Caiena, Guiana-Caiena, America-do-Sul (Servidor Principal): ftp: //copaya.yi.org/sys/ , rsync: //copaya.yi.org/sys/ ,  http: //copaya.yi.org/sys/
 G=F6ttingen, Alemanha, Europa :  ftp: //ftp5.gwdg.de/pub/linux/install/sys/ ,  http: //ftp5.gwdg.de/pub/linux/install/sys/
 Siegen, Alemanha, Europa :  ftp: //ftp.uni-siegen.de/pub/sys-linux  
 DistroMania  : ftp: //linux-ds.unidu.hr/sys/SYS_Linux.iso ,  http: //linux-ds.unidu.hr/sys/SYS_Linux.iso  
 Curitiba, Brasil, America-do-Sul  : ftp: //sys.c3sl.ufpr.br/SYS/ ,  http: //sys.c3sl.ufpr.br


--bound1278103279--

