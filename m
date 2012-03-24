Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755120Ab2CXWNv (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 18:13:51 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54673 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753610Ab2CXWNu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 18:13:50 -0400
Date: Sat, 24 Mar 2012 23:13:47 +0100
From: Michal Marek <mmarek@suse.cz>
To: Felipe Balbi <balbi@ti.com>
Cc: swarren@nvidia.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] scripts: dtc: fix compile warnings
Message-ID: <20120324221347.GA8947@sepie.suse.cz>
References: <1327576807-19216-1-git-send-email-balbi@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1327576807-19216-1-git-send-email-balbi@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 01:20:07PM +0200, Felipe Balbi wrote:
> Fix following compile warnings:
> 
> scripts/dtc/flattree.c: In function ‘flat_read_mem_reserve’:
> scripts/dtc/flattree.c:700:14: warning: variable ‘p’ set but not used
> 	[-Wunused-but-set-variable]
> 
> scripts/dtc/dtc.c: In function ‘main’:
> scripts/dtc/dtc.c:104:17: warning: variable ‘check’ set but not used
> 	[-Wunused-but-set-variable]
> 
> Signed-off-by: Felipe Balbi <balbi@ti.com>

This was somehow forgotten, I applied the patch to kbuild.git#kbuild now.

> ---
>  scripts/dtc/dtc.c      |    5 +----
>  scripts/dtc/flattree.c |    2 --
>  2 files changed, 1 insertions(+), 6 deletions(-)
> 
> diff --git a/scripts/dtc/dtc.c b/scripts/dtc/dtc.c
> index 451c92d..2ef5e2e 100644
> --- a/scripts/dtc/dtc.c
> +++ b/scripts/dtc/dtc.c
> @@ -101,7 +101,7 @@ int main(int argc, char *argv[])
>  	const char *outform = "dts";
>  	const char *outname = "-";
>  	const char *depname = NULL;
> -	int force = 0, check = 0, sort = 0;
> +	int force = 0, sort = 0;
>  	const char *arg;
>  	int opt;
>  	FILE *outf = NULL;
> @@ -143,9 +143,6 @@ int main(int argc, char *argv[])
>  		case 'f':
>  			force = 1;
>  			break;
> -		case 'c':
> -			check = 1;
> -			break;

BTW, you should also remove 'c' from the getopt() string.

Michal
