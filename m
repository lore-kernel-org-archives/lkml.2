Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755788Ab2JVRKY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Oct 2012 13:10:24 -0400
Received: from e06smtp15.uk.ibm.com ([195.75.94.111]:41194 "EHLO
	e06smtp15.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755443Ab2JVRKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Oct 2012 13:10:23 -0400
Date: Mon, 22 Oct 2012 19:10:15 +0200
From: Michael Holzheu <holzheu@linux.vnet.ibm.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, linux-kernel@vger.kernel.org,
        kexec@lists.infradead.org, x86@kernel.org, mingo@elte.hu,
        tglx@linutronix.de, hpa@zytor.com, len.brown@intel.com,
        fenghua.yu@intel.com, ebiederm@xmission.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com
Subject: Re: [PATCH v1 0/2] x86, apic: Disable BSP if boot cpu is AP
Message-ID: <20121022191015.2989b7a0@holzheu>
In-Reply-To: <20121019151753.GF27052@redhat.com>
References: <20121017141234.GD31663@redhat.com>
	<20121018.120805.464238435.d.hatayama@jp.fujitsu.com>
	<20121018141449.GB18147@redhat.com>
	<20121019.122054.476812873.d.hatayama@jp.fujitsu.com>
	<20121019151753.GF27052@redhat.com>
Organization: IBM
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
x-cbid: 12102217-0342-0000-0000-0000032ABE39
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 11:17:53 -0400
Vivek Goyal <vgoyal@redhat.com> wrote:

[..]

> On Fri, Oct 19, 2012 at 12:20:54PM +0900, HATAYAMA Daisuke wrote:
> I am skeptical that this approach is going to fly in practice. Dumping
> huge images, processing and transferring these is not very practical.
> So I would rather narrow down the problem on a running system and take
> filtered dump of appropriate component where I suspect the problem is.
> 
> [..]
> > > capability was the primary reason that s390 also wants to support
> > > kdump otherwise there firmware dumping mechanism was working just
> > > fine.
> > > 
> > 
> > I don't know s390 firmware dumping mechanism at all, but is it
> > possble for s390 to filter crash dump even on firmware dumping
> > mechanism?
> 
> AFAIK, s390 dump mechanism could not filter dump and tha's the reason
> they wanted to support kdump and /proc/vmcore so that makedumpfile 
> could filter it. I am CCing Michael Holzheu, who did the s390 kdump
> work. He can tell it better.

Correct. The other s390 dump mechanisms (stand-alone and hypervisor
dump) are not able to do filtering and therefore the handling of large
dumps has been a problem for us.

This was one of the main reasons to implement kdump on s390.

Michael

