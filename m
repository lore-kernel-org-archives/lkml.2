Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759249Ab0LNP3W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:29:22 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56367 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753219Ab0LNP3V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:29:21 -0500
Message-ID: <4D078D53.4040700@suse.cz>
Date: Tue, 14 Dec 2010 16:29:23 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ben Gardiner <bengardiner@nanometrics.ca>
Cc: Roman Zippel <zippel@linux-m68k.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: fix interaction of CONFIG_IKCONFIG and KCONFIG_CONFIG
References: <1290797770-22877-1-git-send-email-bengardiner@nanometrics.ca>
In-Reply-To: <1290797770-22877-1-git-send-email-bengardiner@nanometrics.ca>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26.11.2010 19:56, Ben Gardiner wrote:
> Change the use of .config in kernel/Makefile to $(KCONFIG_CONFIG).
>
> Currently, if you try to build a kernel with KCONFIG_CONFIG set (to a value
> not equal to .config) and the config file pointed to by KCONFIG_CONFIG sets
> CONFIG_IKCONFIG then the build will fail with:
>
> make[1]: *** No rule to make target `.config', needed by `kernel/config_data.gz'.  Stop.
>
> I think this has been present since the introduction of KCONFIG_CONFIG
> in 14cdd3c402bf7c66f0bcd76e290f0770a54a4b21.
>
> Signed-off-by: Ben Gardiner<bengardiner@nanometrics.ca>
> CC: Roman Zippel<zippel@linux-m68k.org>
> CC: Michal Marek<mmarek@suse.cz>
>
> ---
> based on 698fd6a2c3ca05ec796072defb5c415289a86cdc of
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
>
>   kernel/Makefile |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/kernel/Makefile b/kernel/Makefile
> index 0b5ff08..33e0a39 100644
> --- a/kernel/Makefile
> +++ b/kernel/Makefile
> @@ -121,7 +121,7 @@ $(obj)/configs.o: $(obj)/config_data.h
>   # config_data.h contains the same information as ikconfig.h but gzipped.
>   # Info from config_data can be extracted from /proc/config*
>   targets += config_data.gz
> -$(obj)/config_data.gz: .config FORCE
> +$(obj)/config_data.gz: $(KCONFIG_CONFIG) FORCE
>   	$(call if_changed,gzip)
>
>   quiet_cmd_ikconfiggz = IKCFG   $@

The problem is that KCONFIG_CONFIG is not exported in the top-level 
Makefile. If you want to use it in other Makefiles, you need to add the 
export.

Michal
