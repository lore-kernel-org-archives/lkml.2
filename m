Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933000Ab0EKGh3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 02:37:29 -0400
Received: from ist.d-labs.de ([213.239.218.44]:60883 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932354Ab0EKGh1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 02:37:27 -0400
From: florian@mickler.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, linux-kernel@vger.kernel.org,
       Stephen Hemminger <shemminger@vyatta.com>,
       Florian Mickler <florian@mickler.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Joe Perches <joe@perches.com>
Subject: [PATCH] scripts/get_maintainer.pl: default to not include unspecified tags
Date: Tue, 11 May 2010 08:36:36 +0200
Message-Id: <1273559797-6910-1-git-send-email-florian@mickler.org>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <30a2fd47565ff33d6f47d9a76746b56d923856ac.1273466698.git.joe@perches.com>
References: <30a2fd47565ff33d6f47d9a76746b56d923856ac.1273466698.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This changes the default of the option --git-all-signature-types to be
disabled by default.

The effect being, that only certain (currently  Signed-Off-By:,
Acked-By: and Reviewed-By:) tags are used to get adresses of potential
maintainers.

Motivated is this change by the desire to not 'spam' people unnecessary:
A Tested-By or a Reported-By is not ment as a hint that those people
want to/are able to review patches to the code in question.

In a quest to find resilient statistics for this i came up with this:

I produced a list of all the tag-signers not already covered
with a signed-off/acked/reviewed tag somewhere in the last year of git history.

Those were 650 addresses of "assumed non-developers".

And to check if those "assumed non-developers" are professional
testers/reporters worth cc'ing, i then counted their total appearences
in the git log:

469 were mentioned only once.
123 were mentioned twice.
38 three times
8 four times
5 six times
5 five times
1 eight times
1 fourteen times

I believe this supports my thesis, that the ''non-maintainer-tags'' are
not actively useful for patch-review. (except probably the guy
mentioned fourteen times...)

But of course one could also find arguments to poke holes in this
statistics, for example does this statistic not include code-locality:
A tested-by on a patch that touches some specific piece of
code can be more worth than a signed-off in another part of the tree.

But... let's play it safe and let's err on the "safe" side
meaning to not spam those people when in doubt. We already have the
signed-off's and Maintainers file. So this should be ok. And if need be, 
the maintainers can always forward the patch.

[i probably could make a diploma thesis out of this changelog :)]

Signed-off-by: Florian Mickler <florian@mickler.org>
---
 scripts/get_maintainer.pl |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
index b82ac95..b228198 100755
--- a/scripts/get_maintainer.pl
+++ b/scripts/get_maintainer.pl
@@ -25,7 +25,7 @@ my $email_list = 1;
 my $email_subscriber_list = 0;
 my $email_git_penguin_chiefs = 0;
 my $email_git = 1;
-my $email_git_all_signature_types = 1;
+my $email_git_all_signature_types = 0;
 my $email_git_blame = 0;
 my $email_git_min_signatures = 1;
 my $email_git_max_maintainers = 5;
-- 
1.7.0.4

