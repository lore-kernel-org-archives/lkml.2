Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755803Ab0GGN2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:28:36 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52211 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab0GGN2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:28:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 1/6] block: push down BKL into .locked_ioctl
Date: Wed, 7 Jul 2010 15:28:30 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-2-git-send-email-arnd@arndb.de> <20100707015207.GE2950@infradead.org>
In-Reply-To: <20100707015207.GE2950@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007071528.30333.arnd@arndb.de>
X-Provags-ID: V02:K0:JNZij8VLx4Ehci2TD2bxSpBstjWv5HhdGukOaRKK2Cs
 Z8qn7Joacu+6gBN1nOLgHaEryB5vWdbUOSLfyJwLzX8O0h5Iov
 YnoqvNml0pNbdZ6BTTclnf4gwLNCTw0RLIF/VUsXS7I5iPsWOc
 rAd1sSElBZ/yLq6QESx+8uz/IlQSKloPiQhJFQMG/Rnf0aUFLq
 ingKtvlTymsW97OTrV7pg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 July 2010, Christoph Hellwig wrote:
> 
> Looking at this again I don't like the foo_unlock_ioctl naming you're
> adding.  Just rename the existing ioctl routines to foo_locked_ioctl
> or move the lock_kernel/unlock_kernel calls into the function, which
> would be even better.

Good point. I followed the naming that I used for the file_operations
conversion, but since the block_device_operations don't use .unlocked_ioctl,
the naming you suggested is better.

I've now changed the sr.c and sd.c to use include the lock_kernel() call
directly in their ioctl functions. For the various floppy drivers, I'd
prefer using separate wrappers because these drivers are mostly legacy
and any subtle bugs introduced could probably go unnoticed for years.

As I mentioned to Sam, I'm more confident with the wrapper than rewriting
a longish function that I can't test.

I also now changed the i2o_block driver ioctl function but split that out
into a separate patch, since I found two more existing issues with
that function that I'm addressing at the same time.

	Arnd
