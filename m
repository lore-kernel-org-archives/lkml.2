Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756825Ab0DAV3s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:29:48 -0400
Received: from sj-iport-5.cisco.com ([171.68.10.87]:29059 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752787Ab0DAV3q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:29:46 -0400
Authentication-Results: sj-iport-5.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAPqstEurR7Hu/2dsb2JhbACDEpg4cZ05iEOQSIErgmtrBIMj
X-IronPort-AV: E=Sophos;i="4.51,350,1267401600"; 
   d="scan'208";a="176176999"
From: Tom Lyon <pugs@lyon-about.com>
To: Avi Kivity <avi@redhat.com>
Subject: Re: [PATCH 0/1] uio_pci_generic: extensions to allow access for non-privileged processes
Date: Thu, 1 Apr 2010 14:27:07 -0700
User-Agent: KMail/1.9.9
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201003311708.38961.pugs@lyon-about.com> <201004010839.07451.pugs@lyon-about.com> <4BB4C1A6.8050904@redhat.com>
In-Reply-To: <4BB4C1A6.8050904@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201004011427.07353.pugs@lyon-about.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 01 April 2010 08:54:14 am Avi Kivity wrote:
> On 04/01/2010 06:39 PM, Tom Lyon wrote:
> >>> - support for MSI and MSI-X interrupts (the intel 82599 VFs support
> >>> only MSI-X)
> >>
> >> How does a userspace program receive those interrupts?
> >
> > Same as other UIO drivers - by read()ing an event counter.
>
> IIRC the usual event counter is /dev/uioX, what's your event counter now?
>
> kvm really wants the event counter to be an eventfd, that allows hooking
> it directly to kvm (which can inject an interrupt on an eventfd_signal),
> can you adapt your patch to do this?

I looked further into eventfds - they seem the perfect solution for the 
MSI/MSI-X interrupts. Will include in V2.
