Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab1COXC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 19:02:26 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:50027 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753712Ab1COXCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 19:02:22 -0400
Subject: Re: [RFC-v2 06/12] iscsi-target: Add iSCSI Login Negotiation and
	Parameter logic
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Boaz Harrosh <bharrosh@panasas.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Douglas Gilbert <dgilbert@interlog.com>
In-Reply-To: <20110315102146.GA24496@lst.de>
References: <1300103829-10337-1-git-send-email-nab@linux-iscsi.org>
	 <1300103829-10337-7-git-send-email-nab@linux-iscsi.org>
	 <20110315102146.GA24496@lst.de>
Content-Type: text/plain
Date: Tue, 15 Mar 2011 15:55:19 -0700
Message-Id: <1300229719.28255.314.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-15 at 11:21 +0100, Christoph Hellwig wrote:
> The thread pool in iscsi_thread_queue.c looks like it really should
> go away in favour of the new concurrency managed workqueues.

Yes, this code has been around for some time..

> Did you look into the current kernel kernel/workqueue.c code?
> 

I was thinking more about this for target core v4.1 / .40 stuff, but
have not looked at this for iSCSI target not just yet..

I think this would be a good fit for immediate and response queues in
iscsi_target_tx_thread(), and I think we could convert with fairly
minimal breakage to the existing code if I understand Tejun's new model
correct.  I need to read-up a bit more before jumping on this
conversion, but if you want to do an initial conversion I would be happy
to merge it and help with the polish while I address your other
comments.

--nab






