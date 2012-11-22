Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965132Ab2KVTeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:34:16 -0500
Received: from gate.alliedtelesyn.co.nz ([202.49.72.33]:59195 "HELO
	gate.alliedtelesyn.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757043Ab2KVTeN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:34:13 -0500
X-Greylist: delayed 2530 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 14:34:12 EST
Message-Id: <50AE2CE30200003600026B9A@gwia.alliedtelesyn.co.nz>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Thu, 22 Nov 2012 13:47:15 +1300
From: "andrew mcgregor" <andrew.mcgregor@alliedtelesis.co.nz>
To: "Ilya Zykov" <ilya@ilyx.ru>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Cc: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tty: Add driver unthrottle in
 ioctl(...,TCFLSH,..).
References: <50AD43DB.4030800@ilyx.ru>
 <20121121213037.154306da@pyramind.ukuu.org.uk> <50AD4A01.7060500@ilyx.ru>
In-Reply-To: <50AD4A01.7060500@ilyx.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



>>> On 11/22/2012 at 10:39 AM, in message <50AD4A01.7060500@ilyx.ru>, Ilya Zykov
<ilya@ilyx.ru> wrote: 
> On 22.11.2012 1:30, Alan Cox wrote:
> >> Function reset_buffer_flags() also invoked during the
> >> ioctl(...,TCFLSH,..). At the time of request we can have full buffers
> >> and throttled driver too. If we don't unthrottle driver, we can get
> >> forever throttled driver, because after request, we will have
> >> empty buffers and throttled driver and there is no place to unthrottle 
> driver.
> >> It simple reproduce with "pty" pair then one side sleep on tty->write_wait,
> >> and other side do ioctl(...,TCFLSH,..). Then there is no place to do 
> writers wake up.
> >
> >
> > So instead of revertng it why not just fix it ? Just add an argument to
> > the reset_buffer_flags function to indicate if unthrottling is permitted.
> >
> > Alan
> >
> Because in my opinion, unthrottling permitted always, except release 
> last filp (tty->count == 0)

Maybe so, but the patch was there in the first place to resolve an actual observed bug, where a driver would lock up.  So the behaviour needs preserved.

Andrew

