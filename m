Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008Ab2FNATF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:19:05 -0400
Received: from smtp-fw-4101.amazon.com ([72.21.198.25]:42104 "EHLO
	smtp-fw-4101.amazon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab2FNATD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:19:03 -0400
X-IronPort-AV: E=Sophos;i="4.77,407,1336348800"; 
   d="scan'208";a="750577256"
Date: Wed, 13 Jun 2012 17:18:55 -0700
From: Matt Wilson <msw@amazon.com>
To: Jason Stubbs <jasonbstubbs@gmail.com>
Cc: Dave Chinner <david@fromorbit.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "xen-devel@lists.xen.org" <xen-devel@lists.xen.org>
Subject: Re: PROBLEM: Possible race between xen, md, dm and/or xfs
Message-ID: <20120614001855.GA2136@US-SEA-R8XVZTX>
References: <4FD1918A.2060908@gmail.com>
 <20120612035737.GL22848@dastard>
 <4FD731F9.8070509@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FD731F9.8070509@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 05:11:37AM -0700, Jason Stubbs wrote:
> On 2012-6-12 13:57 , Dave Chinner wrote:
> > Nothing
> > wrong with MD, LVM, or XFS. The problem is either that EBS never
> > completed the IO, or Xen swallowed it and it never made to it to the
> > guest OS. Either way, it does not appear to be a problem in the
> > higher levels of the linux storage stack.
> 
> Thanks Dave for looking into this.
> 
> I'll be sure to give Amazon ample opportunity to diagnose things from
> there side should the issue occur again and hopefully there won't be
> any more people reporting extraneous issues.

Hi Jason,

If you're able to reproduce this hang, I'm sure that we can get to the
root of the problem quite quickly. Short of that, if you can provide a
running instance that is exhibiting the problem we can do some
live-system debugging. It is much more difficult to determine root
cause and verify fixes without reproduction instructions.

Given the kernel version you reported in your traces, I can at least
rule out one known bug that caused blkfront to wait forever for an IO
to complete: 
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=dffe2e1

The kernel version you're using using includes the follow-on change to
use fasteoi:
  http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commitdiff;h=3588fe2

I'm sorry that I can't be more of more immediate help. If you
encounter the problem again, please contact developer support.

Matt
