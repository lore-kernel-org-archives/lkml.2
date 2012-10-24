Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161027Ab2JXTZE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 15:25:04 -0400
Received: from plane.gmane.org ([80.91.229.3]:39271 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145Ab2JXTZC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 15:25:02 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Jannis Achstetter <jannis_achstetter@web.de>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
Date: Wed, 24 Oct 2012 21:13:01 +0200
Message-ID: <k69ejs$vt2$1@ger.gmane.org>
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <20121023221913.GC28626@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: p4ff5ad8e.dip.t-dialin.net
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121022 Thunderbird/16.0.1
In-Reply-To: <20121023221913.GC28626@thunk.org>
Cc: linux-ext4@vger.kernel.org, stable@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.10.2012 00:19, schrieb Theodore Ts'o:
> [...]
> The reason why the problem happens rarely is that the effect of the
> buggy commit is that if the journal's starting block is zero, we fail
> to truncate the journal when we unmount the file system.  This can
> happen if we mount and then unmount the file system fairly quickly,
> before the log has a chance to wrap.  After the first time this has
> happened, it's not a disaster, since when we replay the journal, we'll
> just replay some extra transactions.  But if this happens twice, the
> oldest valid transaction will still not have gotten updated, but some
> of the newer transactions from the last mount session will have gotten
> written by the very latest transacitons, and when we then try to do
> the extra transaction replays, the metadata blocks can end up getting
> very scrambled indeed.
> [...]

As a "normal linux user" I'm interested in the practical things to do
now to avoid data loss. I'm running several systems with 3.6.2 and ext4.
Fearing loss of data:
- Is there a way to see whether the journal of a specific partition has
been wrapped (since mounting) so that umounting and mounting (or doing a
reboot to downgrade the kernel) is safe?
- Is there a way to "force" a journal-wrap? Run any
filesystem-benchmark? Which one with what parameters? Or is it unwise
since I might even further corrupt data if I hit the case already?
- Is it wise to umount now and run e2fsck or might I corrupt my files
just by umounting now if the journal hasn't wrapped yet?
- How do you define "fairly quickly"? Of course servers run 24/7 but I
might be using my PC 2-5 hrs a day... Is that a "reboot to soon after
booting"?
- Any more advice you can give to the ordinary user to avoid
fs-corruption? Don't shut down machines for some days? Better down- or
upgrade the kernel?

Best regards,
	Jannis Achstetter


