Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753611Ab0FSFuq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 01:50:46 -0400
Received: from smtp.outflux.net ([198.145.64.163]:33928 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148Ab0FSFup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 01:50:45 -0400
Date: Fri, 18 Jun 2010 22:50:10 -0700
From: Kees Cook <kees.cook@canonical.com>
To: x86@kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Alexander Potashev <aspotashev@gmail.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/4] x86: clear XD_DISABLED flag on Intel to regain NX
Message-ID: <20100619055010.GR24749@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX cannot
be inappropriately controlled by the BIOS on Intel CPUs.  If NX actually
needs to be disabled, "noexec=off" can be used.

Based on feedback from HPA, this was reworked to extend the existing
"verify_cpu" routines, and to more tightly confine which CPUs will call
MSR_IA32_MISC_ENABLE.  Since it includes some re-arrangements of files, I
tried to break the patches up into their logical steps.

-Kees

-- 
Kees Cook
Ubuntu Security Team
