Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755791Ab0GGNt1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 09:49:27 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:64574 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755458Ab0GGNt0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 09:49:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] block: push BKL into blktrace ioctls
Date: Wed, 7 Jul 2010 15:46:53 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-19-generic; KDE/4.3.2; x86_64; ; )
Cc: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-scsi@vger.kernel.org
References: <1278193640-24223-1-git-send-email-arnd@arndb.de> <1278193640-24223-4-git-send-email-arnd@arndb.de> <20100707015036.GD2950@infradead.org>
In-Reply-To: <20100707015036.GD2950@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201007071546.53922.arnd@arndb.de>
X-Provags-ID: V02:K0:J5MMcTM8R2lg6A9bLH8NN0AVs8aoWEHQ7FWLMwgh00o
 X9fZij+P5cDRhsbrL/h2l3oe0PjanLAPcsLpaqmPMpo1RqCg5I
 Zx4nq976JZEdcp2vLHy7gAdsfC0LYwZWUKQ6zEFPPokXA+1WTJ
 haTzgYCtiw0fVSzYXOatbW1JaECjhzt5uxIs+1mSzFb1xl8DGl
 X5ydQccgn8DjSK+D8Sw3A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 07 July 2010, Christoph Hellwig wrote:
> On Sat, Jul 03, 2010 at 11:47:17PM +0200, Arnd Bergmann wrote:
> > The blktrace driver currently needs the BKL, but
> > we should not need to take that in the block layer,
> > so just push it down into the driver itself.
> 
> Does blktrace actually need it?  Anyway, pushing it down is a good
> start.

I'm rather sure that the blktrace code does not need the BKL
specifically, but it probably needs some form of serialization.
Most of the blktrace code holds both the BKL and bdev->bd_mutex,
so the right solution is probably to remove the BKL and rely
on bd_mutex.

It should be straightforward to do for anyone who understands
the blktrace code.

	Arnd
