Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab2AXM4X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 07:56:23 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:44201 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab2AXM4V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 07:56:21 -0500
Message-ID: <4F1EAA6A.6020207@redhat.com>
Date: Tue, 24 Jan 2012 13:56:10 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.stable,gmane.linux.scsi
To: Ben Hutchings <ben@decadent.org.uk>
CC: stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>
Subject: Re: [PATCH stable 3/4] block: fail SCSI passthrough ioctls on partition
 devices
References: <1326772723.2819.167.camel@deadeye>  <1326773222.2819.172.camel@deadeye> <4F1545A4.3000809@redhat.com>  <1326862077.2819.210.camel@deadeye> <4F168A49.8000606@redhat.com> <1326902676.3271.10.camel@deadeye>
In-Reply-To: <1326902676.3271.10.camel@deadeye>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2012 05:04 PM, Ben Hutchings wrote:
> >  There is harm.  You'll be blacklisting also the standard block device
> >  ioctls, and those won't work on 32-on-64 anymore.  A system with 32-bit
> >  userland will likely not boot anymore.
>
> It does (yes, I tested that myself now).  The standard block device
> ioctls are handled without calling the driver's compat_ioctl.

What about the non-compat path when done by non-root?

* Does BLKROSET still return EACCES when run by non-root and without 
CAP_SYS_ADMIN?  I suspect your patch is changing it to EINVAL.

* Does BLKFLSBUF work when run by non-root but with CAP_SYS_ADMIN?

Paolo
