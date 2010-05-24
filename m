Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758234Ab0EXSOQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 May 2010 14:14:16 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23394 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758039Ab0EXSOM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 May 2010 14:14:12 -0400
MIME-Version: 1.0
Message-ID: <ce764b91-11b0-44a5-9cf9-96977652bbd5@default>
Date: Mon, 24 May 2010 11:13:09 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: john stultz <johnstul@us.ibm.com>, Brian Bloniarz <bmb@athenacr.com>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Peter Zijlstra <peterz@infradead.org>, Andi Kleen <andi@firstfloor.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Venkatesh Pallipadi <venki@google.com>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org
Subject: RE: [PATCH] x86: Export tsc related information in sysfs
References: <4BF58B59.7080901@athenacr.com
 AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
In-Reply-To: <AANLkTinJ36UBMsVvTEoPnmAVS6np9Ja6heEtKA93r7tp@mail.gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090209.4BFAC1CF.01BA:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: john stultz [mailto:johnstul@us.ibm.com]
> 
> Yea, the relative instability of the tsc calibration at boot is an
> issue for folks who want very very precise timekeeping immediately
> after a reboot.
> 
> I proposed a solution to this awhile back via a boot option users
> could use to specify the tsc_khz freq, so it would be consistent from
> boot to boot. See: https://patchwork.kernel.org/patch/22492/
> 
> It didn't really go anywhere due to a lack of public interest.
> However, if you're interested in playing with it, I can try to revive
> the patch.

Another possibility: Optionally trust the stamped rate for the part?

I understand that on Nehalem this value is available in
MSR_PLATFORM_INFO[15:8] (google for MSR_PLATFORM_INFO 15 8),
but I don't know if this MSR is available on older (or AMD)
processors.

Just wondering:  If one were to put an ultra-precise scope on
a processor, how far off would the calibrated value be?  I'd
imagine the process of calibrating one unknown crystal against
a second crystal which has a known-but-not-highly-precise
frequency, though good enough for most purposes, is not particularly
accurate. In other words, maybe the stamped rate is more accurate
than the calibrated rate anyway?
