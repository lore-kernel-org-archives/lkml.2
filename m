Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754838Ab2CNAGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 20:06:32 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:43510 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753725Ab2CNAGa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 20:06:30 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kay Sievers <kay@vrfy.org>
Subject: Re: [PATCH] firmware loader: don't cancel _nowait requests when helper is not yet available
Date: Wed, 14 Mar 2012 01:10:40 +0100
User-Agent: KMail/1.13.6 (Linux/3.3.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        linux-kernel@vger.kernel.org,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203132042.07794.rjw@sisk.pl> <CAPXgP11fWf-0Jkk=d6G+d=sQa-hoX3jUM+K6K4rGYhh0dv1u_w@mail.gmail.com>
In-Reply-To: <CAPXgP11fWf-0Jkk=d6G+d=sQa-hoX3jUM+K6K4rGYhh0dv1u_w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201203140110.40671.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 14, 2012, Kay Sievers wrote:
> On Tue, Mar 13, 2012 at 20:42, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Sunday, March 11, 2012, Kay Sievers wrote:
> >> On Sat, Mar 10, 2012 at 00:36, Greg KH <gregkh@linuxfoundation.org> wrote:
> 
> >> > What does uevent have to do with things here?
> >>
> >> I don't think that the firmware loader should care about the
> >> usermodehelper at all, and that stuff fiddling should just be removed
> >> from the firmware class.
> >
> > It's there to warn people that their drivers do stupid things like
> > loading frimware during system resume, which is guaranteed not to work.
> >
> > IOW, it's there very much on purpose.
> 
> Using the /sbin/hotplug is no case that needs any warning. It' such a
> broken model these days, that firmware loading is the least problem
> that occurs with it.
> 
> >> Forking /sbin/hotplug is disabled by default, it is a broken concept,
> >> and it cannot work reliably on today's systems.
> >>
> >> Firmware is not loaded by /sbin/hotplug since many years, but by udev
> >> or whatever service handles uevents, like ueventd on android.
> >
> > Which I'm not sure why is relevant here.
> 
> It is relevant in the sense that the firmware loader should not even
> know that a uevent *can* cause a usermodehelper exec() if it runs in
> legacy mode. The firmware loader just has no business in fiddling with
> the details of driver core legacy stuff. I don't think his warning
> makes much sense.

But that warning actually triggers for drivers that attempt to use
request_firmware() during system resume, even though /sbin/hotplug isn't
used any more.

usermodehelper_is_disabled() means "we are in the middle of system power
transition" rather than anything else (I agree it should be called
suspend_in_progress() or something similar these days).

Thanks,
Rafael
