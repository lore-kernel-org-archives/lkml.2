Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab1JJRxt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 13:53:49 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:52576 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752597Ab1JJRxr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 13:53:47 -0400
Date: Mon, 10 Oct 2011 19:53:36 +0200
From: Borislav Petkov <bp@amd64.org>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Borislav Petkov <bp@amd64.org>, Alan Stern <stern@rowland.harvard.edu>,
        "rjw@sisk.pl" <rjw@sisk.pl>, "pavel@ucw.cz" <pavel@ucw.cz>,
        "len.brown@intel.com" <len.brown@intel.com>,
        "tj@kernel.org" <tj@kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "a.p.zijlstra@chello.nl" <a.p.zijlstra@chello.nl>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "suresh.b.siddha@intel.com" <suresh.b.siddha@intel.com>,
        "lucas.demarchi@profusion.mobi" <lucas.demarchi@profusion.mobi>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "rdunlap@xenotime.net" <rdunlap@xenotime.net>,
        "vatsa@linux.vnet.ibm.com" <vatsa@linux.vnet.ibm.com>,
        "ashok.raj@intel.com" <ashok.raj@intel.com>,
        "tigran@aivazian.fsnet.co.uk" <tigran@aivazian.fsnet.co.uk>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH v2 0/3] Freezer, CPU hotplug, x86 Microcode: Fix task
 freezing failures
Message-ID: <20111010175336.GA29415@aftab>
References: <Pine.LNX.4.44L0.1110101119550.18069-100000@netrider.rowland.org>
 <4E931018.8030904@linux.vnet.ibm.com>
 <20111010165343.GA29261@aftab>
 <4E932BBA.9090501@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E932BBA.9090501@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 10, 2011 at 01:30:34PM -0400, Srivatsa S. Bhat wrote:
> But I do agree that offlining and onlining CPUs while suspending might
> not seem all that useful or even wise, but like I said, it was designed to
> bring out such problematic race conditions.
> 
> So, in the interest of making the important components involved in
> suspend/resume call path (namely cpu hotplug) more robust and stable,
> I think it makes sense to fix any issue we hit (atleast when we
> practically hit it and it is proved that such a scenario is no longer
> hypothetical).
> 
> For that, we can either go with the simple one-line fix that I posted
> earlier (which has got another motivation now, thanks to Borislav) or
> with this elaborate solution, whichever seems better/worthwhile.
>
> If it is still strongly felt that this "bug" is not worth fixing with such
> mutual exclusion schemes, it will still get solved anyway by applying that
> one-line patch.

Well, this is easy: the oneliner is needed anyway for removing
unnecessary ucode reloading and since it fixes your test cases _and_ is
_simpler_, the whole deal is a no brainer.

And although Pavel had a valid concern there about suspending when low
on battery/failing UPSs and, AFAIUI, it might happen that the machine
automatically suspends while you offline one of your cores, I can't find
it in me to care about a case like that, sorry.

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
