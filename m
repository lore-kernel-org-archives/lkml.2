Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758909Ab2EIJBX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 05:01:23 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:40509 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758887Ab2EIJBS convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:7:1>);
	Wed, 9 May 2012 05:01:18 -0400
Message-Id: <4FAA49A402000078000826FF@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 
Date: Wed, 09 May 2012 09:40:36 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: <linux-kernel@vger.kernel.org>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <sarah.a.sharp@linux.intel.com>,
        <gregkh@linuxfoundation.org>, "Michal Marek" <mmarek@suse.cz>,
        <johnstul@us.ibm.com>, "Jesse Barnes" <jbarnes@virtuousgeek.org>,
        <hpa@zytor.com>
Subject: [PATCH 0/5, resend] move some .pci_fixup_* sections into .init
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

.pci_fixup_final is only used from .init.text, and hence can (along
with the respective handler functions) reside in .init.*.

Several other .pci_fixup_* sections are needed only during boot and
suspend/resume, and can therefore be moved into .init.* if
!CONFIG_PM.

While generally section mismatch checking is being turned on by the
last patch for all of .pci_fixup_*, for .pci_fixup_header it is being
suppressed for the moment as it caused way too much fallout.
Theoretically all respective handlers must get their __init/__devinit
removed, as this gets processed from a non-__init, non-__devinit
function.

The order in which the first four patches get applied doesn't matter,
as all patches in this series are fully independent. But of course
section mismatch warnings may result if the modpost change gets
applied ahead of any of the others.

Compared to the previous submission, the originally monolithic
patch was broken up, and things of course got adjusted as the
code touched here evolved.

1: PCI: adjust quirk handler section annotations
2: x86: adjust quirk handler section annotations
3: USB: adjust quirk handler section annotations
4: acpi_pm: adjust quirk handler section annotations
5: move some .pci_fixup_* sections into .init

Signed-off-by: Jan Beulich <jbeulich@novell.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: John Stultz <johnstul@us.ibm.com>
Cc: Michal Marek <mmarek@suse.cz>
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>


