Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2HTSNQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 14:13:16 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:46089 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751255Ab2HTSNP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 14:13:15 -0400
Message-ID: <1345486393.3252.3.camel@joe2Laptop>
Subject: Re: [PATCH] drivers-core: beware dev_printk() from printing nonsense
From: Joe Perches <joe@perches.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Jim Cromie <jim.cromie@gmail.com>,
        Jason Baron <jbaron@redhat.com>, Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 20 Aug 2012 11:13:13 -0700
In-Reply-To: <50326B84.4010204@linutronix.de>
References: <20120820103337.GA16744@linutronix.de>
	 <20120820152611.GB28039@kroah.com> <50326B84.4010204@linutronix.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-08-20 at 18:53 +0200, Sebastian Andrzej Siewior wrote:
> On 08/20/2012 05:26 PM, Greg Kroah-Hartman wrote:
> >>   skip:
> >> -	if (level[3])
> >> +	if (level[sizeof(KERN_ERR) - 1])
> >
> > This has already been fixed in my driver-core tree and will go to Linus
> > in a few hours.
> 
> Ah. So I'm too late. Care to send a patch which replace [2] with the
> sizeof() operator like above?

Nope, the better fix is to use a different mechanism.

See commit acc8fa41ad31c5
("printk: add generic functions to find KERN_<LEVEL> headers")

and

commit 04d2c8c83d0e3a
("printk: convert the format for KERN_<LEVEL> to a 2 byte pattern")

I'll submit that "better fix" shortly after Greg's update has
been pulled/merged by Linus.

cheers, Joe

