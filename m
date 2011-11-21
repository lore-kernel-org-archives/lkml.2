Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755670Ab1KURYt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 12:24:49 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50493 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1KURYs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 12:24:48 -0500
Message-ID: <4ECA8991.20302@suse.cz>
Date: Mon, 21 Nov 2011 18:25:37 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, kbuild@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, "H.J. Lu" <hjl.tools@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, Sam Ravnborg <sam@ravnborg.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH 2/8] kbuild: Add support for an "archheaders" target
References: <1321569446-20433-1-git-send-email-hpa@linux.intel.com> <1321569446-20433-3-git-send-email-hpa@linux.intel.com>
In-Reply-To: <1321569446-20433-3-git-send-email-hpa@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 17.11.2011 23:37, H. Peter Anvin napsal(a):
> -__headers: include/linux/version.h scripts_basic asm-generic FORCE
> +__headers: include/linux/version.h scripts_basic asm-generic archheaders FORCE
>  	$(Q)$(MAKE) $(build)=scripts build_unifdef
>  
>  PHONY += headers_install_all
> diff --git a/scripts/headers.sh b/scripts/headers.sh
> index 978b42b..af1ed88 100755
> --- a/scripts/headers.sh
> +++ b/scripts/headers.sh
> @@ -7,6 +7,7 @@ set -e
>  do_command()
>  {
>  	if [ -f ${srctree}/arch/$2/include/asm/Kbuild ]; then
> +		make ARCH=$2 KBUILD_HEADERS=$1 archheaders
>  		make ARCH=$2 KBUILD_HEADERS=$1 headers_$1

I don't think we need the explicit make archheaders call here, it's
handled by the __headers dependency above.

Michal
