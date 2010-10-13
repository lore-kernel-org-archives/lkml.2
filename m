Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111Ab0JMMaE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 08:30:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:40507 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754076Ab0JMMaB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 08:30:01 -0400
Message-ID: <4CB5A646.3030003@suse.cz>
Date: Wed, 13 Oct 2010 14:29:58 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100714 SUSE/3.1.1 Thunderbird/3.1.1
MIME-Version: 1.0
To: Nicolas Palix <Nicolas.Palix@inria.fr>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, Julia Lawall <julia@diku.dk>,
        Kulikov Vasiliy <segooon@gmail.com>,
        Gilles Muller <Gilles.Muller@lip6.fr>, Sam Ravnborg <sam@ravnborg.org>,
        Joerg Roedel <joerg.roedel@amd.com>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, cocci@diku.dk
Subject: Re: [PATCH 2/6] Coccinelle: Update documentation
References: <1286566061-17122-1-git-send-email-npalix.work@gmail.com>	<1286566061-17122-3-git-send-email-npalix.work@gmail.com>	<20101011124916.7c3f313d.randy.dunlap@oracle.com> <AANLkTi=OmdCVmXK_373aKua4-JZg569mxPDMrfw=Y4F_@mail.gmail.com>
In-Reply-To: <AANLkTi=OmdCVmXK_373aKua4-JZg569mxPDMrfw=Y4F_@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13.10.2010 00:49, Nicolas Palix wrote:
>  - Add information about use of the C={1,2} make flag
>  - Add a description of the new chain mode mechanism
>  - Add a link to the wiki
> 
> Signed-off-by: Nicolas Palix <npalix.work@gmail.com>
> Signed-off-by: Julia Lawall <julia@diku.dk>

Thanks, I applied the whole series to kbuild-2.6.git#misc.

Michal

> ---
> This is a resubmission that fixes trailing whitespaces and a typo.
> 
>  Documentation/coccinelle.txt |   42 +++++++++++++++++++++++++++++++++++-------
>  1 files changed, 35 insertions(+), 7 deletions(-)
> 
> diff --git a/Documentation/coccinelle.txt b/Documentation/coccinelle.txt
> index cd2b028..de51a3e 100644
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
> +Note that not all semantic patches implement all modes. For easy use
> +of Coccinelle, the default mode is "chain" which tries the previous
> +modes in the order above until one succeeds.
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

