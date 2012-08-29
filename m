Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab2H2KNT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 06:13:19 -0400
Received: from mail.x86-64.org ([217.9.48.20]:39694 "EHLO mail.x86-64.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751751Ab2H2KNR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 06:13:17 -0400
Date: Wed, 29 Aug 2012 12:13:02 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
Cc: tony.luck@intel.com, andi@firstfloor.org, ananth@in.ibm.com,
        x86@kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        hpa@zytor.com, tglx@linutronix.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH RFC] x86/mce: Move MCE sysfs attributes out of the
 per-cpu location
Message-ID: <20120829101302.GA26977@aftab.osrc.amd.com>
References: <20120829074154.6755.98941.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120829074154.6755.98941.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 29, 2012 at 01:11:55PM +0530, Naveen N. Rao wrote:
> All the MCE attributes currently exported via sysfs appear under
> /sys/devices/system/machinecheck/machinecheck<n>/. Pretty much all of these
> are global in nature and not specific to a processor. We have around 7
> attributes duplicated across each processor and on multi-core multi-socket
> machines, this amounts to quite a large number. So, move these out under
> /sys/devices/system/machinecheck/ where they rightly belong.
> 
> Note: I'm not sure if it's ok to change sysfs entries and this does break
> userspace tools that depend on the current path for some of these attributes.
> So, they will need to be updated to use the new path. However, if we ever get
> to a point where cpu0 can be offlined, these tools will need to be updated
> anyway (as they mostly hardcode machinecheck0 currently)

How do you know that for all tools out there?

I know, I know, moving them to /sys/.../machinecheck/ is the right thing
to do but they're exposed to userspace and we're breaking it with this
patch. And we don't break userspace so I'd guess we're stuck with the
current situation.

Sorry.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
