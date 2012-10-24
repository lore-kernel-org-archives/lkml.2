Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934480Ab2JXTyr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:54:47 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:60245 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab2JXTyn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:54:43 -0400
From: Nix <nix@esperi.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Eric Sandeen <sandeen@redhat.com>, linux-ext4@vger.kernel.org,
        linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Bryan Schumaker <bjschuma@netapp.com>, Peng Tao <bergwolf@gmail.com>,
        Trond.Myklebust@netapp.com, gregkh@linuxfoundation.org,
        Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <50876E1D.3040501@redhat.com>
	<20121024052351.GB21714@thunk.org> <878vavveee.fsf@spindle.srvr.nix>
Emacs: don't cry -- it won't help.
Date: Wed, 24 Oct 2012 20:54:32 +0100
In-Reply-To: <878vavveee.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of
	"Wed, 24 Oct 2012 20:49:45 +0100")
Message-ID: <87wqyftzlz.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-sonic.net-Metrics: spindle 1117; Body=10 Fuz1=10 Fuz2=10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24 Oct 2012, nix@esperi.org.uk uttered the following:
> So, the net effect of this is that normally I get no journal recovery on
> anything at all -- but sometimes, if umounting takes longer than a few
> seconds, I reboot with not everything unmounted, and journal recovery
> kicks in on reboot. My post-test fscks this time suggest that only when
> journal recovery kicks in after rebooting out of 2.6.3 do I see
> corruption. So this is indeed an unclean shutdown journal-replay
> situation: it just happens that I routinely have one or two fses
> uncleanly unmounted when all the rest are cleanly unmounted. This
> perhaps explains the scattershot nature of the corruption I see, and why
> most of my ext4 filesystems get off scot-free.

Note that two umounts are not required: fsck found corruption on /var
after a single boot+shutdown round in 3.6.3+this patch. (It did do a
journal replay on /var first.)

-- 
NULL && (void)
