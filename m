Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753286Ab1CEM4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 07:56:46 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:44928 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752633Ab1CEM4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 07:56:45 -0500
Date: Sat, 5 Mar 2011 13:56:37 +0100
From: Borislav Petkov <bp@amd64.org>
To: Johan Wessfeldt <johan.wessfeldt@gmail.com>
Cc: Borislav Petkov <bp@amd64.org>,
        "J.P. Lacerda" <jp.lacerda@codethink.co.uk>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/1] x86: Fix mcheck_init_device() to handle
 misc_register() correctly
Message-ID: <20110305125637.GB27180@aftab>
References: <1299245367-20279-1-git-send-email-jp.lacerda@codethink.co.uk>
 <20110304171619.GB9311@gere.osrc.amd.com>
 <AANLkTim42BWV4EiM7M6m8CLQZMZ4j8LnBgA-+2Wz==9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim42BWV4EiM7M6m8CLQZMZ4j8LnBgA-+2Wz==9a@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 04:07:21PM -0500, Johan Wessfeldt wrote:
> On Fri, Mar 4, 2011 at 6:16 PM, Borislav Petkov <bp@amd64.org> wrote:

..

> > Anyway, while this is makes sense from correctness POV, if we hit an
> > error path here this early then something else is going terribly wrong
> > which would've screamed very loudly already. Are you hitting this on a
> > real workload or you caught this by code staring?
> The orginal patch was made with the intention of auditing the code
> according to the kernel-janitors TODO list:
> http://kernelnewbies.org/KernelJanitors/Todo/ReturnCodes .
> 
> To clear things up. I originally posted a minor patch, which basically passed
> the return value from misc_register up the stack. See
> http://marc.info/?l=linux-kernel&m=129889198732342&w=2

I see what you're doing and I think it is great that you're trying to
audit the code - this is actually very commendable but I'm questioning
whether such a "fix" makes sense in this case. As I said above, if we
hit those error paths, then we definitely botched up something else big
time and recovering here is pretty moot at this point. Therefore, adding
a bunch of code which is almost never executed is simply unneeded.

HTH.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
