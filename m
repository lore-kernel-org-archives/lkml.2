Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932214Ab0HXWKN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 18:10:13 -0400
Received: from smtp-good-out-2.t-2.net ([84.255.208.44]:48531 "EHLO
	smtp-good-out-2.t-2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755770Ab0HXWKK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 18:10:10 -0400
Subject: Re: [PATCH] detour TTY driver - now ttyprintk
From: Samo Pogacnik <samo_pogacnik@t-2.net>
To: Greg KH <gregkh@suse.de>
Cc: linux kernel <linux-kernel@vger.kernel.org>,
        linux-embedded <linux-embedded@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20100824211016.GA7176@suse.de>
References: <1275175983.2122.42.camel@itpsd6lap>
	 <1276123020.16010.97.camel@itpsd6lap>
	 <20100611134455.3fa7d563@lxorguk.ukuu.org.uk>
	 <1276291932.2154.45.camel@itpsd6lap>
	 <20100621153858.444695c0@lxorguk.ukuu.org.uk>
	 <1277244410.2195.47.camel@itpsd6lap>
	 <20100622232108.26752ff8@lxorguk.ukuu.org.uk>
	 <1277462596.2143.101.camel@itpsd6lap>
	 <20100625120329.1303aa61@lxorguk.ukuu.org.uk>
	 <1282683470.8020.66.camel@itpsd6lap>  <20100824211016.GA7176@suse.de>
Content-Type: text/plain
Date: Wed, 25 Aug 2010 00:09:57 +0200
Message-Id: <1282687797.8020.108.camel@itpsd6lap>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24.08.2010 (Tue) at 14:10 -0700 Greg KH wrote:
> On Tue, Aug 24, 2010 at 10:57:50PM +0200, Samo Pogacnik wrote:
> > On 25.06.2010 (Fri) at 12:03 +0100 Alan Cox wrote: 
> > > With my devices.txt owner hat on I'll allocate the minor as you suggest
> > > (and double check this causes no problems), with my tty hat on can you
> > > send it to GregKH for merging into the tree.
> > 
> > Hi,
> > 
> > I hope that this TTY driver is ok for merging. It is very basic -
> > removed all flow control and rate limiting. Patch has been generated
> > against 2.6.34 kernel version.
> > 
> > Ttyprintk is a pseudo TTY driver, which allows users to make printk messages,
> > via output to ttyprintk device. It is possible to store "console" messages
> > inline with kernel messages for better analyses of the boot process, for
> > example.
> 
> Why does this need to be a tty driver?  Why not a misc device?
Thanks for the response. I'll try to explain.
Well it all started with a kernel hack, which internaly redirected
console output to printk function to be able to capture console messages
inline with real kernel messages. Console messages have also been
automatically stored via system logging facility, which was very useful
especially for analyzes of the initrd part of the userspace system
initialization. Through initial posts (thread: console logging detour
via printk) Alan suggested, that a separate TTY driver could provide
this functionality and that may initial hacking isn't acceptable.
> 
> And what about the normal way of just writing to /dev/kmsg to do this?
> Why a whole new driver for this same functionality?
I must admit, i was not aware of the /dev/kmsg driver, but i made a few
tests and found out that it seems not to be possible to redirect console
to kmsg.

regards, Samo

