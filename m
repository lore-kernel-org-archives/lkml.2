Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754889Ab1JSHgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 03:36:19 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58987 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754369Ab1JSHgR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 03:36:17 -0400
Date: Wed, 19 Oct 2011 08:35:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Tim Bird <tim.bird@am.sony.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, Andi Kleen <andi@firstfloor.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/3] ARM 4Kstacks: introduction
Message-ID: <20111019073547.GR21648@n2100.arm.linux.org.uk>
References: <4E9E0B71.9020708@am.sony.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E9E0B71.9020708@am.sony.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 04:27:45PM -0700, Tim Bird wrote:
> I'm about to submit a set of patches (really pretty small)
> to add 4K stack support to ARM (defaulted to 'N').
> 
> This has been kicking around in my Sony tree for a few years,
> and it's about time to mainline it.  The first patch is
> the actual 4KSTACKS patch.  See subsequent patches
> for tools to help with stack reduction to avoid the problems
> that apparently led to the removal of this feature on x86.

This isn't a good idea - if the feature has been abandoned on x86,
people aren't going to be soo concerned about the stack usage of
each function.  They're going to accept that there's more stack
space available, and we'll see code paths that start expecting that.

If we switch to 4K stacks, the problems of stack usage become ours.
Do we have the capacity to be able to address these issues as they
crop up?
