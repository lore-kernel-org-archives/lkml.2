Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933285Ab2KBJoj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 05:44:39 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:33930 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760296Ab2KBJof convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 05:44:35 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: "Hunter, Jon" <jon-hunter@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: discrepancy while save and restore of debounce registers
Thread-Topic: discrepancy while save and restore of debounce registers
Thread-Index: Ac2sLoK1QcZgBYyrRUCfh4cWp+znkwAT3A2AABu2CfAADDRwAALwKROw
Date: Fri, 2 Nov 2012 09:44:26 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EABE28B@DBDE01.ent.ti.com>
References: <1BAFE6F6C881BF42822005164F1491C33EAA9A7C@DBDE01.ent.ti.com>
 <507F1F21.8040206@ti.com>
 <1BAFE6F6C881BF42822005164F1491C33EAAA89B@DBDE01.ent.ti.com>
 <50802B00.6090907@ti.com>
In-Reply-To: <50802B00.6090907@ti.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {3B7816B0-6DD0-47B1-96B5-08A521F5025C}
x-cr-hashedpuzzle: DT5D Dakv Ekbf GSZI JOjV JeYH NQdQ ZhRA akic dD6k hIJx
 qaJS tXBl wcED xy2l
 ydX2;5;ZwByAGEAbgB0AC4AbABpAGsAZQBsAHkAQABzAGUAYwByAGUAdABsAGEAYgAuAGMAYQA7AGwAaQBuAHUAeAAtAGEAcgBtAC0AawBlAHIAbgBlAGwAQABsAGkAcwB0AHMALgBpAG4AZgByAGEAZABlAGEAZAAuAG8AcgBnADsAbABpAG4AdQB4AC0AawBlAHIAbgBlAGwAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAG8AbQBhAHAAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AHQAbwBuAHkAQABhAHQAbwBtAGkAZABlAC4AYwBvAG0A;Sosha1_v1;7;{3B7816B0-6DD0-47B1-96B5-08A521F5025C};ZwB1AHIAdQByAGEAagBhAC4AaABlAGIAYgBhAHIAQAB0AGkALgBjAG8AbQA=;Fri,
 02 Nov 2012 09:44:05
 GMT;UgBFADoAIABkAGkAcwBjAHIAZQBwAGEAbgBjAHkAIAB3AGgAaQBsAGUAIABzAGEAdgBlACAAYQBuAGQAIAByAGUAcwB0AG8AcgBlACAAbwBmACAAZABlAGIAbwB1AG4AYwBlACAAcgBlAGcAaQBzAHQAZQByAHMA
x-originating-ip: [172.24.162.25]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 21:44:56, Hunter, Jon wrote:
> Hi Gururaja,
> 
> On 10/18/2012 12:31 AM, Hebbar, Gururaja wrote:
> > Jon,
> > 
> > On Thu, Oct 18, 2012 at 02:42:01, Hunter, Jon wrote:
> 
> [snip]
> 
> >>> My doubt/questions are
> >>> 1. Why should debounce registers be updated only when it's accessed previously?
> >>
> >> If debounce is not being used by any of the gpios, then there is no need
> >> to restore them as there are no bits set. So this makes sense and saves
> >> a couple register writes.
> > 
> > What I want to know is that other than saving register writes, is there any
> > other important stuff that specifies this requirement.
> 
> From a HW perspective, none that I can see.
> 
> From a SW perspective, yes, as I mentioned if you restore these
> registers without first initialising the context variables where these
> registers are stored, then you may be restoring unknown values to the
> registers and that is bad.
> 
> >>> 2. What is the relation between updating debounce registers and crash seen on
> >>> others registers? 
> >>
> >> This I am not sure about. I gave this a quick try on my omap3430 beagle
> >> board, but I did not see any side-effects from doing this. However, if
> >> you are always restoring the debounce context regardless of whether
> >> debounce is being used, then you could be writing bad values to the
> >> debounce registers as the context variables bank->context.debouce and
> >> bank->context.debouce_en may not initialised. So that is bad. However,
> >> that said I am still not sure how this could cause a crash.
> >>
> >> Can you share more details on ...
> > 
> > Sorry for missing below details in first post.
> > 
> >> 1. The OMAP platform you are using?
> > 
> > I was trying this on TI AM335x platform (repo below). On AM335x EVM board
> > 
> > http://arago-project.org/git/projects/?p=linux-am33x.git;a=shortlog;
> > h=refs/heads/v3.2-staging
> > 
> >> 2. What linux distro/environment you are using?
> > 
> > Arago AM335x PSP release (linux 3.2 + am335x patch-set)
> > 
> >> 3. If there are any specific steps to reproduce this 100% of the time?
> > 
> > On top of this tree, try suspend/resume using "echo mem > /syspower/state"
> 
> I have a beagle-bone but unfortunately, suspend does not appear to be
> supported in the mainline kernel yet so I am unable to test this on the
> am335x on the mainline.

You can try the suspend/resume on BB from Arago tree which I mentioned above

> 
> Have you compared the gpio driver from your v3.2 branch with the current
> mainline to see how different this code is? Ideally, it would be good to
> test on the mainline kernel for another data point to see if this is
> local to your branch.

The mainline kernel omap GPIO driver has changed a lot from current arago
tree (which is at v3.2). Upon comparing is when I found out about the
register access check done before restoring.

> 
> Cheers
> Jon
> 
> 
> 


Regards, 
Gururaja
