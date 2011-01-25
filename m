Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752890Ab1AYMpp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 07:45:45 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:36854 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476Ab1AYMpo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 07:45:44 -0500
Date: Tue, 25 Jan 2011 12:45:24 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Dave Martin <dave.martin@linaro.org>
Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>,
        sen wang <wangchendu@gmail.com>, David Brown <davidb@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: questions about arm trustzone
Message-ID: <20110125124524.GJ11507@n2100.arm.linux.org.uk>
References: <AANLkTi=eCOiP7MrUSG4WRMN0kj_+ZWvZ=z7VYDfkshU_@mail.gmail.com> <8yad3nlh18e.fsf@huya.qualcomm.com> <AANLkTin9fSw5DdqdgCEvtdtc83LFOeA7t0OAUugVmRFD@mail.gmail.com> <20110125102652.GB11507@n2100.arm.linux.org.uk> <bb0c3855a121603232d022b4062752a6@mail.gmail.com> <AANLkTi=vZSZkN2k1gZD0F-C74b_jFWX5HhDhr7BiPhN7@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=vZSZkN2k1gZD0F-C74b_jFWX5HhDhr7BiPhN7@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 25, 2011 at 12:24:13PM +0000, Dave Martin wrote:
> Avoiding this complexity is one of the motivations for using r7 for
> the syscall number with CONFIG_EABI (instead of using the SVC comment
> field).

Your history is not entirely correct.

I had the kernel side of Thumb userspace support in place long before EABI
came along.  Thumb doesn't have a large enough comment field to store the
Linux syscall number, so to get around that problem, I decided to use r7
for the syscall number.  You'll find 2.4 kernels support Thumb instructions
in userspace.

As part of the EABI switch for ARM mode - which created an incompatible
SWI interface anyway, we decided that we could reduce data cache pollution
by eliminating the read of the SWI instruction, so we adopted the r7
method for ARM EABI mode.
