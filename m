Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754471Ab0KISMl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 13:12:41 -0500
Received: from smtp.outflux.net ([198.145.64.163]:37428 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0KISMl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 13:12:41 -0500
Date: Tue, 9 Nov 2010 10:11:57 -0800
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [Security] [PATCH v3 0/4] x86: clear XD_DISABLED flag on Intel to
 regain NX
Message-ID: <20101109181157.GE5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is a re-send of an earlier patch series that got side-tracked. I'd
like to get this into the kernel in some form, so I'd like to try
submission again, as I think it is important.

Intel CPUs have an additional MSR bit to indicate if the BIOS was
configured to disable NX. This bit was traditionally used for operating
systems that did not understand how to handle the NX bit. Since Linux
understands this, this BIOS flag should be ignored by default.

In a review[1] of reported hardware being used by Ubuntu bug reporters,
almost 10% of systems had an incorrectly configured BIOS, leaving their
systems unable to use the NX features of their CPU.

This change will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX
cannot be inappropriately controlled by the BIOS on Intel CPUs.  If, under
very strange hardware configurations, NX actually needs to be disabled,
"noexec=off" can be used to restore the prior behavior.

Based on feedback from HPA, this was reworked to extend the existing
"verify_cpu" routines, and to more tightly confine which CPUs will call
MSR_IA32_MISC_ENABLE. Since it includes some re-arrangements of files, I
tried to break the patches up into their logical steps.

-Kees

[1] http://www.outflux.net/blog/archives/2010/02/18/data-mining-for-nx-bit/

-- 
Kees Cook
Ubuntu Security Team
