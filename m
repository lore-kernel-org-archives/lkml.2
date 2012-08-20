Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753860Ab2HTULJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 16:11:09 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:51140 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226Ab2HTULG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 16:11:06 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH v2 23/31] arm64: Debugging support
Date: Mon, 20 Aug 2012 20:10:59 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ulrich.weigand@linaro.org" <ulrich.weigand@linaro.org>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com> <20120820090754.GB25864@mudshark.cambridge.arm.com> <20120820092744.GD25864@mudshark.cambridge.arm.com>
In-Reply-To: <20120820092744.GD25864@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208202010.59985.arnd@arndb.de>
X-Provags-ID: V02:K0:nAquFeaLZxdFy4K1kpqtoyZJwCSlCL16IND2zQd0ozG
 ZGVi1BufH9OcaXS56BzPSoTElD1N/t+WUl4T0w5WRuRmBp63bX
 ywuhqrSBMDBQ1f9zmTRgJg6hcwyM4+dNTorEqmTL24rPp7tJBt
 BpKh+RJIrZgsux2ageehRH6YIxJo+Qk5sG+kTWYfPpIJJREPf4
 /LX2StK+oxV/JhVgU2szEKz7DM6+ffhYUGNhe6ZoU1vEIL3R59
 YUn4XCJVVuDpONnz8h+2+7ECZmNvJ8N8Fd3tgmhrnprAlyrg0z
 QILqzpXGyca+xQKzRvyZeuRb3AkgspMZPuR/8bJoyOA9T5YU+q
 ygP6DEABbnm/xCfy0u/c=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 20 August 2012, Will Deacon wrote:
> On Mon, Aug 20, 2012 at 10:07:54AM +0100, Will Deacon wrote:
> > On Fri, Aug 17, 2012 at 08:06:07AM +0100, Arnd Bergmann wrote:
> > > Sorry for the dumb question, but why do you even need PTRACE_GET_THREAD_AREA
> > > for 64 bit tasks? I thought the thread pointer is a GPR, or is this just
> > > for compat tasks?
> > 
> > The TLS is stored in a co-processor register which is read-only for
> > userspace.
> 
> I should elaborate: the register is RW for AArch64 tasks, RO for aarch32
> tasks (although that doesn't affect the need for the ptrace request).

So can't you just /add/ that register to the GPR regset?

	Arnd
