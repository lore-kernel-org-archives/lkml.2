Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933361Ab2EQPGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:06:49 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34434 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933033Ab2EQPGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:06:48 -0400
Date: Thu, 17 May 2012 17:06:41 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Hemminger <shemminger@vyatta.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] floppy: convert to delayed work and single-thread wq
In-Reply-To: <20120517145519.GF21275@google.com>
Message-ID: <alpine.LNX.2.00.1205171705520.8796@pobox.suse.cz>
References: <alpine.LNX.2.00.1205160932280.8796@pobox.suse.cz> <20120516170124.GA21275@google.com> <alpine.LNX.2.00.1205162133180.8796@pobox.suse.cz> <CA+55aFw-us7LnG-iq5EQmSDJ7xH9hiOMmCryAGobReko4LkVWg@mail.gmail.com> <20120516195332.GC21275@google.com>
 <alpine.LNX.2.00.1205162156120.8796@pobox.suse.cz> <20120516200147.GD21275@google.com> <alpine.LNX.2.00.1205162216390.8796@pobox.suse.cz> <20120516202924.GE21275@google.com> <CA+55aFyX3OgdcWuYQO+YuS3fF_Wt1p8w-G33C5MCkiR-3ncfVA@mail.gmail.com>
 <20120517145519.GF21275@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 May 2012, Tejun Heo wrote:

> > Umm. If there are abritrarily long things and these are serialized,
> > then that workqueue is not good for putting floppy work on it either,
> > is it? I don't think you can have it both ways.
> 
> They're not being serialized.  

Then it's useless for this very purpose -- the sole purpose of the 
floppy_wq having as a single-threaded wq is to run all the work 
serialized.

So the patch I have sent out this morning is the way to go.

Thanks,

-- 
Jiri Kosina
SUSE Labs
