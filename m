Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756580Ab1GJSuD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jul 2011 14:50:03 -0400
Received: from mail.perches.com ([173.55.12.10]:3805 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756483Ab1GJSuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jul 2011 14:50:01 -0400
Subject: Re: [PATCH] scripts/checkpatch.pl: added test for repeated lines
From: Joe Perches <joe@perches.com>
To: Edwin van Vliet <edwin@cheatah.nl>
Cc: apw@canonical.com, linux-kernel@vger.kernel.org
In-Reply-To: <1310321889-25943-1-git-send-email-edwin@cheatah.nl>
References: <1310321889-25943-1-git-send-email-edwin@cheatah.nl>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 10 Jul 2011 11:49:58 -0700
Message-ID: <1310323798.3848.48.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-07-10 at 20:18 +0200, Edwin van Vliet wrote:
> Repeated lines may indicate a bug or code that needs clarification. If the
> repeated line is intentional, an extra comment may be helpful for reviewers
> since the repeated pattern is likely to draw attention.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> @@ -1479,6 +1479,11 @@ sub process {
> +# check for repeated lines which may indicate bugs or lack of clarity
> +		if ($rawline eq $prevrawline) {
> +			WARN("repeated line\n" . $herecurr);
> +		}
> +

Interest concept, but I think it needs to check for
comment lines and blank lines and such.

Also, there are uses of appropriate multiple close braces
on consecutive lines like:

	switch (foo) {
	case bar: {
		etc...
	}
	}



