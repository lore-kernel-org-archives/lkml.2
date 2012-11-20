Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753646Ab2KTRIo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 12:08:44 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:37389 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752894Ab2KTRIn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 12:08:43 -0500
Date: Tue, 20 Nov 2012 17:08:17 +0000
From: Will Deacon <will.deacon@arm.com>
To: Robert Richter <rric@kernel.org>
Cc: Maynard Johnson <maynardj@us.ibm.com>,
        "jgq516@gmail.com" <jgq516@gmail.com>,
        "linux@arm.linux.org.uk" <linux@arm.linux.org.uk>,
        "oprofile-list@lists.sf.net" <oprofile-list@lists.sf.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 1/1] ARM: oprofile: add A5/A7/A15 entries in op_perf_name
Message-ID: <20121120170817.GG27765@mudshark.cambridge.arm.com>
References: <1351853016-4476-1-git-send-email-jgq516@gmail.com>
 <20121105113102.GF3351@mudshark.cambridge.arm.com>
 <20121120121747.GJ2504@rric.localhost>
 <20121120155717.GD26475@mudshark.cambridge.arm.com>
 <20121120163158.GO2504@rric.localhost>
 <20121120165517.GC27765@mudshark.cambridge.arm.com>
 <20121120170601.GR2504@rric.localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121120170601.GR2504@rric.localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 05:06:01PM +0000, Robert Richter wrote:
> On 20.11.12 16:55:17, Will Deacon wrote:
> > On Tue, Nov 20, 2012 at 04:31:58PM +0000, Robert Richter wrote:
> > > I am thinking of the following:
> > > 
> > >  # cat /root/cpu_type
> > >  arm/armv7-ca5
> > >  # cat /dev/oprofile/cpu_type
> > >  unknown
> > >  # mount --bind /root/cpu_type /dev/oprofile/cpu_type
> > >  # cat /dev/oprofile/cpu_type
> > >  arm/armv7-ca5
> > > 
> > > From here legacy oprofile tools work as expected using oprofilefs. (I
> > > think. Did not test it.) We need to change the kernel for this a bit
> > > to return 'unknown'. The mount could be done by the oprofile tools
> > > using existing cpu detection code. This is only one way to setup
> > > cpu_type from userland, there could be other ways too.
> > 
> > Ok, this is functionally equivalent to the patch that was submitted at the
> > start of this thread: it solves the problem of mapping a single ARM core to
> > a oprofile's CPU ID string. Technically, I don't mind doing that in the
> > kernel (at least, it means you don't need to do your trick above)
> 
> The advantage of a solution where userland updates cpu_type is that we
> never need to update the kernel anymore. This means, cpu detection can
> be part of the tools.

True, but the kernel-side perf code still needs updating to support the new
CPU so I don't think you win much.

Will
