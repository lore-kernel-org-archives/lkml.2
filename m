Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755564Ab1KLBa0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 20:30:26 -0500
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:51283 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751292Ab1KLBaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 20:30:25 -0500
MIME-Version: 1.0
In-Reply-To: <20111112010850.GT14486@sequoia.sous-sol.org>
References: <20111111224849.9756.13368.stgit@bling.home> <1321058267.2006.21.camel@shinybook.infradead.org>
 <CAL1RGDXZjKhA++3eFVPbazixaM7Q_JfBJyLKE0xjBs+sK55idg@mail.gmail.com>
 <20111112005100.GR14486@sequoia.sous-sol.org> <1321059340.2006.27.camel@shinybook.infradead.org>
 <20111112010850.GT14486@sequoia.sous-sol.org>
From: Roland Dreier <roland@purestorage.com>
Date: Fri, 11 Nov 2011 17:30:01 -0800
Message-ID: <CAL1RGDXiE5=GZvogdOnSkOKKc_YdWyrh0W+ZT2S71TmMdQHcBw@mail.gmail.com>
Subject: Re: [PATCH] intel-iommu: Default to non-coherent for domains
 unattached to iommus
To: Chris Wright <chrisw@sous-sol.org>
Cc: David Woodhouse <dwmw2@infradead.org>,
        Alex Williamson <alex.williamson@redhat.com>,
        iommu@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 5:08 PM, Chris Wright <chrisw@sous-sol.org> wrote:
>> I would be more inclined to suspect that there's some
>> chipset buffering that we aren't correctly flushing (which might in
>> itself be a hardware issue, since the way to flush the cache is supposed
>> to be well-defined).
>
> Roland, have you tried switching BIOS to Coherency On and can do you
> ever see stale PTEs?

Yeah, the problems go away if I turn on coherency.

More details here:
  https://lkml.org/lkml/2011/10/11/412

(and after that email, I let the box run long enough that I'm pretty
sure turning VT-d coherency on does fix things)

I'd love to fix this but not sure how much I can contribute beyond
tests (I don't see anything wrong in the VT-d cache flushing code
in the kernel, and I did look for a while).

 - R.
