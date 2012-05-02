Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab2EBLJc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 07:09:32 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55807 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752164Ab2EBLJb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 07:09:31 -0400
Date: Wed, 2 May 2012 12:12:08 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Message-ID: <20120502121208.3c19a9bc@pyramind.ukuu.org.uk>
In-Reply-To: <4FA11454.2010103@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
	<4FA1092E.9090603@redhat.com>
	<20120502115447.7dcc3a54@pyramind.ukuu.org.uk>
	<4FA11454.2010103@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sure, but then disallowing the ioctls for processes with CAP_SYS_RAWIO
> will not cause regressions and _can_ happen.  The transition period only

The user has CAP_SYS_RAWIO, they can already do it by poking the
registers on the chip directly. It is a nonsense to attempt to block or
warn about this.

> up and implement a very restrictive filter for SCSI commands sent to
> partition.

The process has CAP_SYS_RAWIO it can already bypass any check you try and
put in place.

> The right patch is one that prepares for these step,

Doesn't look very right to me.

> http://permalink.gmane.org/gmane.linux.kernel/1254625 for example.  It
> leaves the warning only for SG_IO, and silently blocks the rest (more
> rationale in the commit message there).

Even the printk in that patch is wrong. We have capabilities. Being a
"root" user is a meaningless distinction here so your ratelimited printk
isn't just bogus - its wrong. It may have got into RHEL somehow but the
kernel QA process is a bit higher standard than this proposed patch.

A process with CAP_SYS_RAWIO has total power. It's assumed to know what
it is doing. Trying to block it doing stuff like that simply makes
authors do them via different more crass methods.

Alan
