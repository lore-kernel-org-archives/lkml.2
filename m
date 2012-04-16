Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753540Ab2DPMLN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 08:11:13 -0400
Received: from casper.infradead.org ([85.118.1.10]:56284 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753100Ab2DPMLM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 08:11:12 -0400
Message-ID: <1334578264.28150.39.camel@twins>
Subject: Re: [PATCH 2/5] perf: generic intel uncore support
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: "Yan, Zheng" <zheng.z.yan@intel.com>
Cc: mingo@elte.hu, andi@firstfloor.org, eranian@google.com,
        linux-kernel@vger.kernel.org, ming.m.lin@intel.com
Date: Mon, 16 Apr 2012 14:11:04 +0200
In-Reply-To: <4F838370.2080305@intel.com>
References: <1332916998-10628-1-git-send-email-zheng.z.yan@intel.com>
	  <1332916998-10628-3-git-send-email-zheng.z.yan@intel.com>
	  <1333163902.2960.63.camel@laptop>  <4F77C75B.4060105@intel.com>
	  <1333404693.2960.82.camel@laptop>  <4F7AB4AC.1060108@intel.com>
	 <1333463364.2960.100.camel@laptop> <4F838370.2080305@intel.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-04-10 at 08:48 +0800, Yan, Zheng wrote:
> On 04/03/2012 10:29 PM, Peter Zijlstra wrote:
> > On Tue, 2012-04-03 at 16:28 +0800, Yan, Zheng wrote:
> >> On 04/03/2012 06:11 AM, Peter Zijlstra wrote:
> >>> On Sun, 2012-04-01 at 11:11 +0800, Yan, Zheng wrote:
> >>>>
> >>>> Because using per-cpu allocation is inconvenience for PCI uncore device.
> >>>
> >>> What are those, where does one read about them and why?
> >>>
> >> PCI uncore device support was added by patch 4. If using per-cpu pointer,
> >> we have to setup the per-cpu pointer after the PCI driver's probe function
> >> recognizes the uncore device. It means we have to first add the PCI uncore
> >> device to a list, then call a function on all cpus to scan the list, find
> >> the right uncore device and setup the per-cpu pointer.
> > 
> > Yeah, I saw that, but it was all completely lacking in where one can
> > find actual detail on that stuff. What parts of the SDM do I read? Is
> > there anything other than the SDM, etc..
> > 
> The uncore performance monitoring guide:
> 
> http://www.intel.com/content/dam/www/public/us/en/documents/design-guides/xeon-e5-2600-uncore-guide.pdf

Thanks,.. ok so I don't see what the problem for PCI is. They're similar
to the MSR based ones except the access is memory-io instead of MSR.
