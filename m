Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750903Ab1ACXoh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 18:44:37 -0500
Received: from mga11.intel.com ([192.55.52.93]:61031 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750695Ab1ACXog (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 18:44:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,268,1291622400"; 
   d="scan'208";a="642997425"
Subject: Re: [patch] x86: avoid unnecessary smp alternatives switch during
 suspend/resume
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Pavel Machek <pavel@ucw.cz>
Cc: Borislav Petkov <bp@alien8.de>,
        Nigel Cunningham <lkml@nigelcunningham.com.au>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
In-Reply-To: <20110102091142.GA32469@atrey.karlin.mff.cuni.cz>
References: <1290211764.2637.8.camel@sbsiddha-MOBL3.sc.intel.com>
	 <4CE8E60D.9000303@nigelcunningham.com.au>
	 <20101121100328.GA2939@liondog.tnic>
	 <20110102091142.GA32469@atrey.karlin.mff.cuni.cz>
Content-Type: text/plain
Organization: Intel Corp
Date: Mon, 03 Jan 2011 15:44:13 -0800
Message-Id: <1294098253.2680.57.camel@sbsiddha-MOBL3.sc.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-02 at 01:11 -0800, Pavel Machek wrote:
> Hi!
> 
> > > We have a few others things that want to modify their behaviour
> > > according to whether we're doing the atomic copy/restore. Perhaps it
> > > would be an idea to just use a single flag, perhaps a value for
> > > system_state?
> > 
> > I agree, it would be nicer if we don't introduce a special flag
> > just for that. Other than that, I like all sane code that speeds up
> > suspend/resume :). I've attached before/after dmesg excerpts on my
> > system with the patch ontop of v2.6.37-rc2-181-gb86db47. We end up
> > saving 11601 ??secs according to CONFIG_PRINTK_TIME but hey, the code is
> > simple enough :).
> 
> 11msec is not worth the uglyness of global variable like this. Should
> we get a parameter, or something?

Pavel, Latest patch (that is now in -tip) moved the global variable to
the x86 code.

http://marc.info/?l=linux-kernel&m=129236179019935&w=2

thanks,
suresh

