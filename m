Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758202Ab2I1ObU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 10:31:20 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:47530 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757673Ab2I1ObT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 10:31:19 -0400
Subject: Re: [PATCH] driver core: fix possible missing of device probe
From: anish kumar <anish198519851985@gmail.com>
To: Ming Lei <ming.lei@canonical.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Russell King <linux@arm.linux.org.uk>,
        stable@vger.kernel.org
In-Reply-To: <CACVXFVMJaQRj6sUJwiyiMvyAyd2p_8g9cYFqRW2KngQPx62Y5A@mail.gmail.com>
References: <1348793563-19186-1-git-send-email-ming.lei@canonical.com>
	 <CAK7N6vqS9PW85hgcA7EVzCk-TQo_ru4OcC5i0Rw-b2hvb4YoXg@mail.gmail.com>
	 <CACVXFVMJaQRj6sUJwiyiMvyAyd2p_8g9cYFqRW2KngQPx62Y5A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 28 Sep 2012 20:01:07 +0530
Message-ID: <1348842668.1480.9.camel@anish-Inspiron-N5050>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-09-28 at 21:53 +0800, Ming Lei wrote:
> On Fri, Sep 28, 2012 at 11:31 AM, anish singh
> <anish198519851985@gmail.com> wrote:
> > Hello Ming,
> > Though I am not an expert in this driver core area but
> > I have been following this fix.So have some queries below:
> >
> > On Fri, Sep 28, 2012 at 6:22 AM, Ming Lei <ming.lei@canonical.com> wrote:
> >> Inside bus_add_driver(), one device might be added into
> > should it not be "driver might be added into"?
> >> the bus or probed which is triggered by deferred probe
> >> just after completing of driver_attach() and before
> >> 'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)',
> >> so the device won't be probed by this driver.
> > So the corresponding device will not be probed.
> >>
> >> This patch moves the below line
> >>
> >>         'klist_add_tail(&priv->knode_bus, &bus->p->klist_drivers)'
> >>
> >> before driver_attach() inside bus_add_driver().
> >>
> >> So fixes the problem since the below way can guarantee that
> >> no probe(dev) may be lost.
> >>
> > As I understand CPU0 is just calling bus_add_driver and driver_attach
> > is called and after that it was pre-empted and cpu1 came into picture.
> > Deferred probe started running on cpu1 and it didn't find the driver present
> > int the knode_bus and unloaded the driver(why it unloaded is already
> > explained by russell in his first post).
> 
> If the driver is unloaded, it is not a problem because the device will be
> probed after the driver is loaded again, so it is nothing to do with driver
> unloading. I don't know it was mentioned before.
> 
> The  problem is that the bus_probe_device or device_add context
> may not see the driver added in driver_register context, in which
> the device is not being seen by driver_attach too. Only when the
> device is not probed in both the two contexts, the problem is
> triggered.
> 
> If the device can be guaranteed to be probed always in one of the
> two contexts, the problem will be solved. That is the idea in the patch.
> 
> > Hope my understanding is correct.
> 
> Hope I clarify the problem.
Ming,
Somehow I feel here that the problem reported by Russell is totally
different from your understanding of problem.I humbly urge you to have
a look at Russell's nice explanation.
I was easily able to understand the problem faced by him and the
reasoning put forward by him and moreover if the issue had been related
to SMP russell would have definitely mentioned it given his knowledge of
the same.
Thanks for your time.
> 
> 
> Thanks,
> --
> Ming Lei


