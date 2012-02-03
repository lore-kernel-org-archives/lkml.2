Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756740Ab2BCOp1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 09:45:27 -0500
Received: from fanny.its.uu.se ([130.238.4.241]:55309 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756708Ab2BCOp0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 09:45:26 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <20267.62211.944159.412283@pilspetsen.it.uu.se>
Date: Fri, 3 Feb 2012 15:45:23 +0100
From: Mikael Pettersson <mikpe@it.uu.se>
To: Dave Martin <dave.martin@linaro.org>
Cc: Kautuk Consul <consul.kautuk@gmail.com>,
        linux-arm-kernel@lists.infradead.org,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        "Mohd. Faris" <mohdfarisq2010@gmail.com>
Subject: Re: [PATCH 1/1] arm: vfp: Raising SIGFPE on invalid floating point
 operation
In-Reply-To: <20120203132717.GB2098@linaro.org>
References: <1328258184-23082-1-git-send-email-consul.kautuk@gmail.com>
	<20120203132717.GB2098@linaro.org>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Martin writes:
 > On Fri, Feb 03, 2012 at 02:06:24PM +0530, Kautuk Consul wrote:
 > > There is a lot of ARM/VFP hardware which does not invoke the
 > > undefined instruction exception handler (i.e. __und_usr) at all
 > > even in case of an invalid floating point operation in usermode.
 > > For example, 100.0 divided by 0.0 will not lead to the undefined
 > > instruction exception being called by the processor although the
 > > hardware does reliably set the DZC bit in the FPSCR.
 > 
 > Which revision of the architecture are you referring to?
 > 
 > In VFPv2, I believe that exception trapping is architecturally required
 > to work: a CPU which doesn't trap when the corresponding exxception
 > enable bits in the FPSCR are set is a wrong implementation.
 > 
 > For VFPv3 and VFPv4 (on ARMv7+), there are two variants specified by the
 > architecture: "U" variants VFPv3U/VFPv4U where trapping must work (as in
 > VFPv2); and non-trapping variants VFPv3/VFPv4.
 > 
 > The non-trapping variants are common: Cortex-A8 and A9 for example have
 > non-trapping VFP implementations.
 > 
 > The architecture specified that writes to those FPSCR bits must be
 > ignored, and they must always read as 0, in non-trapping implementations.

If it's documented that non-trapping implementations are allowed,
and that they can be detected by the FPSCR bits being immutable zeros,
then there is no problem here for the kernel to deal with.  It's simply
a buggy application or buggy libc that fails to check if the FPU is
trapping or not.
