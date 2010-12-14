Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932420Ab0LNWvg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 17:51:36 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42236 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760167Ab0LNWvf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 17:51:35 -0500
Date: Tue, 14 Dec 2010 22:51:26 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonathan =?iso-8859-1?Q?Neusch=E4fer?= <j.neuschaefer@gmx.net>
Cc: linux-kernel@vger.kernel.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will.deacon@arm.com>,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Tony Lindgren <tony@atomide.com>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arch/arm/kernel: use cpu_relax() in halt loops
Message-ID: <20101214225126.GD24303@n2100.arm.linux.org.uk>
References: <20101214224848.GA1706@debian.debian>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20101214224848.GA1706@debian.debian>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 11:48:48PM +0100, Jonathan Neuschäfer wrote:
> Looking throught arch/arm/kernel/ I found some halt loops.
> I just thought we could save some power here using cpu_relax(),
> or am I missing something?

#if __LINUX_ARM_ARCH__ == 6
#define cpu_relax()                     smp_mb()
#else
#define cpu_relax()                     barrier()
#endif

IOW, it's either a memory barrier or compiler barrier on ARM; it
doesn't do any power saving.
