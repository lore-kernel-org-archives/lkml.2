Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048Ab2GPOz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 10:55:28 -0400
Received: from g1t0028.austin.hp.com ([15.216.28.35]:25356 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751293Ab2GPOz0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 10:55:26 -0400
Message-ID: <1342450244.3010.3.camel@misato.fc.hp.com>
Subject: Re: [PATCH v6 0/6] ACPI: Add _OST support for ACPI hotplug
From: Toshi Kani <toshi.kani@hp.com>
To: Prarit Bhargava <prarit@redhat.com>
Cc: "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "bhelgaas@google.com" <bhelgaas@google.com>,
        "shuahkhan@gmail.com" <shuahkhan@gmail.com>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 16 Jul 2012 08:50:44 -0600
In-Reply-To: <50040E77.9060400@redhat.com>
References: <1340743374-18535-1-git-send-email-toshi.kani@hp.com>
	 <50040E77.9060400@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-07-16 at 08:52 -0400, Prarit Bhargava wrote:
> On 01/-10/-28163 02:59 PM, Kani, Toshimitsu wrote:
> >  * This version updates to use pr_<level> over printk to accommodate
> >    checkpatch update since this patchset was accepted in -next.
> > 
> > This patchset supports ACPI OSPM Status Indication (_OST) method for
> > ACPI CPU/memory/container hotplug operations and sysfs eject. After
> > an ACPI hotplug operation has completed, OSPM calls _OST to indicate
> > the result of the operation to the platform. If a platform does not
> > support _OST, this patchset has no effect on the platform.
> > 
> > This _OST support is enabled when all relevant ACPI hotplug operations,
> > such as CPU, memory and container hotplug, are enabled. This assures
> > consistent behavior among the hotplug operations with regarding the
> > _OST support.
> > 
> > Some platforms may require the OS to support _OST in order to support
> > ACPI hotplug operations. For example, if a platform has the management
> > console where user can request a hotplug operation from, this _OST
> > support would be required for the management console to show the result
> > of the hotplug request to user.
> > 
> > The _OST definition can be found in section 6.3.5 of ACPI 5.0 spec.
> > The HPPF spec below also describes hotplug flows with _OST.
> > 
> >   DIG64 Hot-Plug & Partitioning Flow (HPPF) Specification R1.0
> >   http://www.dig64.org/home/DIG64_HPPF_R1_0.pdf
> > 
> > The changes have been tested with simulated _OST methods.
> > 
> > v6:
> >  - Updated to use pr_<level> over printk.
> > 
> > v5:
> >  - Updated change log in patch 5/6.
> > 
> > v4:
> >  - Removed CONFIG_ACPI_HOTPLUG_OST option.
> > 
> > v3:
> >  - Added more descriptions to the change logs.
> > 
> > v2:
> >  - Added CONFIG_ACPI_HOTPLUG_OST option.
> >  - Added _OST support for container hotplug and sysfs eject.
> >  - Reordered patchset to enable _OST support bit of _OSC in the
> >    last patch.
> > 
> > ---
> > Toshi Kani (6):
> >  ACPI: Add an interface to evaluate _OST
> >  ACPI: Add _OST support for sysfs eject
> >  ACPI: Add _OST support for ACPI CPU hotplug
> >  ACPI: Add _OST support for ACPI memory hotplug
> >  ACPI: Add _OST support for ACPI container hotplug
> >  ACPI: Set hotplug _OST support bit to _OSC
> 
> I have a few systems on which I can do some _OST CPU and Memory hotplug.  These
> systems are newer Intel systems in which ACPI events can be triggered via
> switches to add CPUs.
> 
> I tested this patchset with CPU _add_ and haven't seen any issues.
> 
> So...
> 
> Tested-by: Prarit Bhargava <prarit@redhat.com>

Hi Prarit,

That's great!  Thanks a lot!

-Toshi


> 
> P.


