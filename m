Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752668Ab1FHUYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 16:24:38 -0400
Received: from dsl-67-204-24-19.acanac.net ([67.204.24.19]:50682 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750846Ab1FHUYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 16:24:36 -0400
Date: Wed, 8 Jun 2011 16:24:08 -0400
From: Nick Bowler <nbowler@elliptictech.com>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        anish singh <anish198519851985@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@xenotime.net>,
        Andy Whitcroft <apw@canonical.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Validate signature styles and To: and Cc:
 lines
Message-ID: <20110608202408.GA20393@elliptictech.com>
References: <BANLkTi=AFbSXzjRHuY=uBFz=64C6vWLwNA@mail.gmail.com>
 <100617f66cdceab04a87514d47929a4ec3aebc19.1307561278.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <100617f66cdceab04a87514d47929a4ec3aebc19.1307561278.git.joe@perches.com>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-08 12:34 -0700, Joe Perches wrote:
> Signatures have many forms and can sometimes cause problems
> if not in the correct format when using git send-email or quilt.
> 
> Try to verify the signature tags and email addresses to use
> the generally accepted "Signed-off-by: Full Name <email@domain.tld>"
> form.
[...]
> +			my $suggested_email = format_email(parse_email($email));
> +			if ($suggested_email eq "") {
> +				ERROR("email address '$email' is unrecognizable\n" . $herecurr);
> +			} elsif ($suggested_email ne $email) {
> +				WARN("email address '$email' might be better as '$suggested_email'\n" . $herecurr);

If you're going to make suggestions, you should at the very least ensure
that the suggestions are actually valid email addresses.  Otherwise,
this script will suggest replacing valid addresses with invalid ones!

In particular, angle brackets inside "quotes" or (comments) will
seriously trip up this script.  For example:

  WARNING: email address '"Foo Bar <x124>" <fbar@example.org>' might be
  better as 'Foo Bar <x124>"<fbar@example.org>' #8: 
  Signed-off-by: "Foo Bar <x124>" <fbar@example.org>

Even more amusing is that we can actually follow the bogus suggestion
and checkpatch.pl won't complain about the resulting invalid email
address (at least it's consistent, I guess):

  Signed-off-by: Foo Bar <x124>"<fbar@example.org>

  patch has no obvious style problems and is ready for submission.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
