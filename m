Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756616Ab0EQWlm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 18:41:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54419 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906Ab0EQWlj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 18:41:39 -0400
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bluesmoke-devel@lists.sourceforge.net,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
       Brent Young <brent.young@intel.com>
Subject: Re: Hardware Error Kernel Mini-Summit
From: Andi Kleen <andi@firstfloor.org>
References: <4BF18995.6070008@redhat.com>
Date: Tue, 18 May 2010 00:41:34 +0200
In-Reply-To: <4BF18995.6070008@redhat.com> (Mauro Carvalho Chehab's message of "Mon\, 17 May 2010 15\:23\:17 -0300")
Message-ID: <87r5laxiap.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab <mchehab@redhat.com> writes:
>
> There is an immediate need for error reporting on NHM-EP class
> systems.

Just for the innocent readers who might be mislead by this:

Nehalem-EP DIMM error accounting already works fine today using
mcelog for most cases, including RHEL5.5 (with some limits) 
and RHEL6beta with no additional changes needed.

In RHEL6 the daemon does the accounting and the client reports the errors
separated for each DIMM and separated in uc and ce.  In RHEL5
the information is in a log file and can be gotten from there.

In addition the daemon supports various advanced RAS features including
predictive bad page offlining and various threshold triggers.

> In the specific case of Nehalem-EX, it seems that the low level driver
> won't be able to use direct access to the memory controller registers, 
> since the uncore now uses a register index/value pair to read or write 
> from the memory controller. The same pair is also used by BIOS to control 
> the hardware. With this design, race conditions between BIOS and the OS 
> may happen, So, even reading data from the Memory Controller registers 
> is not possible. So, it will need to use some logic to communicate via 
> BIOS, probably via ACPI 4.0 APEI.

Already done too, see
http://permalink.gmane.org/gmane.linux.acpi.devel/45743

However the interface won't give you the topology you're asking
for, just the errors.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
