Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933434Ab2EQPJb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:09:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60382 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933404Ab2EQPJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:09:28 -0400
Date: Thu, 17 May 2012 08:09:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
Message-ID: <20120517150923.GH21275@google.com>
References: <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz>
 <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com>
 <20120516195332.GC21275@google.com>
 <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz>
 <20120516200147.GD21275@google.com>
 <alpine.LNX.2.00.1205162216390.8796@pobox.suse.cz>
 <20120516202924.GE21275@google.com>
 <CA+55aFyX3OgdcWuYQO+YuS3fF_Wt1p8w-G33C5MCkiR-3ncfVA@mail.gmail.com>
 <20120517145519.GF21275@google.com>
 <alpine.LNX.2.00.1205171705520.8796@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1205171705520.8796@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 05:06:41PM +0200, Jiri Kosina wrote:
> On Thu, 17 May 2012, Tejun Heo wrote:
> 
> > > Umm. If there are abritrarily long things and these are serialized,
> > > then that workqueue is not good for putting floppy work on it either,
> > > is it? I don't think you can have it both ways.
> > 
> > They're not being serialized.  
> 
> Then it's useless for this very purpose -- the sole purpose of the 
> floppy_wq having as a single-threaded wq is to run all the work 
> serialized.
> 
> So the patch I have sent out this morning is the way to go.

Yeah, that seems to be my confusion here - I thought serialization is
necessary only for a work item.  Can you please use
alloc_ordered_workqueue() instead of create_singlethread_workqueue()?

Thanks.

-- 
tejun
