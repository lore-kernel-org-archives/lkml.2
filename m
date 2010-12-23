Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752546Ab0LWVks (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 16:40:48 -0500
Received: from mail.linux-iscsi.org ([67.23.28.174]:56662 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752111Ab0LWVkq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 16:40:46 -0500
Subject: Re: [PATCH 01/12] libiscsi: Convert to host_lock less
	w/	interrupts disabled internally
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Matthew Wilcox <matthew@wil.cx>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        James Bottomley <James.Bottomley@suse.de>,
        Jeff Garzik <jeff@garzik.org>, Christoph Hellwig <hch@lst.de>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Hannes Reinecke <hare@suse.de>,
        Open iSCSI <open-iscsi@googlegroups.com>
In-Reply-To: <4D0FF6A5.9040209@cs.wisc.edu>
References: <1292793727-31957-1-git-send-email-nab@linux-iscsi.org>
	 <1292793727-31957-2-git-send-email-nab@linux-iscsi.org>
	 <20101219233835.GJ1263@parisc-linux.org>
	 <1292807703.20840.29.camel@haakon2.linux-iscsi.org>
	 <1292808126.20840.33.camel@haakon2.linux-iscsi.org>
	 <20101220020758.GK1263@parisc-linux.org>
	 <1292837413.20840.47.camel@haakon2.linux-iscsi.org>
	 <4D0FF6A5.9040209@cs.wisc.edu>
Content-Type: text/plain
Date: Thu, 23 Dec 2010 13:23:54 -0800
Message-Id: <1293139434.4649.122.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-20 at 18:36 -0600, Mike Christie wrote:
> On 12/20/2010 03:30 AM, Nicholas A. Bellinger wrote:
> > After a quick audit of iscsi_session->lock usage, and I see that
> > iscsi_complete_pdu(), iscsi_tmf_timedout(), iscsi_eh_cmd_timed_out(),
> > iscsi_check_transport_timeouts() are using spin_lock(), and
> > iscsi_session_failure() and iscsi_conn_failure() are using
> > spin_lock_irqsave().
> >
> > Mike and Hannes, would you guys mind commenting on this..?  From what I
> > can determine these should all be converted to use spin_lock_bh(),
> > yes..?
> >
> 
> Yeah, they can use _bh locking. I was going to use them for qla4xxx eh, 
> which does iscsi processing in its irq, but we never did.

Thanks for the clarification.  I would be happy to submit a patch next
week for this seperately from the host_lock-less conversion pieces, or
would you prefer handle this yourself..?

Best Regards,

--nab

