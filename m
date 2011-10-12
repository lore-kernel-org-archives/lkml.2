Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752420Ab1JLXbb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 19:31:31 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:59675 "HELO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751188Ab1JLXba convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 19:31:30 -0400
MIME-Version: 1.0
In-Reply-To: <20100908003424.GA27719@suse.de>
References: <AANLkTinKBYzMwxEJarwN_HmKAORqJ7oiauj5JuXCo+rm@mail.gmail.com>
 <5A47E75E594F054BAF48C5E4FC4B92AB03293269CD@dbde02.ent.ti.com>
 <20100907212915.GB6798@suse.de> <201009080254.03070.mihai.dontu@gmail.com> <20100908003424.GA27719@suse.de>
From: Aras Vaichas <arasv@magellan-technology.com>
Date: Thu, 13 Oct 2011 10:31:08 +1100
Message-ID: <CAPs5rNZ07VZ0qK2PVG2u1DLEEnXS_CvVcYGLLE7fzFCcMo696A@mail.gmail.com>
Subject: Re: [PATCH] USB: Fix kernel oops with g_ether and Windows
To: Greg KH <gregkh@suse.de>
Cc: "Mihai Don??u" <mihai.dontu@gmail.com>, "Gadiyar, Anand" <gadiyar@ti.com>,
        Maxim Osipov <maxim.osipov@gmail.com>,
        Sergei Shtylyov <sshtylyov@mvista.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 September 2010 10:34, Greg KH <gregkh@suse.de> wrote:
>
> On Wed, Sep 08, 2010 at 02:54:02AM +0300, Mihai Don??u wrote:
> > On Wednesday 08 September 2010 00:29:15 Greg KH wrote:
> > > On Tue, Sep 07, 2010 at 04:18:23PM +0530, Gadiyar, Anand wrote:
> > > > Since Greg has already sent a pull request, I won't touch the file
> > > > now; maybe a trivial patch later on to fix up the coding style.
> > >
> > > That would be fine to have, I'd gladly accept it.
> >
> > Would something like the following do? It's against:
> > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb-2.6.git
> >
> > Corrected the coding style.
>
> Looks good, thanks, I'll go queue it up.

Did this patch get applied and the problem resolved?

I'm running 2.6.33.7-rt29 and we have a customer in India who
complains that they can't connect via USB. We don't have the problem
here, or anywhere else that we know of.

I looked at the logs of the device and it appears to have the same
Oops error as the one that this patch addresses.

e.g.
Oct  7 15:52:50 MDR4330-9000205 user.emerg kernel: Internal error:
Oops: 17 [#1] PREEMPT
Oct  7 15:52:50 MDR4330-9000205 user.emerg kernel: last sysfs file:
/sys/devices/platform/reader/firmware/reader/loading
Oct  7 15:52:50 MDR4330-9000205 user.warn kernel: Modules linked in:
readerdrv g_ether vfat fat
Oct  7 15:52:50 MDR4330-9000205 user.warn kernel: CPU: 0    Not
tainted  (2.6.33.7-rt29-magarm #101)
Oct  7 15:52:50 MDR4330-9000205 user.warn kernel: PC is at strlen+0x10/0x34
Oct  7 15:52:50 MDR4330-9000205 user.warn kernel: LR is at
rndis_msg_parser+0x81c/0x159c [g_ether]
Oct  7 15:52:50 MDR4330-9000205 user.warn kernel: pc : [<c013f0d8>]
lr : [<bf01cf30>]    psr: 60000013

Aras
