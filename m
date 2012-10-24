Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758814Ab2JXVEz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 17:04:55 -0400
Received: from mout.web.de ([212.227.17.11]:63549 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755618Ab2JXVEy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 17:04:54 -0400
Message-ID: <508857F2.9000206@web.de>
Date: Wed, 24 Oct 2012 23:04:50 +0200
From: Jannis Achstetter <jannis_achstetter@web.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121022 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3
 (and other stable branches?)
References: <87objupjlr.fsf@spindle.srvr.nix> <20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix> <20121023143019.GA3040@fieldses.org> <874nllxi7e.fsf_-_@spindle.srvr.nix> <87pq48nbyz.fsf_-_@spindle.srvr.nix> <20121023221913.GC28626@thunk.org>
In-Reply-To: <20121023221913.GC28626@thunk.org>
X-Enigmail-Version: 1.5a1pre
OpenPGP: url=subkeys.pgp.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:UKV2dWqV0IBUS/LqGxJfuG2Cx0ARpqjE9WWd0QkhDSu
 sGhCeGe0DOD6o9sAzIenoaLXTtTkvGxk8EnW7sfnaJA5DTjh7q
 ReqiJZZ62/c8xmINfib0txSJUK0s9NGWcLjdz14Py7UAoMQquo
 78McgCNiAKmgM/1NLRuxB8MFOoP/Z9Pi7WA94krnVZTtokkz4F
 cnDrODTMgvohUw6JbcOVFT1gL/rffizV7demqDzUhk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.10.2012 00:19, schrieb Theodore Ts'o:
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

Repost. Sorry, I don't mean to spam, I just don't see my first mail
(sent via gmane.org) anywhere, so ...

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

