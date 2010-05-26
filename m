Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754180Ab0EZMbZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 08:31:25 -0400
Received: from www.tglx.de ([62.245.132.106]:39657 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751740Ab0EZMbY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 08:31:24 -0400
Date: Wed, 26 May 2010 14:30:45 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Brian Bloniarz <bmb@athenacr.com>
cc: "H. Peter Anvin" <hpa@zytor.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       john stultz <johnstul@us.ibm.com>, Ingo Molnar <mingo@elte.hu>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
In-Reply-To: <4BFC687A.9040304@athenacr.com>
Message-ID: <alpine.LFD.2.00.1005261428030.2995@localhost.localdomain>
References: <4BF58B59.7080901@athenacr.com> <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com> <ce764b91-11b0-44a5-9cf9-96977652bbd5@default> <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain>
 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com> <4BFB2902.50308@athenacr.com> <4BFC687A.9040304@athenacr.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 May 2010, Brian Bloniarz wrote:

> On 05/24/2010 09:33 PM, Brian Bloniarz wrote:
> > So what's wrong with just adding a
> > /sys/devices/system/clocksource/clocksource0/tsc_khz?

It's wrong because TSC is an x86'ism.
 
> As an RFC:
> 
> Add clocksource.sys_register & sys_unregister so the
> current clocksource can add supplemental information to
> /sys/devices/system/clocksource/clocksource0/
> 
> Export tsc_khz when current_clocksource==tsc so that
> daemons like NTP can account for the variability of
> calibration results.

I'd rather see a generic solution which provides the information of
the current (and possibly those of the available) clock source(s). 

This x86 centric TSC world view is horrible.

Thanks,

	tglx
