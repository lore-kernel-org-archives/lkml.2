Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754959Ab1JTICK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 04:02:10 -0400
Received: from gate.crashing.org ([63.228.1.57]:43292 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754142Ab1JTICI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 04:02:08 -0400
Subject: Re: IOMMU keeping mapping over long period of time
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
In-Reply-To: <20111018154828.GA4201@homer.localdomain>
References: <20111018154828.GA4201@homer.localdomain>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 20 Oct 2011 10:00:00 +0200
Message-ID: <1319097600.29415.568.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-10-18 at 11:48 -0400, Jerome Glisse wrote:
> Hi,
> 
> For GPU we are entertaining the idea of keeping pci/dma mapping of page
> around for the whole life span of GPU object (which can be as long as
> the computer uptime). Here we are talking about possibly several GB of
> data.
> 
> GPU for which we are interested have dma mask of 40bits at least, thus
> they can work with high mem page. My main concern is when an iommu is
> active, such amount of continuously mapped page might exhaust the iommu
> address space. My understanding is that Intel & AMD iommu are capable of
> growing their address space but is it somethings we can rely on ?

This will be problematic on other platforms. Also keep in mind that
objects mapped in the iommu can no longer be swapped out.

It might be useful to have a more 'lazy' mechanism where objects are
kept mapped but with a callback to unmap them in case of iommu pressure.

The problem of course with such a scheme is that it requires iommu
object tracking and horrible locking issues.

Ben.


