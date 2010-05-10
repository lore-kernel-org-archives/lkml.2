Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab0EJRw0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 13:52:26 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:13674 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750985Ab0EJRwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 13:52:24 -0400
From: Dmitry Torokhov <dtor@vmware.com>
Organization: VMware, Inc.
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [tip:x86/cpu] Modify the VMware balloon driver for the new x86_hyper API
Date: Mon, 10 May 2010 10:52:22 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.34-rc5; KDE/4.4.2; x86_64; ; )
Cc: "mingo@redhat.com" <mingo@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "hjanssen@microsoft.com" <hjanssen@microsoft.com>,
       "ksrinivasan@novell.com" <ksrinivasan@novell.com>,
       "tglx@linutronix.de" <tglx@linutronix.de>,
       Alok Kataria <akataria@vmware.com>,
       "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
References: <4BE49778.6060800@zytor.com> <201005100917.28980.dtor@vmware.com> <4BE842C3.5040300@zytor.com>
In-Reply-To: <4BE842C3.5040300@zytor.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201005101052.22796.dtor@vmware.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 May 2010 10:30:43 am H. Peter Anvin wrote:
> On 05/10/2010 09:17 AM, Dmitry Torokhov wrote:
> > On Monday 10 May 2010 08:23:28 am H. Peter Anvin wrote:
> >> On 05/10/2010 01:06 AM, Dmitry Torokhov wrote:
> >>> Source please? I was not aware that there was a standard governing
> >>> returns code for module init methods.
> >> 
> >> ENODEV means "not a device node."
> >> ENXIO means "hardware not present."
> > 
> > There is no device node in question. Again, could you please point me to
> > the list of allowed error codes for init methods? According to SUS,
> > we need to follow ERROR section of the appropriate function, and I do
> > not believe that spec covers cases if driver binding and module loading.
> > 
> > FWIW -ENODEV is explicitly allowed in our device core and means "device
> > not found", especially in context of platform devices. I do not see the
> > need of changing that.
> 
> The problem with this abuse of ENODEV is that people start using it
> elsewhere, where it *DOES* matter than ENXIO is the proper return code.
>  Yes, we handle incorrect uses of ENODEV, but the right thing to do is
> to teach people to use ENXIO properly.

The usage that you mention only valid in the context of working with
device nodes. In other cases it can be used to indicate different errors
altogether:

mmap:

[ENODEV]
    The fildes argument refers to a file whose type is not supported
    by mmap().

fallocate:

[ENODEV]
    The fd argument does not refer to a regular file.

Linux mount:

      ENODEV filesystemtype not configured in the kernel.

      ENXIO  The major number of the block device source is out of range.

Solaris ldi:

ENODEV

    Requested device does not exist.

ENXIO

    Unsupported device operation or access mode.

and so on...

-- 
Dmitry
