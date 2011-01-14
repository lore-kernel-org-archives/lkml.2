Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab1ANLIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 06:08:44 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49017 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752408Ab1ANLIh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 06:08:37 -0500
Message-ID: <4D302EB4.7000005@suse.cz>
Date: Fri, 14 Jan 2011 12:08:36 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101206 SUSE/3.1.7 Thunderbird/3.1.7
MIME-Version: 1.0
To: Jianbin Kang <kjbmail@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: add global tags generation (fixed signed-off-by)
References: <AANLkTi=BPra1SJ3BHN0L1e6L9MKj3EJ0agjaA+m7CkGj@mail.gmail.com>
In-Reply-To: <AANLkTi=BPra1SJ3BHN0L1e6L9MKj3EJ0agjaA+m7CkGj@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14.1.2011 10:56, Jianbin Kang wrote:
> kbuild: add global tags generation
> 
> gnu global (http://www.gnu.org/software/global/) is a source code tagging system
> It is really cheap to support it in kbuild system.
> 
>     Signed-off-by: Jianbin Kang <kjbmail@gmail.com>
> 
> diff --git a/Makefile b/Makefile
> index 74b2555..127a371 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -420,7 +420,7 @@ endif
>  # of make so .config is not included in this case either (for *config).
> 
>  no-dot-config-targets := clean mrproper distclean \
> -			 cscope TAGS tags help %docs check% coccicheck \
> +			 cscope gtags TAGS tags help %docs check% coccicheck \
>  			 include/linux/version.h headers_% \
>  			 kernelversion %src-pkg
> 
> @@ -1134,7 +1134,7 @@ CLEAN_FILES +=	vmlinux System.map \
>  MRPROPER_DIRS  += include/config usr/include include/generated
>  MRPROPER_FILES += .config .config.old .version .old_version             \
>                    include/linux/version.h                               \
> -		  Module.symvers tags TAGS cscope*
> +		  Module.symvers tags TAGS cscope* GPATH GTAGS GRTAGS GSYMS
> 
>  # clean - Delete most, but leave enough to build external modules
>  #
> @@ -1221,6 +1221,7 @@ help:
>  	@echo  '  modules_prepare - Set up for building external modules'
>  	@echo  '  tags/TAGS	  - Generate tags file for editors'
>  	@echo  '  cscope	  - Generate cscope index'
> +	@echo  '  gtags           - Generate global index'

"global index" is not clear to someone who does not know about GNU
global, could you change it to "Generate to GNU global index"?


Michal
>  	@echo  '  kernelrelease	  - Output the release version string'
>  	@echo  '  kernelversion	  - Output the version stored in Makefile'
>  	@echo  '  headers_install - Install sanitised kernel headers to
> INSTALL_HDR_PATH'; \
> @@ -1379,7 +1380,7 @@ clean: $(clean-dirs)
>  quiet_cmd_tags = GEN     $@
>        cmd_tags = $(CONFIG_SHELL) $(srctree)/scripts/tags.sh $@
> 
> -tags TAGS cscope: FORCE
> +tags TAGS cscope gtags: FORCE
>  	$(call cmd,tags)
> 
>  # Scripts to check various things for consistency
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> index bbbe584..0a64ea4 100755
> --- a/scripts/tags.sh
> +++ b/scripts/tags.sh
> @@ -114,6 +114,11 @@ docscope()
>  	cscope -b -f cscope.out
>  }
> 
> +dogtags()
> +{
> +	all_sources | gtags -f -
> +}
> +
>  exuberant()
>  {
>  	all_sources | xargs $1 -a                               \
> @@ -187,6 +192,10 @@ case "$1" in
>  		docscope
>  		;;
> 
> +	"gtags")
> +		dogtags
> +		;;
> +
>  	"tags")
>  		rm -f tags
>  		xtags ctags

