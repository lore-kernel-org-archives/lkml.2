Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237Ab2FRQ3J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:29:09 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:47541 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab2FRQ3H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:29:07 -0400
Date: Mon, 18 Jun 2012 18:28:55 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Jonathan Nieder <jrnieder@gmail.com>, John Stultz <johnstul@us.ibm.com>,
        stable@vger.kernel.org, Sasha Levin <levinsasha928@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Dave Jones <davej@redhat.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -stable]  ntp: Correct TAI offset during leap second
Message-ID: <20120618162854.GA3111@netboy.at.omicron.at>
References: <4FDB8563.3030805@us.ibm.com>
 <1339944223.4942.240.camel@deadeye.wl.decadent.org.uk>
 <20120617164751.GJ12429@burratino>
 <20120617173456.GA3684@netboy.at.omicron.at>
 <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340027711.9372.29.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 02:55:11PM +0100, Ben Hutchings wrote:
> On Sun, 2012-06-17 at 19:34 +0200, Richard Cochran wrote:
> > The offset should change upon entering state OOP, so something like
> > the following (untested) patch should fix it for 3.2.9.
> [...]
> 
> It looks like this patch just changes the offset reported by adjtimex()
> during an inserted second; is that right?

Right, nothing really terrible will happen. The worst that I can
imagine is that ntpd will set the new TAI offset during OOP, and then
the kernel will add one to it, resulting in the TAI offset being off
by one.

But I really doubt any software makes use of this information.

> Other than that, is 3.2.y likely to be OK?  Is there a good way to test
> that in advance; does
> <http://codemonkey.org.uk/2012/06/15/testing-leap-code/> look
> reasonable?

Well, if you want to wait all night then that is one way to do it.
Here is a little test program I have been using:

   https://github.com/richardcochran/leap

Thanks,
Richard
