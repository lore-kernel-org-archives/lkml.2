Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab2EBKwR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:52:17 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55787 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab2EBKwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:52:16 -0400
Date: Wed, 2 May 2012 11:54:47 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: Jan Kara <jack@suse.cz>, Jens Axboe <axboe@kernel.dk>,
        LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to
 partition
Message-ID: <20120502115447.7dcc3a54@pyramind.ukuu.org.uk>
In-Reply-To: <4FA1092E.9090603@redhat.com>
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
	<4FA1092E.9090603@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2012 12:15:10 +0200
Paolo Bonzini <pbonzini@redhat.com> wrote:

> Il 02/05/2012 12:10, Jan Kara ha scritto:
> > Sometimes, warnings about ioctls to partition happen often enough that they
> > form majority of the warnings in the kernel log and users complain. In some
> > cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> > the warnings completely as they can ease debugging of userspace problems
> > when ioctl is refused.
> > 
> > Since I have seen warnings from lots of commands, including some proprietary
> > userspace applications, I don't think disallowing the ioctls for processes
> > with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> > stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.
> 
> NACK.  I would bet that all the warnings you've seen are for ioctl that
> would have failed anyway with ENOTTY.

Then we don't need the bogus warning do we.

Alan
