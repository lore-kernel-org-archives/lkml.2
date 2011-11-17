Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757934Ab1KQQbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 11:31:18 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31203 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753809Ab1KQQbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 11:31:16 -0500
Date: Thu, 17 Nov 2011 11:31:12 -0500
From: Don Zickus <dzickus@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        ying.huang@intel.com, kernel-team@fedoraproject.org,
        Matt_Domsch@dell.com, linux-acpi@vger.kernel.org
Subject: Re: GHES: Failed to read error status
Message-ID: <20111117163112.GO8685@redhat.com>
References: <20111114183635.GA6316@redhat.com>
 <CAErSpo4X1-0D1iOm=SuoxaqwWh2sVYFR_1qsZMRB00tBFnSu+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAErSpo4X1-0D1iOm=SuoxaqwWh2sVYFR_1qsZMRB00tBFnSu+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 08:29:56AM -0700, Bjorn Helgaas wrote:
> [+linux-acpi]
> 
> On Mon, Nov 14, 2011 at 11:36 AM, Dave Jones <davej@redhat.com> wrote:
> > It appears that there's a problem with Dell poweredge servers
> > and GHES judging by the bug reports at
> >
> > https://bugzilla.redhat.com/show_bug.cgi?id=746755
> > https://bugs.launchpad.net/ubuntu/+bug/881164
> >
> > Is this likely to be something that Dell need to fix in a firmware update,
> > or something that the code needs to accomodate ?

I think one problem was that in 2.6.38 the kernel saw HEST/GHES was
supported and just tried to communicate with it.  Unfortunately the kernel
forgot to tell the BIOS that it supports firmware first mode, so in this
case the firmware is probably blocking the GHES access and the kernel is
confused why.

The following commits resolved that issue (which may not entirely fix the
problem, but might move it along).

9fb0bfe ACPI, APEI, Add WHEA _OSC support
b3b46d7 APEI: Fix WHEA _OSC call

The second one in particular was noticed by Dell.  Though I recall that we
needed to update the firmware to get Dell boxes working, but that was
probably for EINJ.

Cheers,
Don
