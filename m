Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751713Ab0LXHkO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Dec 2010 02:40:14 -0500
Received: from eu1sys200aog108.obsmtp.com ([207.126.144.125]:43124 "EHLO
	eu1sys200aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab0LXHkM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Dec 2010 02:40:12 -0500
From: Carmelo AMOROSO <carmelo.amoroso@st.com>
To: "carmelo73@gmail.com" <carmelo73@gmail.com>
Cc: =?iso-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Fri, 24 Dec 2010 08:39:43 +0100
Subject: Re: [PATCH] modules: Allow to use depmod from a non default install
Thread-Topic: [PATCH] modules: Allow to use depmod from a non default install
Thread-Index: AcujPbt8pgJ8jQD8SqyU5iVmd2Yceg==
Message-ID: <4D144E3F.7010706@st.com>
References: <4AF73BA4.3000501@gmail.com> <20091109030622.GB2399@hack>
 <4B0800F6.1010709@gmail.com>
In-Reply-To: <4B0800F6.1010709@gmail.com>
Accept-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-enigmail-version: 1.1.1
user-agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.13)
 Gecko/20101207 Lightning/1.0b2 Thunderbird/3.1.7
acceptlanguage: en-US
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On 11/21/2009 4:02 PM, Carmelo Amoroso wrote:
> Américo Wang wrote:
>  > On Sun, Nov 08, 2009 at 10:44:04PM +0100, Carmelo Amoroso wrote:
>  >> This patch allow to specify the directory where to find the
>  >> depmod tool other than being forced to use the module-init-tools
>  >> installed on the host. The reason for this is explained below.
>  >> When doing cross-compilation, it not guaranteed that the
>  >> module-init-tools installed on the host (and used during kernel build)
>  >> are exactly the same and compatible with those used on the target at runtime.
>  >> For example, recent changes in how depmod writes modules.dep using
>  >> root-less path, make older modprobe unusable on the target.
>  >> User in ths case could install in a different path the module-init-tools
>  >> compatible with the version used on the target and specify the path on the
>  >> command line.
>  >>
>  >> Signed-off-by: Carmelo Amoroso <carmelo.amoroso@st.com>
>  >
>  > Acked-by: WANG Cong <xiyou.wangcong@gmail.com>
>  >
>  >
> 
> Hi,
> any plan to get it included ?
> 
> cheers,
> carmelo
> 
>  >> ---
>  >> Makefile | 3 ++-
>  >> 1 files changed, 2 insertions(+), 1 deletions(-)
>  >>
>  >> diff --git a/Makefile b/Makefile
>  >> index b4c04f7..f5286c4 100644
>  >> --- a/Makefile
>  >> +++ b/Makefile
>  >> @@ -316,7 +316,8 @@ OBJDUMP = $(CROSS_COMPILE)objdump
>  >> AWK = awk
>  >> GENKSYMS = scripts/genksyms/genksyms
>  >> INSTALLKERNEL := installkernel
>  >> -DEPMOD = /sbin/depmod
>  >> +DEPMOD_PATH ?= /sbin
>  >> +DEPMOD = $(DEPMOD_PATH)/depmod
>  >> KALLSYMS = scripts/kallsyms
>  >> PERL = perl
>  >> CHECK = sparse
>  >> -- 1.6.3.3
>  >> --
>  >> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>  >> the body of a message to majordomo@vger.kernel.org
>  >> More majordomo info at http://vger.kernel.org/majordomo-info.html
>  >> Please read the FAQ at http://www.tux.org/lkml/
>  >
> 
> 

ping... one year later.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk0UTj8ACgkQoRq/3BrK1s99/wCglIZ37nvDw8g0/nKAt5KRsI6W
M9AAnRVGSbEiod4jFCFhwRRxxofakEQa
=ZSKN
-----END PGP SIGNATURE-----
