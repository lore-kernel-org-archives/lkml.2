Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2EBMC6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 08:02:58 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55878 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753827Ab2EBMC4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 08:02:56 -0400
Date: Wed, 2 May 2012 13:05:31 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Message-ID: <20120502130531.4b7d98fa@pyramind.ukuu.org.uk>
In-Reply-To: <4FA11963.3040007@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
	<4FA1092E.9090603@redhat.com>
	<20120502115447.7dcc3a54@pyramind.ukuu.org.uk>
	<4FA11454.2010103@redhat.com>
	<20120502121208.3c19a9bc@pyramind.ukuu.org.uk>
	<4FA11963.3040007@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> not inventing anything, the old ATA subsystem is already blocking most
> "dangerous" ioctls for partitions, even if you have CAP_SYS_RAWIO.

It blocked a few by default to protect hardware. It's a tricky tradeoff,
which is quite different to this.

> Now of course CAP_SYS_RAWIO lets you use ioperm or iopl, but that's a
> separate issue and only limited to x86.

Ie only 99.99% of the systems running desktop/server Linux OS designs.

> Almost any capability can be abused to bypass checks.  True,
> CAP_SYS_RAWIO is especially good at that, but still you can try.

Why try - you are seeking to arbitarily impose your own worldview on the
interface (and in doing so break back compatibility). The whole basis of
the Unix philosophy is that the OS shouldn't try and micromanage the
priviledged apps because that just leads to crap code.

Think "small government" on this aspect of design. And with the patch you
propose the analogy for your patch is the TSA.

> > A process with CAP_SYS_RAWIO has total power. It's assumed to know what
> > it is doing. Trying to block it doing stuff like that simply makes
> > authors do them via different more crass methods.
> 
> Getting appropriate permission on device nodes is less crass than
> abusing partition device nodes.

Given a passed file handle how do you do that securely. Remember that
open /dev/foo while you have a handle on /dev/foo1 could open a
different disk if a hotplug has occurred.

So there are good reasons to keep the partition behaviour.

Alan




