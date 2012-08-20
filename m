Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756054Ab2HTJ17 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 05:27:59 -0400
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:57455 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753977Ab2HTJ1x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 05:27:53 -0400
Date: Mon, 20 Aug 2012 10:27:44 +0100
From: Will Deacon <will.deacon@arm.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Catalin Marinas <Catalin.Marinas@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ulrich.weigand@linaro.org" <ulrich.weigand@linaro.org>
Subject: Re: [PATCH v2 23/31] arm64: Debugging support
Message-ID: <20120820092744.GD25864@mudshark.cambridge.arm.com>
References: <1344966752-16102-1-git-send-email-catalin.marinas@arm.com>
 <20120816104748.GI31784@mudshark.cambridge.arm.com>
 <201208161249.35008.arnd@arndb.de>
 <201208170706.07821.arnd@arndb.de>
 <20120820090754.GB25864@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120820090754.GB25864@mudshark.cambridge.arm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 10:07:54AM +0100, Will Deacon wrote:
> On Fri, Aug 17, 2012 at 08:06:07AM +0100, Arnd Bergmann wrote:
> > Sorry for the dumb question, but why do you even need PTRACE_GET_THREAD_AREA
> > for 64 bit tasks? I thought the thread pointer is a GPR, or is this just
> > for compat tasks?
> 
> The TLS is stored in a co-processor register which is read-only for
> userspace.

I should elaborate: the register is RW for AArch64 tasks, RO for aarch32
tasks (although that doesn't affect the need for the ptrace request).

Will
