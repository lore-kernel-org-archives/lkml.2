Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756752Ab1EXRdb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 13:33:31 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:59935 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752082Ab1EXRda (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 13:33:30 -0400
Date: Tue, 24 May 2011 19:33:26 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: Ingo Molnar <mingo@elte.hu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Huang, Ying" <ying.huang@intel.com>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [RFC 0/9] mce recovery for Sandy Bridge server
Message-ID: <20110524173326.GA7635@gere.osrc.amd.com>
References: <4ddad79317108eb33d@agluck-desktop.sc.intel.com>
 <20110524034023.GB25230@elte.hu>
 <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <987664A83D2D224EAE907B061CE93D5301D5D0595B@orsmsx505.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 24, 2011 at 09:57:46AM -0700, Luck, Tony wrote:
> So can we talk about this part for a while before returning to the
> "how to report this" discussion?
> 
> So here's the situation - we are in the NMI handler when we find from
> looking at the machine check bank registers that we have a recoverable
> error. We know the physical address, and we know the task (which might
> have been in user or kernel context). I can package that information
> into a perf/event ... but then how can I mark the current task as
> not-fit-for-execution?

Maybe something like

set_current_state(TASK_UNINTERRUPTIBLE);

finish work in NMI context

do remaining work in process context like sending appropriate signals
etc; finally:

set_task_state(tsk, TASK_RUNNING)

?

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
