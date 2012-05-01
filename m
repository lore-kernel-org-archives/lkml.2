Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755604Ab2EAVkN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 17:40:13 -0400
Received: from cet.com.ru ([195.178.208.66]:33879 "EHLO tservice.net.ru"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753456Ab2EAVkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 17:40:11 -0400
Date: Wed, 2 May 2012 01:39:58 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH] w1: Introduce a slave mutex for serializing IO.
Message-ID: <20120501213958.GA15560@ioremap.net>
References: <20120425124914.3187a794@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425124914.3187a794@notabene.brown>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 12:49:14PM +1000, NeilBrown (neilb@suse.de) wrote:
> w1 devices need a mutex to serial IO.
> Most use master->mutex.
> 
> However that is used for other purposes and they can conflict.
> 
> In particular master->mutex is held while w1_attach_slave_device is
> called.
> 
> For bq27000, this registers a 'powersupply' device which tries to
> read the current status.  The attempt to read will cause a deadlock on
> master->mutex.
> 
> So create a new per-slave mutex and use that for serializing IO for
> bq27000.

How will this protect against master doing search for example?
It performs a number of read/write operations which are not allowed to
be interrupted by outside read.

-- 
	Evgeniy Polyakov
