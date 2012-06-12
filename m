Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752963Ab2FLD5m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 23:57:42 -0400
Received: from ipmail06.adl2.internode.on.net ([150.101.137.129]:13019 "EHLO
	ipmail06.adl2.internode.on.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752019Ab2FLD5l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 23:57:41 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Ak0JAFG91k95LKXc/2dsb2JhbABFs2gEgTCBCIIYAQEFOhwjEAgDGC4UJQMhE4gKuQIUiw8gMIVBA5Uej3yCcoFF
Date: Tue, 12 Jun 2012 13:57:37 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jason Stubbs <jasonbstubbs@gmail.com>
Cc: linux-kernel@vger.kernel.org, xen-devel@lists.xen.org
Subject: Re: PROBLEM: Possible race between  xen, md, dm and/or xfs
Message-ID: <20120612035737.GL22848@dastard>
References: <4FD1918A.2060908@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD1918A.2060908@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 08, 2012 at 03:45:46PM +1000, Jason Stubbs wrote:
> Hi,
> 
> To quickly summarize, on a Xen domU instance with a disk structure of XFS on
> LVM2 on RAID10 on 8x virtual disks, all tasks performing I/O to said XFS
> partition hung and I cannot prove or disprove it to be dom0 issue.
> 
> And now the long(er) version:
> 
> On an Amazon EC2 (xen) instance, I had I/O to one of the EBS (Elastic Block
> Store virtual disk) devices block with iostat showing one single request
> pending. Kernel logs showed hung tasks so after grabbing those I reset the
> instance but - while I'm told that Amazon's logs don't show any problems
> with the EBS - Amazon want the opportunity to exclude an EBS problem by
> examining things from the dom0 side while the problem is occurring before
> delving into the kernel.

Yup, everything is hung waiting for that one IO to complete. Nothing
wrong with MD, LVM, or XFS. The problem is either that EBS never
completed the IO, or Xen swallowed it and it never made to it to the
guest OS. Either way, it does not appear to be a problem in the
higher levels of the linux storage stack.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
