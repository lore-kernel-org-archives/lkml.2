Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932618Ab0E0Ugm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 16:36:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22032 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759122Ab0E0Ugl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 16:36:41 -0400
Date: Thu, 27 May 2010 17:36:38 -0300
From: Glauber Costa <glommer@redhat.com>
To: Zachary Amsden <zamsden@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, kvm@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Add Documentation/kvm/msr.txt
Message-ID: <20100527203638.GH3445@mothafucka.localdomain>
References: <1274897088-8587-1-git-send-email-glommer@redhat.com>
 <4BFE2A2F.50209@redhat.com>
 <20100527160248.GF3445@mothafucka.localdomain>
 <4BFED258.40501@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BFED258.40501@redhat.com>
X-ChuckNorris: True
User-Agent: Jack Bauer
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 27, 2010 at 10:13:12AM -1000, Zachary Amsden wrote:
> On 05/27/2010 06:02 AM, Glauber Costa wrote:
> >On Thu, May 27, 2010 at 11:15:43AM +0300, Avi Kivity wrote:
> >>On 05/26/2010 09:04 PM, Glauber Costa wrote:
> >>>This patch adds a file that documents the usage of KVM-specific
> >>>MSRs.
> >>>
> >>Looks good.  A few comments:
> >>
> >>>+
> >>>+Custom MSR list
> >>>+--------
> >>>+
> >>>+The current supported Custom MSR list is:
> >>>+
> >>>+MSR_KVM_WALL_CLOCK:  0x11
> >>>+
> >>>+	data: physical address of a memory area.
> >>Which must be in guest RAM (i.e., don't point it somewhere random
> >>and expect the hypervisor to allocate it for you).
> >>
> >>Must be aligned to 4 bytes (we don't enforce it though).
> >I don't see the reason for it.
> >
> >If this is a requirement, our own implementation
> >is failing to meet it.
> 
> It's so the atomic write actually is atomic. 
Which atomic write? This is the wallclock, we do no atomic writes for
querying it. Not to confuse with system time (the other msr).

> Stating a 4 -byte
> alignment requirement prevents the wall clock from crossing a page
> boundary.

Yes, but why require it?

reading the wallclock is not a hot path for anybody, is usually done
just once, and crossing a page boundary here does not pose any correctness
issue.
