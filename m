Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1JJRKB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:10:01 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:56048 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751866Ab1JJRKA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:10:00 -0400
Message-ID: <1318266599.27825.12.camel@Joe-Laptop>
Subject: Re: [PATCH] checkpatch: warn on found Change-Id lines
From: Joe Perches <joe@perches.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, apw@canonical.com
Date: Mon, 10 Oct 2011 10:09:59 -0700
In-Reply-To: <1318226216-5317-1-git-send-email-olof@lixom.net>
References: <1318226216-5317-1-git-send-email-olof@lixom.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.0- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-09 at 22:56 -0700, Olof Johansson wrote:
> Some external projects use repo, which uses a special-format Change-Id
> field in the commit message for some internal bookkeeping (to re-associate
> patches back to review entries, etc).

I believe Andrew has a patch from me in his queue
somewhere that tries to isolate the commit message
and does a couple of checks just on that content.

> Sometimes they sneak into patches
> going upstream, which is embarrassing for the developer, and annoying
> for the maintainer.
> 
> Add checking for these to checkpatch, to catch them before
> posting. Provide a way to disable the check to keep checkpatch useful
> for intra-project use.
[]
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
[]
> +my $chk_changeid = 1;

> +  --no-change-id             don't complain about 'Change-Id' lines

Adding piecemeal option overrides could eventually
make these sorts of things quite long.

Perhaps it's better to use:
--ignore=CHANGE_ID

or add a .checkpatch.conf file somewhere with this.

> +	'change-id!'	=> \$chk_changeid,

> +$chk_changeid = 0 if ($file);

> +# Check for Change-Id lines:
> +		if ($line =~ /^\s*change-id:/i && $chk_changeid) {
> +			ERROR("CHANGE_ID", "Found Change-Id line\n", $herecurr);
> +		}

I believe this will also match lines in any
patch context, so maybe this is not good.

I think this should be placed adjacent to the
RCS/CVS check.

Maybe it's better to add some "VCS_CRUFT"
option and track/emit all the RCS/SCCS/PVS/CVS
crud in one bundle.


