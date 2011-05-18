Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755849Ab1ERVfA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 17:35:00 -0400
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:42246 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755733Ab1ERVe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 17:34:57 -0400
X-Sasl-enc: g5ZvEh6+HN4BXv8df9kGYLJvCqeAWDFGVE5PfVn7P3hZ 1305754496
Date: Wed, 18 May 2011 14:34:51 -0700
From: Greg KH <greg@kroah.com>
To: Tim Bird <tim.bird@am.sony.com>, Jeff Mahoney <jeffm@suse.de>
Cc: Christoph Hellwig <hch@infradead.org>,
        Alessio Igor Bogani <abogani@kernel.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Anders Kaseorg <andersk@ksplice.com>, Tim Abbott <tabbott@ksplice.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>,
        Jason Wessel <jason.wessel@windriver.com>,
        Dirk Behme <dirk.behme@googlemail.com>
Subject: Re: module boot time (was Re: [PATCH] module: Use binary search in
 lookup_symbol())
Message-ID: <20110518213451.GA23702@kroah.com>
References: <BANLkTinPG100vbVAN1RZWb3h9Xuu6SKJ0Q@mail.gmail.com>
 <1305665763-3988-1-git-send-email-abogani@kernel.org>
 <20110517232241.GA19140@kroah.com>
 <4DD305B3.3000707@am.sony.com>
 <20110518075428.GA29998@infradead.org>
 <4DD3FB1C.3040103@am.sony.com>
 <20110518192110.GB26945@kroah.com>
 <4DD435B7.9090702@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DD435B7.9090702@am.sony.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 02:10:15PM -0700, Tim Bird wrote:
> >>> And why do people overly care for the load time?
> >>
> >> To reduce overall boot time.
> > 
> > To reduce it even more, build the modules into the kernel :)
> 
> That's what I do most of the time.  For some projects,
> it is useful to build certain things as modules so you can
> defer initializing them until later in the boot sequence.
> You can get some critical user-space tasks running, then
> come back later to initialize USB and other drivers.
> On cameras, it's not uncommon to want to get to user
> space in the first 500 milliseconds.

That's common even on desktops and servers, and using the bootchart code
in the kernel helps find those bottlenecks.

> Sony has some code which allows us to both statically link
> drivers and defer their initialization, but it's kind of
> kludgy and requires modifying the module declarations
> for the code you want to defer.  Let me know if you think
> this is worth doing an RFC about.

I don't think that's worth it, there has been talk, and some initial
code, about adding kernel modules to the kernel image itself, which
would solve a lot of the i/o time of loading modules, and solves some
other boot speed problems.  That work was done by Jeff Mahoney, but I
think he ran into some "interesting" linker issues and had to shelve it
due to a lack of time :(

thanks,

greg k-h
