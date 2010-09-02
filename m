Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754673Ab0IBGaL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 02:30:11 -0400
Received: from leo.clearchain.com ([199.73.29.74]:56291 "EHLO
	mail.clearchain.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab0IBGaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 02:30:09 -0400
Date: Thu, 2 Sep 2010 16:30:27 +1000
From: Peter Hutterer <peter.hutterer@who-t.net>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Xing Wei <weixing@hanwang.com.cn>,
        linux-input <linux-input@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, jkosina <jkosina@suse.cz>,
        Peter Hutterer <peter.hutterer@redhat.com>,
        Ping Cheng <pingc@wacom.com>
Subject: Re: [PATCH v3] input: Add support for Hanwang tablet
Message-ID: <20100902063027.GA28409@barra.bne.redhat.com>
References: <201009021229501252232@hanwang.com.cn>
 <20100902062030.GA9416@core.coreip.homeip.net>
 <20100902062403.GA10087@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100902062403.GA10087@core.coreip.homeip.net>
User-Agent: Mutt/1.5.20 (2010-07-18)
X-Greylist: Sender is SPF-compliant, not delayed by milter-greylist-4.0.1 (mail.clearchain.com [127.0.0.1]); Thu, 02 Sep 2010 15:59:47 +0930 (CST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 01, 2010 at 11:24:04PM -0700, Dmitry Torokhov wrote:
> On Wed, Sep 01, 2010 at 11:20:30PM -0700, Dmitry Torokhov wrote:
> > On Thu, Sep 02, 2010 at 12:29:50PM +0800, Xing Wei wrote:
> > > On Wed, Sep 01, 2010 mitry Torokhov wrote:
> > > > Hi Xing,
> > > > 
> > > > On Wed, Sep 01, 2010 at 02:55:44PM +0800, Xing Wei wrote:
> > > > > Hi Dmitry, it works well and I really appreciate your work. 
> > > > > BTN_3 - BTN_8 & ABS_DISTANCE events are not handled & used in our X system driver by now,
> > > > > sorry for my mistake.
> > > > >
> > > > 
> > > > Just to avoid confusion - are BTN_3 - BTN_8 not used by your X driver or
> > > > the hardware does not really report them? Because if it the former then
> > > > we should continue reporting them - some other user (as in
> > > > program/driver) might be interested in these.
> > > > 
> > > > Also, why do you develop your own X driver? Does not X's evdev driver
> > > > work properly for you?
> > > > 
> > > > Thanks.
> > > >  
> > > > 
> > > 
> > > Hi Dmitry, the hardware does really report BTN_3 - BTN_8.
> > 
> > OK, then we should keep reporting them then. I will add the patch to my
> > 'next' branch and it should show up in 2.6.37.
> > 
> > > And I try to let the evdev driver(remove my X driver & .conf file ) take over the device,
> > > but seem like it has no reflection to the pressure and roll wheel pad,just run like a generic mouse.
> > > 
> > 
> > Then I suggest looking into modifying evdev so that it properly works
> > with your device. I think Peter Hutterer (CCed) is the man you need to
> > talk to.
> > 
> 
> Hmm, another option is maybe getting wacom X driver to work with your
> device.

I agree, the evdev driver will handle the device but likely not in the
manner desired. It'll simply export all buttons and axes but on a single
device. The wacom X driver will split into multiple X devices so that the
stylus is exported as a different device than the wheel + buttons (that's
how wacom does it, anyway).

Note that some tweaks to the wacom driver are likely needed, Xing, please
contact me off-list to get this started.

Cheers,
  Peter
