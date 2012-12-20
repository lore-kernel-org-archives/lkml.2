Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751515Ab2LTIMh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2012 03:12:37 -0500
Received: from us01smtp3.synopsys.com ([198.182.44.81]:35427 "EHLO
	hermes.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751069Ab2LTIM3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2012 03:12:29 -0500
Message-ID: <50D2C78B.4060109@synopsys.com>
Date: Thu, 20 Dec 2012 13:38:43 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: <linux-arch@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tglx@linutronix.de>
Subject: Re: [RFC Patch v1 45/55] ARC: unaligned access emulation
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-15-git-send-email-vgupta@synopsys.com> <201211121400.13046.arnd@arndb.de>
In-Reply-To: <201211121400.13046.arnd@arndb.de>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012 07:30 PM, Arnd Bergmann wrote:
> On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
>> +
>> +config ARC_MISALIGN_ACCESS
>> +       bool "Emulate unaligned memory access (userspace only)"
>> +       default N
>> +       help
>> +         This enables misaligned 16 & 32 bit memory access from user space.
>> +         Use ONLY-IF-ABS-NECESSARY as it will be very slow and also can hide
>> +         potential bugs in code
> 
> parisc and ia64 both have the same feature, and they use sysctl to configure
> it at run-time. Maybe you should pick one of the two sysctl implementations
> and hook that up to your implementation as well.

Spoke too soon ! The only caveat to removing the Kconfig option is that
it will pull-in unaligned emulation code as well as the dependent
in-kernel disassembler unconditionally into the build.

Are you OK if we keep this support build time - provided that once it is
build time enabled - we have the additional runtime sysctl based
toggle-ability as you suggested.

Only one of our customers need this feature and this gives people
reasons to moan about the kernel .text size and such.

Thanks,
Vineet

