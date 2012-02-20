Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2BTTQK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 14:16:10 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17483 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab2BTTQI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 14:16:08 -0500
Date: Mon, 20 Feb 2012 14:16:04 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        ctalbott@google.com, rni@google.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] block: implement bio_associate_current()
Message-ID: <20120220191604.GC13423@redhat.com>
References: <1329431878-28300-1-git-send-email-tj@kernel.org>
 <1329431878-28300-8-git-send-email-tj@kernel.org>
 <20120217011907.GA15073@google.com>
 <20120217221406.GJ29414@google.com>
 <20120217223420.GJ26620@redhat.com>
 <20120217224103.GN29414@google.com>
 <20120217225125.GK26620@redhat.com>
 <20120217225735.GP29414@google.com>
 <20120220143622.GB10342@redhat.com>
 <20120220170128.GB7836@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120220170128.GB7836@mtj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 20, 2012 at 09:01:28AM -0800, Tejun Heo wrote:
> On Mon, Feb 20, 2012 at 09:36:22AM -0500, Vivek Goyal wrote:
> > In copy_io(), we don't share the io_context if "current" does not have
> > task->io_context set. Does that mean if even if I specify CLONE_IO, two
> > threads might not share io context depending on when clone() happened? Or
> > I am reading the code wrong.
> 
> Yeah, AFAICS, if the cloning task hasn't issued IO before, CLONE_IO is
> ignored.

Will it make sense to try to allocate and attach io_context and then 
share it in copy_io()?

Well, you are planning to kill CLONE_IO altogether, so it does not
make a difference.

Vivek
