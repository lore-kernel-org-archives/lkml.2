Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753120Ab1KOEyQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 23:54:16 -0500
Received: from sous-sol.org ([216.99.217.87]:60917 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751087Ab1KOEyO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 23:54:14 -0500
Date: Mon, 14 Nov 2011 20:54:04 -0800
From: Chris Wright <chrisw@sous-sol.org>
To: cody <mail.kai.huang@gmail.com>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Roland Dreier <roland@purestorage.com>, linux-pci@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Chris Wright <chrisw@sous-sol.org>
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains
 unattached to iommus
Message-ID: <20111115045404.GC30247@sequoia.sous-sol.org>
References: <20111111224849.9756.13368.stgit@bling.home>
 <1321058267.2006.21.camel@shinybook.infradead.org>
 <CAL1RGDXZjKhA++3eFVPbazixaM7Q_JfBJyLKE0xjBs+sK55idg@mail.gmail.com>
 <20111112005100.GR14486@sequoia.sous-sol.org>
 <1321059340.2006.27.camel@shinybook.infradead.org>
 <20111112010850.GT14486@sequoia.sous-sol.org>
 <1321060841.2006.35.camel@shinybook.infradead.org>
 <4EC210CB.1010409@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4EC210CB.1010409@gmail.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* cody (mail.kai.huang@gmail.com) wrote:
> On 11/11/2011 05:20 PM, David Woodhouse wrote:
> >On Fri, 2011-11-11 at 17:08 -0800, Chris Wright wrote:
> >>On a slightly separate, but performance related note...have you ever
> >>tried using the hw queue?  Currently we only have a sw queue, but the
> >>submission path for invalidations doesn't really queue (unless I missed
> >>it).  It seems to pull from the software queue and submit/wait,
> >>submit/wait...Seems simple enough to submit the whole queue and then
> >>issue the wait.
> >I have a feeling we trigger errata if we do that — although if we're
> >only doing it for an emulated IOMMU that shouldn't be an issue.
> >
> What does the emulated IOMMU here? Does it mean the emulated IOMMU
> exposed to guest VM?

Yes.  So for KVM, the IOMMU emulation would be in QEMU.

thanks,
-chris
