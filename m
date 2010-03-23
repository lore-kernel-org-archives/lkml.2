Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752844Ab0CWMIx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 08:08:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56524 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006Ab0CWMIw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 08:08:52 -0400
Message-ID: <4BA8AF52.80202@suse.cz>
Date: Tue, 23 Mar 2010 13:08:50 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH] kbuild: Include gen_initramfs_list.sh and the file list
 in	the .d file
References: <20100322224932.GA26068@obsidianresearch.com>
In-Reply-To: <20100322224932.GA26068@obsidianresearch.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22.3.2010 23:49, Jason Gunthorpe wrote:
> Expand the dependency set used for the initrd to include the
> CONFIG_INITRAMFS_SOURCE file and the generator script itself.
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  scripts/gen_initramfs_list.sh |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> Otherwise changing the initramfs file list does not rebuild the CPIO..

Thanks, applied.

Michal
> 
> diff --git a/scripts/gen_initramfs_list.sh b/scripts/gen_initramfs_list.sh
> index 76af5f9..f3b5c05 100644
> --- a/scripts/gen_initramfs_list.sh
> +++ b/scripts/gen_initramfs_list.sh
> @@ -202,6 +202,7 @@ input_file() {
>  			print_mtime "$1" >> ${output}
>  			cat "$1"         >> ${output}
>  		else
> +		        echo "$1 \\"
>  			cat "$1" | while read type dir file perm ; do
>  				if [ "$type" == "file" ]; then
>  					echo "$file \\";
> @@ -231,7 +232,7 @@ arg="$1"
>  case "$arg" in
>  	"-l")	# files included in initramfs - used by kbuild
>  		dep_list="list_"
> -		echo "deps_initramfs := \\"
> +		echo "deps_initramfs := $0 \\"
>  		shift
>  		;;
>  	"-o")	# generate compressed cpio image named $1

