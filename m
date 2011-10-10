Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752607Ab1JJVNM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 17:13:12 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:41477 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875Ab1JJVNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 17:13:10 -0400
Date: Mon, 10 Oct 2011 23:13:00 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Borislav Petkov <bp@amd64.org>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "amd64-microcode@amd64.org" <amd64-microcode@amd64.org>,
        Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] CPU hotplug,x86 Microcode: Don't request
 microcode from userspace unnecessarily
Message-ID: <20111010211300.GA31606@aftab>
References: <4E90B6F9.8020804@linux.vnet.ibm.com>
 <4E91F82E.4080007@linux.vnet.ibm.com>
 <4E91F908.5010006@linux.vnet.ibm.com>
 <201110102258.02628.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110102258.02628.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 04:58:02PM -0400, Rafael J. Wysocki wrote:
> On Sunday, October 09, 2011, Srivatsa S. Bhat wrote:
> > Requesting the microcode from userspace *every time* when onlining CPUs
> > (during a CPU hotplug operation) is unnecessary.
> > 
> > So, this patch ensures that once the kernel gets the microcode after booting,
> > it is not freed nor invalidated when a CPU goes offline, so that it can be
> > reused when that CPU comes back online, without requesting userspace for it
> > again. As a result, the CPU hotplug operations become faster as well.
> > 
> > Tested-by: Borislav Petkov <bp@amd64.org>
> > Acked-by: Borislav Petkov <bp@amd64.org>
> > 
> > Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
> 
> Fine by me.  I wonder who should take this?

Ingo, most probably. ucode stuff goes in through -tip.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
