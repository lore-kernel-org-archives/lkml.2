Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab1JZUaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:30:13 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35978 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab1JZUaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:30:12 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=MsUHoGEyVdbfuQvivpxUuUjFA1QzUAxQV7Vybp3Syiq4lFDLUOy6uim75GF7OZ2s/
	zWicdBjzEhn0T0C00Fd/g==
Date: Wed, 26 Oct 2011 13:30:07 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Wolfram Sang <w.sang@pengutronix.de>
cc: linux-kernel@vger.kernel.org, Jonathan Cameron <jic23@cam.ac.uk>,
        Andy Whitcroft <apw@canonical.com>
Subject: Re: [PATCH] checkpatch: improve error message for p1-check
In-Reply-To: <1319027583-17842-1-git-send-email-w.sang@pengutronix.de>
Message-ID: <alpine.DEB.2.00.1110261329240.23111@chino.kir.corp.google.com>
References: <1319027583-17842-1-git-send-email-w.sang@pengutronix.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Wolfram Sang wrote:

> The old error message was not precise. State now explicitly that the
> prefix exists as a file/directory. Also change the conclusion ("appears
> to be") into an instruction ("make sure").
> 

Why can't we suppress this warning unless both prefixes appear as files or 
directories in the cwd?  ('a' and 'b' if using git format-patch)

> Signed-off-by: Wolfram Sang <w.sang@pengutronix.de>
> Acked-by: Jonathan Cameron <jic23@cam.ac.uk>
> Cc: Andy Whitcroft <apw@canonical.com>
> ---
>  scripts/checkpatch.pl |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> index 3dfc471..4bb4f88 100755
> --- a/scripts/checkpatch.pl
> +++ b/scripts/checkpatch.pl
> @@ -1506,7 +1506,7 @@ sub process {
>  			if (!$file && $tree && $p1_prefix ne '' &&
>  			    -e "$root/$p1_prefix") {
>  				WARN("PATCH_PREFIX",
> -				     "patch prefix '$p1_prefix' exists, appears to be a -p0 patch\n");
> +				     "patch prefix '$p1_prefix' exists as file/directory. Make sure this isn't a -p0 patch\n");
>  			}
>  
>  			if ($realfile =~ m@^include/asm/@) {
