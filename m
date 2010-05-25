Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab0EYACI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 20:02:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:43296 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932281Ab0EYACF convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 20:02:05 -0400
MIME-Version: 1.0
Message-ID: <bcb35f6d-e632-4fb6-bef0-8c55335ef537@default>
Date: Mon, 24 May 2010 17:01:06 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: john stultz <johnstul@us.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Brian Bloniarz <bmb@athenacr.com>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com>
 <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
 <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
 <1274727116.2954.5.camel@localhost.localdomain> <4BFADF9D.9050209@zytor.com>
 <1274733566.2954.73.camel@localhost.localdomain>
 <3ec7f284-1507-47fb-b5a2-eea29f68c627@default> <4BFAFE17.8060105@zytor.com>
 <1274741362.2954.80.camel@localhost.localdomain>
 <b4a3fe9e-8646-4fb9-93e0-6953be7a0aa9@default
 1274743836.2954.104.camel@localhost.localdomain>
In-Reply-To: <1274743836.2954.104.camel@localhost.localdomain>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BFB135E.002A:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Sorry, this is sort of mixing points
> Again, this is mixing the discussion.

Oops, sorry, missed that. :-}
 
> Maybe something like a tsc_long_calibration=1 option would allow for
> this?

Sounds good to me.  If it's non-obvious what value to choose for
the new calibration, maybe specifying it in MS (per MAX_QUICK_PIT_MS
in arch/x86/kernel/tsc.c) would be nice.

> However, I really do like the idea of pulling the stamped value from
> the MSR and if its close to what we quickly calibrated, use that.

On a quick sample of two machines looking at the TSC calibration
done by Xen (which exposes the equivalent of tsc_khz), it appears
that the stamped value is different from the calibration by about
1000ppm.  YMMV.
