Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755351Ab0KAWIZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 18:08:25 -0400
Received: from swampdragon.chaosbits.net ([90.184.90.115]:23614 "EHLO
	swampdragon.chaosbits.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab0KAWIY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 18:08:24 -0400
Date: Mon, 1 Nov 2010 22:57:51 +0100 (CET)
From: Jesper Juhl <jj@chaosbits.net>
To: Joe Perches <joe@perches.com>
cc: linux-kernel@vger.kernel.org, Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH 4/4] scripts/checkpatch.pl: Add check for k.alloc GFP as
 first argument
In-Reply-To: <eee6800a4709ced7a513bd588fa0c16fd5790c80.1288555099.git.joe@perches.com>
Message-ID: <alpine.LNX.2.00.1011012255060.12889@swampdragon.chaosbits.net>
References: <cover.1288555098.git.joe@perches.com> <eee6800a4709ced7a513bd588fa0c16fd5790c80.1288555099.git.joe@perches.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 31 Oct 2010, Joe Perches wrote:

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 90b54d4..114f667 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -2789,6 +2789,11 @@ sub process {
>  			WARN("unnecessary cast may hide bugs, see http://c-faq.com/malloc/mallocnocast.html\n" . $herecurr);
>  		}
>  
> +# check for k.alloc GFP in wrong location
> +		if ($line =~ /\bk[czm]alloc\s*\(\s*\(?\s*GFP_/) {

Just off the top of my head, but shouldn't this check for \s*_*GFP_ in 
order to catch things like __GFP_ZERO as well?
And what about functions like kmalloc_node()/vmalloc_node() which may also 
have this problem?

> +			ERROR("alloc has GFP_<level> as last argument\n" . $herecurr);
> +		}
> +
>  # check for gcc specific __FUNCTION__
>  		if ($line =~ /__FUNCTION__/) {
>  			WARN("__func__ should be used instead of gcc specific __FUNCTION__\n"  . $herecurr);
> 

-- 
Jesper Juhl <jj@chaosbits.net>             http://www.chaosbits.net/
Plain text mails only, please      http://www.expita.com/nomime.html
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html

