Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933095Ab0HEG1H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Aug 2010 02:27:07 -0400
Received: from eu1sys200aog115.obsmtp.com ([207.126.144.139]:37480 "EHLO
	eu1sys200aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756669Ab0HEG1E convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Aug 2010 02:27:04 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Greg KH <gregkh@suse.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
        Viresh KUMAR <viresh.kumar@st.com>
Date: Thu, 5 Aug 2010 08:26:00 +0200
Subject: RE: [PATCH] RFC: AMBA bus discardable probe() function
Thread-Topic: [PATCH] RFC: AMBA bus discardable probe() function
Thread-Index: Acs0DbnOaqRu2Xw2SNSlj19VspsJ5AAWOclg
Message-ID: <CEE6BB42CAD6E947908279175AF8470A0262E58F8B@EXDCVYMBSTM006.EQ1STM.local>
References: <1280925543-6862-1-git-send-email-linus.walleij@stericsson.com>
 <20100804194319.GA30722@suse.de>
In-Reply-To: <20100804194319.GA30722@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-hashedpuzzle: DBgZ Deun KNWm PzFq S7kV UdOi kDXc nX6b vlsd xhIr yQv5
 6El0 7Tvr 8TY/ AAaAVw==
 AAou4Q==;6;ZABiAHIAbwB3AG4AZQBsAGwAQAB1AHMAZQByAHMALgBzAG8AdQByAGMAZQBmAG8AcgBnAGUALgBuAGUAdAA7AGQAbQBpAHQAcgB5AC4AdABvAHIAbwBrAGgAbwB2AEAAZwBtAGEAaQBsAC4AYwBvAG0AOwBnAHIAZQBnAGsAaABAAHMAdQBzAGUALgBkAGUAOwBsAGkAbgB1AHgALQBlAG0AYgBlAGQAZABlAGQAQAB2AGcAZQByAC4AawBlAHIAbgBlAGwALgBvAHIAZwA7AGwAaQBuAHUAeAAtAGsAZQByAG4AZQBsAEAAdgBnAGUAcgAuAGsAZQByAG4AZQBsAC4AbwByAGcAOwBsAGkAbgB1AHgAQABhAHIAbQAuAGwAaQBuAHUAeAAuAG8AcgBnAC4AdQBrAA==;Sosha1_v1;7;{46F57FCA-30BC-429C-BC02-D08DA8BABF2D};bABpAG4AdQBzAC4AdwBhAGwAbABlAGkAagBAAHMAdABlAHIAaQBjAHMAcwBvAG4ALgBjAG8AbQA=;Thu,
 05 Aug 2010 06:26:00
 GMT;UgBFADoAIABbAFAAQQBUAEMASABdACAAUgBGAEMAOgAgAEEATQBCAEEAIABiAHUAcwAgAGQAaQBzAGMAYQByAGQAYQBiAGwAZQAgAHAAcgBvAGIAZQAoACkAIABmAHUAbgBjAHQAaQBvAG4A
x-cr-puzzleid: {46F57FCA-30BC-429C-BC02-D08DA8BABF2D}
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Greg]
> [Me]
> > +	spin_lock(&amba_bustype.p->klist_drivers.k_lock);
> 
> Ick, nope, you can't do this, sorry.  That's a "private" structure for
> a reason.

Yeah I get it, but in the platform bus case what's that traversal of 
the klists actually for? I didn't get it, and was guessing that it
was considering the case where devices spawn new devices.

> So what's the real driving force here, just saving a few hundred bytes
> after booting?  Or something else?

A few thousand actually according to Russells measurements.
And no I don't think it's worth it unless someone else challenge this...

Yours,
Linus Walleij
