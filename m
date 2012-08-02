Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753751Ab2HBQX1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:23:27 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:38409 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751485Ab2HBQX0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:23:26 -0400
Date: Thu, 2 Aug 2012 17:23:22 +0100
From: Andy Whitcroft <apw@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Schrober <franzschrober@yahoo.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Add control statement test to
 SINGLE_STATEMENT_DO_WHILE_MACRO
Message-ID: <20120802162322.GI2501@dm>
References: <4204029.7cYAuJfu4T@bentobox>
 <20120802142053.GH2501@dm>
 <1343921213.2011.9.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1343921213.2011.9.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 08:26:53AM -0700, Joe Perches wrote:

> The patch below is tested with:
> $ cat t.c
> 
> #define bar_1(foo)				\
> 	if (foo)				\
> 		baz();				\
> 
> #define bar_2(foo)				\
> do {						\
> 	if (foo)				\
> 		baz();				\
> } while (0)
> 
> #define bar_3(foo)				\
> do {						\
> 	baz();					\
> } while (0)
> 
> #define bar_4(foo)				\
> do {						\
> 	baz();					\
> } while (0);
> 
> #define bar_5(foo)				\
> do {						\
> 	while (foo)				\
> 		baz();				\
> } while (0)
> 
> #define bar_6(foo)				\
> do {						\
> 	switch (foo) {				\
> 	case 1:					\
> 		baz();				\
> 	}					\
> } while (0)
> 
> $
> 
> So perhaps...
> 
>  scripts/checkpatch.pl |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 913d6bd..ca05ba2 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -3016,7 +3016,8 @@ sub process {
>  					$herectx .= raw_line($linenr, $n) . "\n";
>  				}
>  
> -				if (($stmts =~ tr/;/;/) == 1) {
> +				if (($stmts =~ tr/;/;/) == 1 &&
> +				    $stmts !~ /^\s*(if|while|for|switch)\b/) {
>  					WARN("SINGLE_STATEMENT_DO_WHILE_MACRO",
>  					     "Single statement macros should not use a do {} while (0) loop\n" . "$herectx");
>  				}
> 
> 

Looks reasonable enough.

Acked-by: Andy Whitcroft <apw@canonical.com>

-apw
