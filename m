Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760841Ab2FGOVI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 10:21:08 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:47456 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760684Ab2FGOVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 10:21:05 -0400
Subject: Re: [PATCH] Disable Bus Master on PCI device shutdown
From: Khalid Aziz <khalid.aziz@hp.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        bhelgaas@google.com, linux-pci@vger.kernel.org
In-Reply-To: <87obowxm5s.fsf@xmission.com>
References: <20120427190033.GA17588@ldl.usa.hp.com>
	 <20120606135009.GB1517@srcf.ucam.org> <1338999463.25761.630.camel@lyra>
	 <20120606162703.GA6779@srcf.ucam.org> <1339003956.25761.667.camel@lyra>
	 <20120606174202.GA8750@srcf.ucam.org> <1339006060.25761.689.camel@lyra>
	 <87obowxm5s.fsf@xmission.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 07 Jun 2012 08:21:00 -0600
Message-ID: <1339078860.25761.767.camel@lyra>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 12:42 -0700, Eric W. Biederman wrote:
> Absent anyone even knowing if there are devices that exist that can not
> tolerate their bus master bit being flipped when DMA is not ongoing I
> think the current state of the code is good.  When we find the broken
> hardware that can not tolerate a standard PCI bit being used in a
> standard way we can add a flag in the core to avoid doing that.
> 
> pci_device_shutdown calls drv->shutdown before calling
> pci_device_disable.  Which means that only devices that have trouble
> with this bit being flipped while DMA is ongoing and don't bother
> to stop their own DMA will have a problem.
> 
> As for shifting problems I do think we have shifted the problem in a
> very positive way.  Now instead of having a random failure at a random
> location caused by DMA happing at a random moment for no expected reason
> we have failures happening when we disable or enable a device, which
> should be much more debugable.

That is a very good point. Failure at a predictable point is much better
than random failures with the root cause being elsewhere from the point
of failure in time and code. This at least gives us a good shot at being
able to debug buggy hardware and drivers.

-- 
====================================================================
Khalid Aziz                                         Unix Systems Lab
(970)898-9214                                        Hewlett-Packard
khalid.aziz@hp.com                                  Fort Collins, CO

