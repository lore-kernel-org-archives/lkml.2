Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab0GVMhz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 08:37:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:47216 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754548Ab0GVMhx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 08:37:53 -0400
Date: Thu, 22 Jul 2010 22:37:40 +1000
From: Neil Brown <neilb@suse.de>
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jiri Slaby <jirislaby@gmail.com>,
        James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org,
        hch@lst.de, jaxboe@fusionio.com, LKML <linux-kernel@vger.kernel.org>,
        linux-raid@vger.kernel.org
Subject: Re: [PATCH] md: bitwise operations might not fit in a "bool"
Message-ID: <20100722223740.7baa68a1@notabene>
In-Reply-To: <4C4837A5.6040209@panasas.com>
References: <4C47ED7B.1050709@gmail.com>
	<20100722173716.66264bef@notabene>
	<4C481FD5.4070509@gmail.com>
	<4C482F35.6000004@panasas.com>
	<20100722215555.7ab2b1ee@notabene>
	<4C4837A5.6040209@panasas.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jul 2010 15:20:53 +0300
Boaz Harrosh <bharrosh@panasas.com> wrote:

> On 07/22/2010 02:55 PM, Neil Brown wrote:
> > On Thu, 22 Jul 2010 14:44:53 +0300
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> > 
> >>
> >> when taking a resolute of a bit-wise AND as true false. Better / faster
> >> to make it a boolean operation.
> >>
> >> This fixes a bug and a crash because the flags field did not fit into
> >> the bool operands.
> > 
> > No, that won't work.
> > Read the rest of the code and see where 'do_sync' and 'do_barriers' are used.
> > 
> > NeilBrown
> > 
> 
> You are right! (I didn't look)
> 
> the use of "bool" was wrong from the get go. it was never a bool operation.
> What was the guy thinking? What is that do_XXX name? that name should change
> as well. Perhaps flg_sync, flg_barriers.

Check the git history - 'bool' was originally appropriate.  But when the
value was recently changed, the type and name were not.
I would actually prefer "sync_flg" and "barrier_flg", but your suggestion
that we change the name as well as the type is a good one.

Thanks,
NeilBrown
