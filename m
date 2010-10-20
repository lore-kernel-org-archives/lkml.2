Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757620Ab0JTDNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:13:20 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49450 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757327Ab0JTDNR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:13:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:content-type:content-transfer-encoding;
        b=dA2ytn3ppjv0eoRwfG/weoemz9SXkfKMAYGWjFsiyiAxkWUsQuYWpLLdN0o2CSaiDB
         dXqzddxA44u1KdnSk5AZTvZuoXRro6zt+kvdkhw7whweLVsv0ZSAeoRYHqWVPLGrw3gD
         aJDTa+wbIgJd4Zqm55IuTPS+JyFSn0I2IT4H4=
Message-ID: <4CBE5E6B.1050701@gmail.com>
Date: Tue, 19 Oct 2010 20:13:47 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b5pre) Gecko/20100827 Thunderbird/3.2a1pre
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: x86_32 compile error with the latest Mainline
References: <AANLkTi=kHWqg32TFVjX5GT+R2hDPcadxsvYhL7RXiGsp@mail.gmail.com>
In-Reply-To: <AANLkTi=kHWqg32TFVjX5GT+R2hDPcadxsvYhL7RXiGsp@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2010 07:55 PM, Justin Mattock wrote:
> looking into upstart, I realize I need to have an image in order to
> load the policy
> at boot... so after learning something new(normally make, make install
> is just fine)
> I seem to be hitting some thing with dpkg-gencontrol
>
> make-kpkg  --initrd --rootcmd fakeroot --revision=1
> --append-to-version -justin-rt kernel_image kernel_headers
> (probably have something wrong)
>
> and the error:
>
> 	    -e 's/=ST/linux/g'  -e 's/=R//g' \
>              -e 's/=KPV/12.032/g'                       \
> 	    -e 's/=K/vmlinuz/g'           \
> 	    -e 's@=MK@@g' -e 's@=A@i386@g'   \
> 	    -e 's/=I/YES/g'     -e 's,=D,/boot,g'        \
> 	    -e 's/=MD//g'                                \
> 	    -e 's@=M@@g'    -e 's/=OF//g'    \
> 	    -e 's/=S//g' -e 's@=B@i386@g'     \
> 	 ./debian/templates.l10n>  ./debian/templates.master
> install -p    -o root -g root  -m  644 ./debian/templates.master
> /home/kernel/2.6.37/debian/linux-image-2.6.36-rc8-justin-rt+/DEBIAN/templates
> dpkg-gencontrol -DArchitecture=i386 -isp	     \
> 			-plinux-image-2.6.36-rc8-justin-rt+
> -P/home/kernel/2.6.37/debian/linux-image-2.6.36-rc8-justin-rt+/
> dpkg-gencontrol: error: package linux-image-2.6.36-rc8-justin-rt+ not
> in control info
> make[2]: *** [debian/stamp/binary/linux-image-2.6.36-rc8-justin-rt+] Error 255
> make[2]: Leaving directory `/home/kernel/2.6.37'
> make[1]: *** [debian/stamp/binary/pre-linux-image-2.6.36-rc8-justin-rt+] Error 2
> make[1]: Leaving directory `/home/kernel/2.6.37'
> make: *** [kernel_image] Error 2
>
>
> I've gone in an enabled/disabled CONFIG_LOCALVERSION but still errors
> out both ways..
>
> any ideas on what I did wrong?
> BTW: also noticed this thread as well
> http://www.gossamer-threads.com/lists/linux/kernel/1266036
>


o.k. nevermind... needed to do more searching with this, ended up using 
a patch on this report, that fixes this error for me:
https://bugs.launchpad.net/ubuntu/+source/linux-source-2.6.15/+bug/16447



Justin P. Mattock
