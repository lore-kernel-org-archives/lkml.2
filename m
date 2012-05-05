Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753102Ab2EEG4J (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 02:56:09 -0400
Received: from mga14.intel.com ([143.182.124.37]:35291 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752872Ab2EEG4I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 02:56:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139177371"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] max17042_battery: Fix power supply and irq registration
 ordering
Thread-Topic: [PATCH] max17042_battery: Fix power supply and irq
 registration ordering
Thread-Index: AQHNKotRLreAhtSeS0CI8npN/gFIZZa6wtTw
Date: Sat, 5 May 2012 06:56:04 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD13FFBE@BGSMSX102.gar.corp.intel.com>
References: <1336167517-29092-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120505064846.GA4227@lizard>
In-Reply-To: <20120505064846.GA4227@lizard>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q456uIVB008419

> On Sat, May 05, 2012 at 03:08:37AM +0530, Ramakrishna Pallala wrote:
> > IRQ registration should happen only after power supply object usable.
> > This patch fixes the ordering of power supply and irq registration
> > calls.
> >
> > Signed-off-by: Ramakrishna Pallala <ramakrishna.pallala@intel.com>
> > ---
> 
> Applied, thank you!
> 
> And I noticed another small issue: if request_threaded_irq() fails, we continue with
> probing (which is OK), but since request failed, during max17042_remove() and
> suspend/resume we would call IRQ routines on a non-requested IRQ.
> 
> So, probably you'd want to set client->irq = 0 when request_irq fails.
> 

right, I should have checked this :(
I will submit the fix.

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
