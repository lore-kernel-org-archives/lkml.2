Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753440Ab1HKTjI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Aug 2011 15:39:08 -0400
Received: from merlin.infradead.org ([205.233.59.134]:47945 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753280Ab1HKTjG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Aug 2011 15:39:06 -0400
Subject: Re: [PATCH v2 0/2] new cpumask for hotpluggable CPUs
From: Peter Zijlstra <peterz@infradead.org>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, gregkh@suse.de
Date: Thu, 11 Aug 2011 21:38:39 +0200
In-Reply-To: <CAJOA=zNoTbPViL81esyD0So_D70_0_BAxrM2ks3SgV5=FSTWHQ@mail.gmail.com>
References: <1313006614-28702-1-git-send-email-mturquette@ti.com>
	 <1313087423.8491.11.camel@twins>
	 <CAJOA=zNoTbPViL81esyD0So_D70_0_BAxrM2ks3SgV5=FSTWHQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.2- 
Message-ID: <1313091519.8491.31.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-08-11 at 12:25 -0700, Turquette, Mike wrote:
> On Thu, Aug 11, 2011 at 11:30 AM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Wed, 2011-08-10 at 13:03 -0700, Mike Turquette wrote:
> >> This patch series introduces a new cpumask which tracks CPUs that
> >> support hotplugging.  The purpose of this patch series is to provide a
> >> simple method for kernel code to know which CPUs can be hotplugged and
> >> which ones cannot.  Potential users of this code might be a thermal
> >> mitigation technique which uses hotplug to lower temperature, or a power
> >> capping mechanism which uses hotplug to lower power consumption.
> >>
> >> All the of usual cpumask helper functions are created for this new mask.
> >> The second patch in this series simply sets the bit for elligible CPUs
> >> while they are being registered.  The cpumask itself is static after
> >> boot and should not change (like the possbile mask).
> >
> > I still most strongly object to people using hotplug for these goals.
> >
> > Why do you need to go through the entire dance of hotplug just to idle a
> > cpu? Hotplug not only idles the cpu but tears down (and rebuilds) an
> > insane amount of resources associated with the cpu.
> 
> I think you're nacking the wrong series.  This patchset simply allows
> kernel space to know which CPUs can go offline and which one can't,
> which seems pretty innocuous.  Are you fundamentally opposed to the
> kernel having better accessor functions to this data?

Yeah, people might think its sane to use it..

> I'll soon be posting some code which does implement hotplug as a
> power-capping feature.  I think *that* is the patch that you'll want
> to nack.

That too of course..
