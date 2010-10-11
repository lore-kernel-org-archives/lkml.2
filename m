Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756073Ab0JKTvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 15:51:21 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:40412 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755925Ab0JKTvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 15:51:20 -0400
Date: Mon, 11 Oct 2010 12:49:16 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Nicolas Palix <npalix.work@gmail.com>
Cc: Julia Lawall <julia@diku.dk>, Michal Marek <mmarek@suse.cz>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Subject: Re: [PATCH 2/6] Coccinelle: Update documentation
Message-Id: <20101011124916.7c3f313d.randy.dunlap@oracle.com>
In-Reply-To: <1286566061-17122-3-git-send-email-npalix.work@gmail.com>
References: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>
	<1286566061-17122-3-git-send-email-npalix.work@gmail.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  8 Oct 2010 21:27:37 +0200 Nicolas Palix wrote:

>  - Add information about use of the C={1,2} make flag
>  - Add a description of the new chain mode mechanism
>  - Add a link to the wiki
> 
> Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Michal,
I guess that you will merge this one with the other Coccinelle patches?

Thanks.

Nicolas, please see comments below.

> ---
>  Documentation/coccinelle.txt |   42 +++++++++++++++++++++++++++++++++++-------
>  1 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index cd2b028..a43eaeb 100644
> --- a/Documentation/coccinelle.txt
> +++ b/Documentation/coccinelle.txt
> @@ -24,6 +24,9 @@ of many distributions, e.g. :
>  You can get the latest version released from the Coccinelle homepage at
>  http://coccinelle.lip6.fr/
>  
> +Information and tips about Coccinelle are also provided on the wiki
> +pages at http://cocci.ekstranet.diku.dk/wiki/doku.php
> +
>  Once you have it, run the following command:
>  
>       	./configure
> @@ -41,20 +44,22 @@ A Coccinelle-specific target is defined in the top level
>  Makefile. This target is named 'coccicheck' and calls the 'coccicheck'
>  front-end in the 'scripts' directory.
>  
> -Four modes are defined: report, patch, context, and org. The mode to
> +Four modes are defined: patch, report, context, and org. The mode to
>  use is specified by setting the MODE variable with 'MODE=<mode>'.
>  
> +'patch' proposes a fix, when possible.
> +
>  'report' generates a list in the following format:
>    file:line:column-column: message
>  
> -'patch' proposes a fix, when possible.
> -
>  'context' highlights lines of interest and their context in a
>  diff-like style.Lines of interest are indicated with '-'.
>  
>  'org' generates a report in the Org mode format of Emacs.
>  
> -Note that not all semantic patches implement all modes.
> +Note that not all semantic patches implement all modes. To easy use

                                                           For easy use

> +of Coccinelle, the default mode is "chain" which tries the previous
> +modes in the order above until one successes. 

                            until one succeeds.

Also, please drop trailing spaces.

>  
>  To make a report for every semantic patch, run the following command:
>  
> @@ -68,9 +73,9 @@ To produce patches, run:
>  
>  
>  The coccicheck target applies every semantic patch available in the
> -subdirectories of 'scripts/coccinelle' to the entire Linux kernel.
> +sub-directories of 'scripts/coccinelle' to the entire Linux kernel.
>  
> -For each semantic patch, a changelog message is proposed.  It gives a
> +For each semantic patch, a commit message is proposed.  It gives a
>  description of the problem being checked by the semantic patch, and
>  includes a reference to Coccinelle.
>  
> @@ -93,12 +98,35 @@ or
>  	make coccicheck COCCI=<my_SP.cocci> MODE=report
>  
>  
> + Using Coccinelle on (modified) files
> +~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> +
> +To apply Coccinelle on a file basis, instead of a directory basis, the
> +following command may be used:
> +    
> +    make C=1 CHECK="scripts/coccicheck"
> +    
> +To check only newly edited code, use the value 2 for the C flag, i.e.
> +    
> +    make C=2 CHECK="scripts/coccicheck"
> +    
> +This runs every semantic patch in scripts/coccinelle by default. The
> +COCCI variable may additionally be used to only apply a single
> +semantic patch as shown in the previous section.
> +
> +The "chain" mode is the default. You can select another one with the
> +MODE variable explained above.
> +
> +In this mode, there is no information about semantic patches
> +displayed, and no commit message proposed.
> +
> +
>   Proposing new semantic patches
>  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>  
>  New semantic patches can be proposed and submitted by kernel
>  developers. For sake of clarity, they should be organized in the
> -subdirectories of 'scripts/coccinelle/'.
> +sub-directories of 'scripts/coccinelle/'.
>  
>  
>   Detailed description of the 'report' mode
> -- 


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
