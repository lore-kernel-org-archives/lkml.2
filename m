Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab2EOOdZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:33:25 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:45145 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757282Ab2EOOdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:33:24 -0400
Date: Tue, 15 May 2012 15:36:14 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Gleb Natapov <gleb@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515153614.4b5b4525@pyramind.ukuu.org.uk>
In-Reply-To: <20120515142129.GC6948@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
	<20120515111255.GJ32036@redhat.com>
	<4FB23C09.7060300@suse.de>
	<20120515115917.GK32036@redhat.com>
	<20120515144945.339e742f@pyramind.ukuu.org.uk>
	<20120515141214.GB6948@redhat.com>
	<20120515151849.54a12175@pyramind.ukuu.org.uk>
	<20120515142129.GC6948@redhat.com>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2012 17:21:29 +0300
Gleb Natapov <gleb@redhat.com> wrote:

> On Tue, May 15, 2012 at 03:18:49PM +0100, Alan Cox wrote:
> > On Tue, 15 May 2012 17:12:14 +0300
> > Gleb Natapov <gleb@redhat.com> wrote:
> > 
> > > On Tue, May 15, 2012 at 02:49:45PM +0100, Alan Cox wrote:
> > > > > I do not see support for other spec to be important, but you are welcome
> > > > > to write support for it if you need it. The only way I see to check what
> > > > > spec edd info corresponds to is to calculate checksum according to both
> > > > > specs and see which one succeeds.
> > > > 
> > > > No it doesn't work like that. This is a regression for existing working
> > > > systems. It needs to be reverted or fixed. If it was a new feature you'd
> > > > have a point - but it isn't. You've broken stuff, undo the breakage.
> > > > 
> > > Code never supported anything but EDD4.0 spec. I checked history git.
> > > Code erroneously tried to interpret EDD3.0 info according to EDD4.0 spec
> > > providing garbage as a result.
> > 
> > Providing some valid data and info, which has now disappeared.
> > 
> False. See my other mail:
> 
> # cat /sys/firmware/edd/int13_dev80/interface
> SCSI            id: 0  lun: 1224979098644774912
> 
> This is what I got on my system. How is it useful?

Sample case of .. 1

Have you checked how the various distribution grub installers and the
like respond to the various changes or having bits of their edd data
vanish mysteriously ?

It's been this way for a long time, there is no rush to fix it. So we
should fix it properly not break stuff.

Actual systems in the field are using both 3.0 and 4.0 so we need to deal
with that as part of fixing this. That is the reality of the situation.

1.1 I suspect we can not care about.

Alan
