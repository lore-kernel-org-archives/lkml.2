Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932614Ab1BPAf1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:35:27 -0500
Received: from mga02.intel.com ([134.134.136.20]:45024 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932353Ab1BPAfV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:35:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,477,1291622400"; 
   d="scan'208";a="603025517"
From: "Benenati, Chris J" <chris.j.benenati@intel.com>
To: "Hans J. Koch" <hjk@hansjkoch.de>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@suse.de>
Date: Tue, 15 Feb 2011 16:35:16 -0800
Subject: RE: uio: power management of user-space drivers
Thread-Topic: uio: power management of user-space drivers
Thread-Index: AcvNb4x93zzXsPtnQeeImrYWE1NltAAADTBA
Message-ID: <0635488208022A4F82521A04A4772E15C555EF7B@orsmsx503.amr.corp.intel.com>
References: <0635488208022A4F82521A04A4772E15C555EC7E@orsmsx503.amr.corp.intel.com>
 <20110215231236.GE2785@local>
 <0635488208022A4F82521A04A4772E15C555EE4E@orsmsx503.amr.corp.intel.com>
 <20110216001847.GF2785@local>
In-Reply-To: <20110216001847.GF2785@local>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Well, for example, a device may have complex application-driven hardware state,
which in turn in turn can be driven by user inputs. That state will be lost when
the system powers down.  It might be necessary to invoke the driver suspend()
function before power is dropped, to read registers and preserve that state.
It is definitely necessary to call the resume function to reprogram the registers
when the power is restored.

-----Original Message-----
From: Hans J. Koch [mailto:hjk@hansjkoch.de] 
Sent: Tuesday, February 15, 2011 4:21 PM
To: Benenati, Chris J
Cc: Hans J. Koch; linux-kernel@vger.kernel.org; Greg KH
Subject: Re: uio: power management of user-space drivers

On Tue, Feb 15, 2011 at 03:27:10PM -0800, Benenati, Chris J wrote:

Could you please limit the line length in your mails to something like
80 characters?

> Thanks for your reply. I understand (pretty much) the suspend/resume interface
> and its registration via the Linux device model.
> 
> However, that is a kernel-level interface. Assuming you have a kernel component to
> your driver, I suppose it could register a suspend() function and communicate it to
> the user space part of the driver.
> 
> But in a case like suspend-to-RAM, the kernel freezes user space threads before the
> suspend() functions are invoked.  By the time the suspend function is called, it
> is too late to communicate with user space. 
> 
> Is there a form of user-space driver notification supported by the kernel? Or does
> the kernel portion of the driver have to register for kernel notifications (which
> precede thread freezing) and alert the user space portion before it is frozen? 

What are you trying to achieve?
Could you give an example of the problem you're facing in your application?

Let me guess: suspend/resume functions are supposed to leave your hardware in
a consistent state and you don't know the state if the suspend() catches you
in the middle of your userspace processing?
I remember the Android guys had problems like that and invented some
"suspend blockers". However, I don't remember what the final answer in that
discussion was. Greg?

Thanks,
Hans

> 
> -----Original Message-----
> From: Hans J. Koch [mailto:hjk@hansjkoch.de] 
> Sent: Tuesday, February 15, 2011 3:13 PM
> To: Benenati, Chris J
> Cc: hjk@hansjkoch.de
> Subject: Re: power management of user-space drivers
> 
> On Tue, Feb 15, 2011 at 01:46:03PM -0800, Benenati, Chris J wrote:
> > Somebody brought your web page http://www.kernel.org/doc/htmldocs/uio-howto.html to my attention.
> 
> Hi Chris,
> first of all: Please don't send private mail to kernel maintainers unless
> you're willing to pay for private consultation. UIO is discussed on the
> Linux Kernel Mailing List (LKML), and it's a benefit for everyone if these
> discussions are public and can be found in the archives by search engines.
> 
> So, please make sure you Cc: LKML (linux-kernel@vger.kernel.org) in any
> further mails.
> 
> > 
> > How do you handle power management with such a driver?  For example, if state has to be saved before a suspend-to-RAM, or reinitialized on the subsequent resume.
> 
> You need to do that yourself, e.g. for a PCI card by implementing a suspend()
> and resume() function and setting the respective pointers in struct pci_driver.
> These functions will be called automatically by the driver core, and you can do
> whatever you need there.
> 
> A way to implement such a thing for platform devices can be found in
> drivers/uio/uio_pdrv_genirq.c
> 
> Thanks,
> Hans
 
