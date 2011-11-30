Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755492Ab1K3N7c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 08:59:32 -0500
Received: from casper.infradead.org ([85.118.1.10]:59155 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751522Ab1K3N7a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 08:59:30 -0500
Message-ID: <1322661544.2921.274.camel@twins>
Subject: Re: [PATCH 1/2] Staging: zram: Turn lockdep off during
 zram_init_device()
From: Peter Zijlstra <peterz@infradead.org>
To: Jerome Marchand <jmarchan@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Nitin Gupta <ngupta@vflare.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 30 Nov 2011 14:59:04 +0100
In-Reply-To: <4ED62C38.1020106@redhat.com>
References: <4ED62C38.1020106@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-30 at 14:14 +0100, Jerome Marchand wrote:
> zram->init_lock can be hold over an allocation that may try to reclaim
> memory in zram_init_device(). The same lock can later be taken from a
> reclaim context in zram_make_request(), thus triggering a lockdep
> warning. However, memory can not be reclaimed to an uninitialized zram
> device. Therefore, this warning is a false positive.
> To prevent the warning to occur, we turn lockdep off during while the
> device is initialized.

fuck no! why do you even remotely consider this a sane thing to do?

There's tons of lockdep annotations, try one of those. If you have, your
changelog utterly fails to explain why non of those are suitable and how
your problem is special.


