Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab2JZMMQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 08:12:16 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:38500 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932469Ab2JZMMO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 08:12:14 -0400
From: Nix <nix@esperi.org.uk>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Ric Wheeler <ricwheeler@gmail.com>, Eric Sandeen <sandeen@redhat.com>,
        linux-kernel@vger.kernel.org, "J. Bruce Fields" <bfields@fieldses.org>,
        Bryan Schumaker <bjschuma@netapp.com>
Subject: Re: Apparent serious progressive ext4 data corruption bug in 3.6.3 (and other stable branches?)
References: <87objupjlr.fsf@spindle.srvr.nix>
	<20121023013343.GB6370@fieldses.org> <87mwzdnuww.fsf@spindle.srvr.nix>
	<20121023143019.GA3040@fieldses.org>
	<874nllxi7e.fsf_-_@spindle.srvr.nix>
	<87pq48nbyz.fsf_-_@spindle.srvr.nix> <508740B2.2030401@redhat.com>
	<87txtkld4h.fsf@spindle.srvr.nix> <5089D520.6020106@gmail.com>
	<20121026004326.GB10509@thunk.org>
Emacs: because Hell was full.
Date: Fri, 26 Oct 2012 13:12:01 +0100
In-Reply-To: <20121026004326.GB10509@thunk.org> (Theodore Ts'o's message of
	"Thu, 25 Oct 2012 20:43:26 -0400")
Message-ID: <87liet1lgu.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-DCC-URT-Metrics: spindle 1060; Body=6 Fuz1=6 Fuz2=6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 26 Oct 2012, Theodore Ts'o spake thusly:

> On Thu, Oct 25, 2012 at 08:11:12PM -0400, Ric Wheeler wrote:
>> 
>> Sending this just to you two to avoid embarrassing myself if I
>> misread the thread, but....
>> 
>> Can we reproduce this with any other hardware RAID card? Or with MD?
>
> There was another user who reported very similar corruption using
> 3.6.2 using USB thumb drive.  I can't be certain that it's the same
> bug that's being triggered, but the symptoms were identical.

I now suspect it's the same bug, triggered in a different way, but also
by a block-layer problem -- instead of the block device driver not
blocking while the umount finishes (or throwing some of the data umount
writes away, whichever it is, not yet known), the block device goes away
because someone pulled it out of the USB socket. In any case, it appears
that an ext4 umount being interrupted while data is being written does
bad, bad things to the filesystem.

>> If we cannot reproduce this in other machines, why assume this is an
>> ext4 issue and not a hardware firmware bug?

A tad unlikely. Why would a firmware bug show up only at the instant of
reboot? Why would it show up as a lack of blocking on the kernel side? I
assure you that if you write lots of data to this controller normally,
you will end up blocking :) I can completely believe that it's an arcmsr
driver bug though. If it was an ext4 bug, it would surely be
reproducible in virtualization, or on different hardware, or something
like that.

-- 
NULL && (void)
