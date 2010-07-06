Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757326Ab0GFCk6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 22:40:58 -0400
Received: from sh.osrg.net ([192.16.179.4]:33044 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757184Ab0GFCk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 22:40:56 -0400
Date: Tue, 6 Jul 2010 11:40:41 +0900
To: jeff@garzik.org
Cc: fujita.tomonori@lab.ntt.co.jp, axboe@kernel.dk,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: remove unused REQ_TYPE_LINUX_BLOCK
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4C3227CA.8000600@garzik.org>
References: <20100705181100B.fujita.tomonori@lab.ntt.co.jp>
	<4C3227CA.8000600@garzik.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100706113954L.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 06 Jul 2010 11:40:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Jul 2010 14:43:22 -0400
Jeff Garzik <jeff@garzik.org> wrote:

> > -/*
> > - * For request of type REQ_TYPE_LINUX_BLOCK, rq->cmd[0] is the opcode being
> > - * sent down (similar to how REQ_TYPE_BLOCK_PC means that ->cmd[] holds a
> > - * SCSI cdb.
> > - *
> > - * 0x00 ->  0x3f are driver private, to be used for whatever purpose they need,
> > - * typically to differentiate REQ_TYPE_SPECIAL requests.
> > - *
> > - */
> > -enum {
> > -	REQ_LB_OP_EJECT	= 0x40,		/* eject request */
> > -	REQ_LB_OP_FLUSH = 0x41,		/* flush request */
> > -};
> 
> Acked-by: Jeff Garzik <jgarzik@redhat.com>
> 
> Having a second level of opcodes, under REQ_TYPE_LINUX_BLOCK, always 
> seems less desirable than the current course of action you are now 
> pursuing (REQ_FLUSH, etc.)...   nice cleanup.

Agreed. We are running out of rq_flag_bits though. We can rethink when
we actually run out of it.
