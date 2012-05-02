Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752771Ab2EBKPo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 06:15:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:60243 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751379Ab2EBKPm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 06:15:42 -0400
Message-ID: <4FA1092E.9090603@redhat.com>
Date: Wed, 02 May 2012 12:15:10 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: Jan Kara <jack@suse.cz>
CC: Jens Axboe <axboe@kernel.dk>, LKML <linux-kernel@vger.kernel.org>,
        James Bottomley <JBottomley@parallels.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Silence unnecessary warnings about ioctl to partition
References: <1335953452-10460-1-git-send-email-jack@suse.cz>
In-Reply-To: <1335953452-10460-1-git-send-email-jack@suse.cz>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 02/05/2012 12:10, Jan Kara ha scritto:
> Sometimes, warnings about ioctls to partition happen often enough that they
> form majority of the warnings in the kernel log and users complain. In some
> cases warnings are about ioctls such as SG_IO so it's not good to get rid of
> the warnings completely as they can ease debugging of userspace problems
> when ioctl is refused.
> 
> Since I have seen warnings from lots of commands, including some proprietary
> userspace applications, I don't think disallowing the ioctls for processes
> with CAP_SYS_RAWIO will happen in the near future if ever. So lets just
> stop warning for processes with CAP_SYS_RAWIO for which ioctl is allowed.

NACK.  I would bet that all the warnings you've seen are for ioctl that
would have failed anyway with ENOTTY.

The right fix has already been posted, we've been carrying it in RHEL
for over six months and not a single bug has been seen.

Paolo
