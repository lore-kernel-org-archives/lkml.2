Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755112Ab2J2OMP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 10:12:15 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:9549 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085Ab2J2OMM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 10:12:12 -0400
Message-ID: <1351519472.19172.84.camel@misato.fc.hp.com>
Subject: Re: [PATCH v3 3/3] acpi,memory-hotplug : add memory offline code to
 acpi_memory_device_remove()
From: Toshi Kani <toshi.kani@hp.com>
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "liuj97@gmail.com" <liuj97@gmail.com>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "kosaki.motohiro@jp.fujitsu.com" <kosaki.motohiro@jp.fujitsu.com>,
        "isimatu.yasuaki@jp.fujitsu.com" <isimatu.yasuaki@jp.fujitsu.com>,
        "rjw@sisk.pl" <rjw@sisk.pl>,
        "laijs@cn.fujitsu.com" <laijs@cn.fujitsu.com>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>,
        Minchan Kim <minchan.kim@gmail.com>
Date: Mon, 29 Oct 2012 08:04:32 -0600
In-Reply-To: <508E1F3D.7030806@cn.fujitsu.com>
References: <1351247463-5653-1-git-send-email-wency@cn.fujitsu.com>
	 <1351247463-5653-4-git-send-email-wency@cn.fujitsu.com>
	 <1351271671.19172.74.camel@misato.fc.hp.com>
	 <508E1F3D.7030806@cn.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-10-29 at 06:16 +0000, Wen Congyang wrote:
> At 10/27/2012 01:14 AM, Toshi Kani Wrote:
> > On Fri, 2012-10-26 at 18:31 +0800, wency@cn.fujitsu.com wrote:
> >> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
> >>
> >> The memory device can be removed by 2 ways:
> >> 1. send eject request by SCI
> >> 2. echo 1 >/sys/bus/pci/devices/PNP0C80:XX/eject
> >>
> >> In the 1st case, acpi_memory_disable_device() will be called.
> >> In the 2nd case, acpi_memory_device_remove() will be called.
> > 
> > Hi Yasuaki, Wen,
> > 
> > Why do you need to have separate code design & implementation for the
> > two cases?  In other words, can the 1st case simply use the same code
> > path of the 2nd case, just like I did for the CPU hot-remove patch
> > below?  It will simplify the code and make the memory notify handler
> > more consistent with other handlers.
> > https://lkml.org/lkml/2012/10/19/456
> 
> Yes, the 1st case can simply reuse the same code of the 2nd case.
> It is another issue. The memory is not offlined and removed in 2nd
> case. This patchset tries to fix this problem. After doing this,
> we can merge the codes for the two cases.
> 
> But there is some bug in the code for 2nd case:
> If offlining memory failed, we don't know such error in 2nd case, and
> the kernel will in a dangerous state: the memory device is poweroffed
> but the kernel is using it.
> 
> We should fix this bug before merging them.

Hi Wen,

Sounds good.  Thanks for the clarification!

-Toshi



> Thanks
> Wen Congyang
> 


