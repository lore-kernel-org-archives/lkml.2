Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1BDQcE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 11:32:04 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:50856 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085Ab1BDQcC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 11:32:02 -0500
MIME-Version: 1.0
Message-ID: <7bdfb0e2-fcfd-478f-b9fa-acb90c2ef550@default>
Date: Fri, 4 Feb 2011 08:29:25 -0800 (PST)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Ian Campbell <Ian.Campbell@eu.citrix.com>, v.tolstov@selfip.ru
Cc: Daniel Kiper <dkiper@net-space.pl>, akpm@linux-foundation.org,
        andi.kleen@intel.com, haicheng.li@linux.intel.com,
        fengguang.wu@intel.com, jeremy@goop.org,
        Konrad Wilk <konrad.wilk@oracle.com>, pasik@iki.fi,
        dave@linux.vnet.ibm.com, wdauchy@gmail.com, rientjes@google.com,
        xen-devel@lists.xensource.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: RE: [Xen-devel] [PATCH R3 0/7] xen/balloon: Memory hotplug support
 for Xen balloon driver
References: <20110203162345.GC1364@router-fw-old.local.net-space.pl>
 <1296768009.2346.7.camel@mobile
 1296810682.13091.571.camel@zakaz.uk.xensource.com>
In-Reply-To: <1296810682.13091.571.camel@zakaz.uk.xensource.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6550.5003]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4D4C29BC.0187:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Ian Campbell [mailto:Ian.Campbell@eu.citrix.com]
> Sent: Friday, February 04, 2011 2:11 AM
> 
> On Thu, 2011-02-03 at 21:20 +0000, Vasiliy G Tolstov wrote:
> > I have some may be offtopic question: Is that possible to export
> balloon
> > function balloon_set_new_target to GPL modules (EXPORT_SYMBOL_GPL) ?
> > This helps to kernel modules (not in kernel tree) to contol balloonin
> > (for example autoballoon or something else) without needing to write
> so
> > sysfs. (Writing files from kernel module is bad, this says Linux
> Kernel
> > Faq).
> 
> Is there a reason to do it from kernel space in the first place? auto
> ballooning can be done by a userspace daemon, can't it?

The whole point of self-ballooning is to teach an OS kernel to
be more aggressive about "surrendering" memory that it isn't
using efficiently.  I've called this "memory asceticism".  See
slide 12 in

http://oss.oracle.com/projects/tmem/dist/documentation/presentations/MemMgmtVirtEnv-LPC2010-Final.pdf 

as well as the issues/solutions slides later in that presentation.

And for anyone on this dist list seeing these slides and
concepts for the first time, you can "read" the presentation
with the speaker notes here:

http://oss.oracle.com/projects/tmem/dist/documentation/presentations/MemMgmtVirtEnv-LPC2010-SpkNotes.pdf
