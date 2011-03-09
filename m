Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab1CIGcQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 01:32:16 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:41813 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab1CIGcP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 01:32:15 -0500
Message-ID: <4D771EE6.5050404@linux.vnet.ibm.com>
Date: Wed, 09 Mar 2011 12:02:06 +0530
From: Mahesh Jagannath Salgaonkar <mahesh@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Anton Blanchard <anton@samba.org>, akpm@linux-foundation.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 1/2] kdump: Allow shrinking of kdump region to be overridden
References: <20100825002258.GD28360@kryten> <m139u37cii.fsf@fess.ebiederm.org>
In-Reply-To: <m139u37cii.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2010 06:07 AM, Eric W. Biederman wrote:
> Anton Blanchard <anton@samba.org> writes:
> 
>> On ppc64 the crashkernel region almost always overlaps an area of firmware.
>> This works fine except when using the sysfs interface to reduce the kdump
>> region. If we free the firmware area we are guaranteed to crash.
> 
> That is ppc64 bug.  firmware should not be in the reserved region.  Any
> random kernel like thing can be put in to that region at any valid
> address and the fact that shrinking the region frees your firmware means
> that using that region could also stomp your firmware (which I assume
> would be a bad thing).
The issue only happens while shrinking the region using sysfs interface.
We already have checks in kexec for not to stomp over on the firmware
overlap area while loading capture kernel. Currently we do a top-down
allocation for the firmware region which means it sits at the top of the
RMO, right in the middle of the crashdump region. We can not move the
crashkernel region beyond firmware region because kernel needs its some
of memory in RMO region.
> 
> So please fix the ppc64 reservation.
> 
> Eric
> _______________________________________________
> Linuxppc-dev mailing list
> Linuxppc-dev@lists.ozlabs.org
> https://lists.ozlabs.org/listinfo/linuxppc-dev

