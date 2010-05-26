Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413Ab0EZAsR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 20:48:17 -0400
Received: from e9.ny.us.ibm.com ([32.97.182.139]:59947 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab0EZAsP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 20:48:15 -0400
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: john stultz <johnstul@us.ibm.com>
To: Brian Bloniarz <bmb@athenacr.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <4BFC687A.9040304@athenacr.com>
References: <4BF58B59.7080901@athenacr.com>
	 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
	 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
	 <1274727116.2954.5.camel@localhost.localdomain>
	 <4BFADF9D.9050209@zytor.com 1274733566.2954.73.camel@localhost.localdomain>
	 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>
	 <4BFB2902.50308@athenacr.com>  <4BFC687A.9040304@athenacr.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 17:48:08 -0700
Message-ID: <1274834888.4678.66.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-25 at 20:16 -0400, Brian Bloniarz wrote:
> On 05/24/2010 09:33 PM, Brian Bloniarz wrote:
> > So what's wrong with just adding a
> > /sys/devices/system/clocksource/clocksource0/tsc_khz?
> 
> As an RFC:
> 
> Add clocksource.sys_register & sys_unregister so the
> current clocksource can add supplemental information to
> /sys/devices/system/clocksource/clocksource0/
> 
> Export tsc_khz when current_clocksource==tsc so that
> daemons like NTP can account for the variability of
> calibration results.

I think this is a bad idea, as it creates an ABI that is arch AND
machine specific, which will cause portability problems in applications
that expect the interface to be there.

thanks
-john


