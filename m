Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754164Ab0KIWRM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 17:17:12 -0500
Received: from smtp.outflux.net ([198.145.64.163]:57252 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751931Ab0KIWRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 17:17:07 -0500
Date: Tue, 9 Nov 2010 14:17:04 -0800
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org, linux-kernel@vger.kernel.org
Subject: [Security] [PATCH v4 0/4] x86: clear XD_DISABLED flag on Intel to
 regain NX
Message-ID: <20101109221704.GX5876@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Resending with updates to commit messages and Pekka Enberg's Acks.

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

-Kees

[1] http://www.outflux.net/blog/archives/2010/02/18/data-mining-for-nx-bit/

---
Changelog:
v2 - rearranged use of verify_cpu()
v3 - resent, show stats on systems that need it
v4 - expanded commit messages, added acks

-- 
Kees Cook
Ubuntu Security Team
