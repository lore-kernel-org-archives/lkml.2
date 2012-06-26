Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab2FZPdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 11:33:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23357 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757736Ab2FZPdY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 11:33:24 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: axboe@kernel.dk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, tj@kernel.org, hch@infradead.org,
        vgoyal@redhat.com, dm-devel@redhat.com
Subject: Re: [RFC PATCH] block: all callers should check blkdev_issue_flush's return
References: <1340724445-3314-1-git-send-email-snitzer@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Tue, 26 Jun 2012 11:33:10 -0400
In-Reply-To: <1340724445-3314-1-git-send-email-snitzer@redhat.com> (Mike
	Snitzer's message of "Tue, 26 Jun 2012 11:27:25 -0400")
Message-ID: <x498vfarsuh.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Snitzer <snitzer@redhat.com> writes:

> It is concerning that a FLUSH may fail but the blkdev_issue_flush
> callers assume it will always succeed.
>
> Each blkdev_issue_flush caller should come to terms with the reality
> that a FLUSH may fail -- the file_operations' .fsync methods in
> particular.  nilfs2 is the only filesystem that checks
> blkdev_issue_flush's return.

Yeah, as it stands, it looks like in many cases fsync won't return an
error if a flush fails.  That's bad.
