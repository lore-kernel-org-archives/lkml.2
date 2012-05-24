Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758171Ab2EXReM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 13:34:12 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43270 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752613Ab2EXReK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 13:34:10 -0400
Date: Thu, 24 May 2012 19:34:05 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Borislav Petkov <bp@amd64.org>, Chen Gong <gong.chen@linux.intel.com>,
        "Luck, Tony" <tony.luck@intel.com>, "x86@kernel.org" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: auto poll/interrupt mode switch for CMC to stop CMC
 storm
Message-ID: <20120524173405.GA6882@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Borislav Petkov <bp@amd64.org>,
	Chen Gong <gong.chen@linux.intel.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	"x86@kernel.org" <x86@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
References: <1337740341-26711-1-git-send-email-gong.chen@linux.intel.com>
 <alpine.LFD.2.02.1205230859190.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F2DD6@ORSMSX104.amr.corp.intel.com>
 <alpine.LFD.2.02.1205232044150.3231@ionos>
 <3908561D78D1C84285E8C5FCA982C28F192F30C0@ORSMSX104.amr.corp.intel.com>
 <4FBD9BAA.7070902@linux.intel.com>
 <20120524060016.GB25344@aftab.osrc.amd.com>
 <alpine.LFD.2.02.1205241146100.3231@ionos>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1205241146100.3231@ionos>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 24, 2012 at 12:01:13PM +0200, Thomas Gleixner wrote:
> Aside of that machine_check_poll is called from other places as
> well. So looking at mce_timer_start() which is surprisingly the timer
> callback:
> 
> The poll timer rate is self adjusting to intervals down to HZ/100. So
> when you get into a state where the timer rate becomes lower than HZ/5
> we'll trigger that CMCI storm in software and queue work even on
> machines which do not support CMCI or have it disabled. Brilliant,
> isn't it?
> 
> So that rate check belongs into intel_treshold_interrupt() and wants a
> intel specific callback in mce_start_timer() to undo it.

Ok, I see it now, it took me awhile with my slow brain. And the code is
not a walk in the park anyway, thanks Thomas for pointing this out.

-- 
Regards/Gruss,
    Boris.
