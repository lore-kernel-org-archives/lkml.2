Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758991Ab0FVKgu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 06:36:50 -0400
Received: from adelie.canonical.com ([91.189.90.139]:59299 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab0FVKgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 06:36:48 -0400
Date: Tue, 22 Jun 2010 11:36:44 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] checkpatch.pl: Add check for space after struct or
 union definition
Message-ID: <20100622103644.GE4032@shadowen.org>
References: <1276768624.1005.34.camel@Joe-Laptop.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1276768624.1005.34.camel@Joe-Laptop.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 17, 2010 at 02:57:04AM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  scripts/checkpatch.pl |   10 ++++++++++
>  1 files changed, 10 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index bd88f11..59084fe 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1876,6 +1876,16 @@ sub process {
>  			ERROR("open brace '{' following function declarations go on the next line\n" . $herecurr);
>  		}
>  
> +# missing space after union or struct definition
> +		if ($rawline =~ /^\+\s*(union|struct)\s+$Ident[=\{]/) {
> +		    WARN("Missing space after struct or union definition\n" . $herecurr);
> +		}
> +
> +# missing space after enum definition
> +		if ($rawline =~ /^\+\s*enum\{/) {
> +		    WARN("Missing space after enum definition\n" . $herecurr);
> +		}
> +
>  # open braces for enum, union and struct go on the same line.
>  		if ($line =~ /^.\s*{/ &&
>  		    $prevline =~ /^.\s*(?:typedef\s+)?(enum|union|struct)(?:\s+$Ident)?\s*$/) {

I suspect that these checks should not be against the raw line, as that
would make them match in comments and in strings as well.  Also I
suspect that you also want to apply this match against union/struct {.

I'll have a look.

-apw
