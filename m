Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752210Ab2DXFIY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 01:08:24 -0400
Received: from portal.weinmann.de ([62.8.140.122]:33273 "EHLO
	portal.weinmann.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab2DXFIP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 01:08:15 -0400
X-Greylist: delayed 995 seconds by postgrey-1.27 at vger.kernel.org; Tue, 24 Apr 2012 01:08:15 EDT
From: "Voss, Nikolaus" <N.Voss@weinmann.de>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
CC: "'linux-arm-kernel@lists.infradead.org'" 
	<linux-arm-kernel@lists.infradead.org>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'rtc-linux@googlegroups.com'" <rtc-linux@googlegroups.com>,
        "'a.zummo@towertech.it'" <a.zummo@towertech.it>,
        "'grant.likely@secretlab.ca'" <grant.likely@secretlab.ca>
Date: Tue, 24 Apr 2012 06:51:03 +0200
Subject: RE: [PATCH] drivers/rtc/rtc-m41t93.c: don't let get_time() reset
 error state
Thread-Topic: [PATCH] drivers/rtc/rtc-m41t93.c: don't let get_time() reset
 error state
Thread-Index: Ac0hkyY4NeY7YIfPRkekxVRvNaP6/AAPyylg
Message-ID: <EF2E73589CA71846A15D0B2CDF79505D0905DB4A4A@wm021.weinmann.com>
References: <201204231230.q3NCUbbP015327@gatekeeper.vosshq.de>
 <20120423135322.5b9b1635.akpm@linux-foundation.org>
In-Reply-To: <20120423135322.5b9b1635.akpm@linux-foundation.org>
Accept-Language: en-US, de-DE
Content-Language: de-DE
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US, de-DE
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote on 2012-04-23:
> On Mon, 23 Apr 2012 12:51:23 +0200
> Nikolaus Voss <n.voss@weinmann.de> wrote:
> 
>> If the rtc reports the time might be invalid due to oscillator
>> failure, this flags must not be reset by get_time() as the read
>> operation doesn't make the time valid.
>> 
>> Instead, the flag is reset in set_time() when a valid time is
>> to be written.
> 
> This is rather vague - what is/are "these flags"?

Sorry, that's true. I speak of the M41T93_FLAG_OF
(Oscillator Fail) flag.

[...]
> Secondly, you provided no description of the user-visible effects of
> the bug.  Hence I cannot work out which kernel version(s) this patch
> should be merged into.

What the user sees is that the first get_time() read reports
an error (invalid time) and the second reports no error, so the
first read magically heals the rtc time.

The patch applies to all kernel versions with support for m41t93 rtc.

I'll repost the patch with a proper description.

Niko


