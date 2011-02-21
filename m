Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab1BUDoB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 22:44:01 -0500
Received: from mail3.microsoft.com ([131.107.115.214]:52700 "EHLO
	smtp.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755618Ab1BUDoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 22:44:00 -0500
From: KY Srinivasan <kys@microsoft.com>
To: Thomas Gleixner <tglx@linutronix.de>
CC: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "Hank Janssen" <hjanssen@microsoft.com>
Subject: RE: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Thread-Topic: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
Thread-Index: AQHLzUkvKd3MYDWV20OaBRjCSuUWD5QJKYYA//++VECAAJKGgP//jS1QgAIW1ACAADc3wA==
Date: Mon, 21 Feb 2011 03:43:58 +0000
Message-ID: <6E21E5352C11B742B20C142EB499E04801191C@TK5EX14MBXC124.redmond.corp.microsoft.com>
References: <1297799735-25917-1-git-send-email-kys@microsoft.com>
 <alpine.LFD.2.00.1102191046220.2701@localhost6.localdomain6>
 <6E21E5352C11B742B20C142EB499E048011738@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <alpine.LFD.2.00.1102191540290.2701@localhost6.localdomain6>
 <6E21E5352C11B742B20C142EB499E048011787@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <alpine.LFD.2.00.1102201705380.2701@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1102201705380.2701@localhost6.localdomain6>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [157.54.123.12]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----Original Message-----
> From: Thomas Gleixner [mailto:tglx@linutronix.de]
> Sent: Sunday, February 20, 2011 11:16 AM
> To: KY Srinivasan
> Cc: gregkh@suse.de; linux-kernel@vger.kernel.org;
> devel@linuxdriverproject.org; virtualization@lists.osdl.org; Haiyang Zhang; Hank
> Janssen
> Subject: RE: [PATCH]: Staging: hv: Allocate the vmbus irq dynamically
> 
> On Sat, 19 Feb 2011, KY Srinivasan wrote:
> > > When grabbing some random irq from the PIC is not an issue, then
> > > what's the point of this probing, retry loop and the comments about
> > > racing ? What races here? That does not make sense at all.
> >
> > Like most virtualization platforms, Hyper-V also emulates the full PC
> > platform. So, it is possible that the driver of some other emulated
> > devices might register for the IRQ line we might have selected. That
> > is the race this code addresses. For performance reasons, we want
> > both storage and network traffic to go over the PV drivers.
> 
> So in case your driver gets the interrupt line first, which the other
> driver wants to acquire as well, then what? Do you want to do that
> probe magic in the other driver as well? What if this is a regular
> device driver which gets its irq number from ACPI/PCI or
> whatever. Then that driver simply wont work as it's interrupt line is
> busy.
> 
> > >
> > > I don't know why the previous reviewer wanted to have that
> > > dynamic. That just does not make sense to me.
> >
> > Prior to this patch, we had a hard coded interrupt line for use by
> > this driver. If that line was already in use, the load of this driver
> > would fail. This would be a fatal issue especially for distributions
> > that have embedded these PV drivers as part of their installation
> > media. This patch deals with such collisions in a more graceful way -
> > we would not bail until we have scanned all low interrupt lines.
> 
> So you trade breaking the PV stuff against breaking random other
> drivers? That doesn't sound like a brilliant idea.
> 
> There are various ways to solve that proper.
> 
>  - You can provide the interrupt number from ACPI/PCI or whatever your HV
>    provides as enumeration.
> 
>  - Use a fixed vector like XEN does for the event channel
> 
>  - Use dynamic allocation in the IOAPIC space like the kernel does for
>    MSI(-X)
> 
> Thanks,
> 
> 	tglx

I am not claiming that what I have done here is the best possible solution.
However, I will submit to you that it is better than what we had here
prior to this patch.  I will address this and a  whole lot of other issues 
in future patches. 

Regards,

K. Y

