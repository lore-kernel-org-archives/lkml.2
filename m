Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab2HRShO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 14:37:14 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41466 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751632Ab2HRShJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 14:37:09 -0400
Message-ID: <1345315025.10014.15.camel@joe2Laptop>
Subject: Re: [bisected] Driver core fixes for 3.6-rc3 regression
From: Joe Perches <joe@perches.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Markus Trippelsdorf <markus@trippelsdorf.de>,
        Jim Cromie <jim.cromie@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Kay Sievers <kay@vrfy.org>,
        Jason Baron <jbaron@redhat.com>
Date: Sat, 18 Aug 2012 11:37:05 -0700
In-Reply-To: <20120818163401.GA2013@kroah.com>
References: <20120817171354.GA14046@kroah.com> <20120818060934.GA255@x4>
	 <20120818163401.GA2013@kroah.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-18 at 09:34 -0700, Greg KH wrote:
> On Sat, Aug 18, 2012 at 08:09:34AM +0200, Markus Trippelsdorf wrote:
> > On 2012.08.17 at 10:13 -0700, Greg KH wrote:
> > > ----------------------------------------------------------------
> > > Driver core fixes for 3.6-rc3
> > > 
> > > Here are two tiny patches, one fixing a dynamic debug problem that the printk
> > > rework turned up, and the other one fixing an extcon problem that people
> > > reported.
> > > 
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > 
> > > ----------------------------------------------------------------
> > > Axel Lin (1):
> > >       extcon: extcon_gpio: Replace gpio_request_one by devm_gpio_request_one
> > > 
> > > Jim Cromie (1):
> > >       drivers-core: make structured logging play nice with dynamic-debug
> > 
> > The commit af7f2158f above causes hundreds of "Failed to force enable
> > HPET" messages to appear during boot on my system.
> > Please also note the strange "^A0" character sequence that is also
> > introduced by the same commit.
> 
> Ugh, I see the same thing here, debugging must be accidentally enabled
> with this patch, and the ^A0 stuff is just a mess.  Sorry, I didn't
> notice this in my testing, my fault.

It's a combination interaction because of the patch with
a conversion of KERN_<LEVEL> from "<.>" to concatenated
SOH "."

commit: 04d2c8c83d0e3ac5f78aeede51babb3236200112
																			
> Reverting this resolves the issue for me.
> 
> Jim, any thoughts on how to fix this?  Should I just revert this patch
> for now?

I have a patch to resolve dynamic debug logging.
I'll submit it Monday along with an updated netdev_printk patch.

Joe

