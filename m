Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754126Ab2J0Mpg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 08:45:36 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:44056 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2J0Mpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 08:45:34 -0400
From: Nix <nix@esperi.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
References: <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508AF3FA.4020506@redhat.com>
	<87wqydx957.fsf@spindle.srvr.nix> <20121026205618.GC8614@thunk.org>
	<87objpx84k.fsf@spindle.srvr.nix> <20121026211542.GE8614@thunk.org>
	<87haphx76u.fsf@spindle.srvr.nix> <20121027002258.GB31030@thunk.org>
Emacs: a compelling argument for pencil and paper.
Date: Sat, 27 Oct 2012 13:45:25 +0100
In-Reply-To: <20121027002258.GB31030@thunk.org> (Theodore Ts'o's message of
	"Fri, 26 Oct 2012 20:22:58 -0400")
Message-ID: <873910xevu.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-wuwien-Metrics: spindle 1290; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[nfs people purged from Cc]

On 27 Oct 2012, Theodore Ts'o verbalised:

> Huh?  It's not turned on by default.  If you mount with no mount
> options, journal checksums are *not* turned on.

?! it's turned on for me, and though I use weird mount options I don't
use that one:

/dev/main/var   /var        ext4        defaults,nobarrier,usrquota,grpquota,nosuid,nodev,relatime,journal_async_commit,commit=30,user_xattr,acl 1  2
Default mount options:    (none)
/dev/mapper/main-var /var ext4 rw,nosuid,nodev,relatime,journal_checksum,journal_async_commit,nobarrier,quota,usrquota,grpquota,commit=30,stripe=16,data=ordered,usrquota,grpquota 0 0

...

Ah! it's turned on by journal_async_commit. OK, that alone argues
against use of journal_async_commit, tested or not, and I'd not have
turned it on if I'd noticed that.

(So, the combinations I'll be trying for effect on this bug are:

 journal_async_commit (as now)
 journal_checksum
 none

Technically to investigate all possibilities we should try
journal_async_commit,no_journal_checksum, but this seems so unlikely to
have ever been tested by anyone that it's not worth looking into...)

-- 
NULL && (void)
