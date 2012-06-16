Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757324Ab2FPXHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 19:07:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:56723 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757205Ab2FPXHK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 19:07:10 -0400
Date: Sun, 17 Jun 2012 01:07:06 +0200
From: Borislav Petkov <bp@alien8.de>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Bojan Smojver <bojan@rexursive.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Message-ID: <20120616230706.GA26955@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Alan Stern <stern@rowland.harvard.edu>,
	Bojan Smojver <bojan@rexursive.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
	Linux PM list <linux-pm@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
References: <90304ca8-31ef-4919-bf9d-e0498b0de87b@email.android.com>
 <Pine.LNX.4.44L0.1206161617080.819-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1206161617080.819-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 04:19:18PM -0400, Alan Stern wrote:
> On Sun, 17 Jun 2012, Bojan Smojver wrote:
> 
> > "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> > 
> > >Hmm.  Is there any fix, though?
> > 
> > How do we tell printk() to not dump stuff into dmesg?
> 
> You can't; that's what printk() does, by definition.  If you don't want 
> stuff to go into the dmesg buffer then don't call printk().
> 
> >  Or, how do we
> > otherwise just print to the console?
> 
> That's a better question.  Unfortunately, I don't know the answer.

Ok, I don't know the hibernation code at all but let me give it a try:

how about teach the piece that parses

$ echo suspend > /sys/power/disk

to make a note to self that we're doing the hibrid hibernation method
and then the function that prints the progress indicator to be let known
of the aforementioned self-note so that it doesn't do any output?

Purely hypothetical, of course.

-- 
Regards/Gruss,
    Boris.
