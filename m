Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753474Ab2BOROp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 12:14:45 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:59672 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752905Ab2BOROo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 12:14:44 -0500
Date: Wed, 15 Feb 2012 17:14:15 +0000
From: Will Deacon <will.deacon@arm.com>
To: Eric Paris <eparis@redhat.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Axel Lin <axel.lin@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Nathaniel Husted <nhusted@gmail.com>,
        Dave Martin <dave.martin@linaro.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Ingo Molnar <mingo@elte.hu>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] ARM: ptrace: Include linux/audit.h to fix build errors
Message-ID: <20120215171415.GE29319@mudshark.cambridge.arm.com>
References: <1329284188.12708.1.camel@phoenix>
 <20120215083609.GD13673@n2100.arm.linux.org.uk>
 <1329325622.2337.13.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1329325622.2337.13.camel@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 15, 2012 at 05:07:02PM +0000, Eric Paris wrote:
> Fixing the arch flag to be correct means we could do that translation
> properly.  I haven't seen the patches to support translation of arm raw
> bits to something higher level in audit userspace, but I assume it's
> coming as soon as someone cares.
> 
> So if someone tells me how the code knows it's endianness I'll gladly
> write the ifdef to switch from AUDIT_ARCH_ARMEB to AUDIT_ARCH_ARM when
> appropriate....

You should just be able to use #ifdef __ARMEB__ for the big-endian case (we
don't support a little-endian kernel with a big-endian userspace or anything
funky like that). If Russell has reverted the original patch your best bet is
probably to spin a v2 of the ARM bits and post it to LAK.

Will
