Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758570Ab0DAT10 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 15:27:26 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:35971 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751222Ab0DAT1X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 15:27:23 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EANuQtEurR7H+/2dsb2JhbACDEpgrcZ0ciEOQTIErgmtrBIMj
X-IronPort-AV: E=Sophos;i="4.51,350,1267401600"; 
   d="scan'208";a="176102308"
From: Tom Lyon <pugs@lyon-about.com>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged processes
Date: Thu, 1 Apr 2010 12:24:45 -0700
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Hans J. Koch" <hjk@linutronix.de>, gregkh@suse.de
References: <201003311708.38961.pugs@lyon-about.com> <201004010906.47321.pugs@lyon-about.com> <4BB4C591.8000102@redhat.com>
In-Reply-To: <4BB4C591.8000102@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004011224.45336.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010 09:10:57 am Avi Kivity wrote:
> On 04/01/2010 07:06 PM, Tom Lyon wrote:
> > On Thursday 01 April 2010 08:54:14 am Avi Kivity wrote:
> >> On 04/01/2010 06:39 PM, Tom Lyon wrote:
> >>>>> - support for MSI and MSI-X interrupts (the intel 82599 VFs support
> >>>>> only MSI-X)
> >>>>
> >>>> How does a userspace program receive those interrupts?
> >>>
> >>> Same as other UIO drivers - by read()ing an event counter.
> >>
> >> IIRC the usual event counter is /dev/uioX, what's your event counter
> >> now?
> >
> > Exact same mechanism.
>
> But there are multiple msi-x interrupts, how do you know which one
> triggered?

You don't. This would suck for KVM, I guess, but we'd need major rework of the 
generic UIO stuff to have a separate event channel for each MSI-X.

For my purposes, collapsing all the MSI-Xs into one MSI-look-alike is fine, 
because I'd be using MSI anyways if I could. The weird Intel 82599 VF only 
supports MSI-X.

So one big question is - do we expand the whole UIO framework for KVM 
requirements, or do we split off either KVM or non-VM into a separate driver?
Hans or Greg - care to opine?




