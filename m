Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751320Ab2EFFyi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 01:54:38 -0400
Received: from mga03.intel.com ([143.182.124.21]:14557 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751042Ab2EFFyh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 01:54:37 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139400075"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Subject: RE: [PATCH] smb347_charger: cleaned battery power supply attributes
Thread-Topic: [PATCH] smb347_charger: cleaned battery power supply attributes
Thread-Index: AQHNKzgojlCWEqRdiE+k9tu4wx9FAJa8Oabg
Date: Sun, 6 May 2012 05:54:31 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD140252@BGSMSX102.gar.corp.intel.com>
References: <1336233834-21550-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120506032554.GG29576@lizard>
In-Reply-To: <20120506032554.GG29576@lizard>
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
X-MIME-Autoconverted: from base64 to 8bit by nfs id q465sunY012589

Hi Anton,

> On Sat, May 05, 2012 at 09:33:54PM +0530, Ramakrishna Pallala wrote:
> > CURRENT_NOW and VOLTAGE_NOW should be instantaneous readings from
> > power supply(ex: battery).
> >
> > smb347 charger driver reports charge voltage for VOLTAGE_NOW and
> > charge current for CURRENT_NOW attributes which are not instantaneous
> > readings.
> 
> Em. While charging, I guess charge current == instantaneous battery current? Should we
> then report it in such cases? And while discharging and not charging, assuming that HW
> can't report the real battery current flow, we can return some fancy errno code, like
> ENODATA?

Battery current depends on the following things during charging:
1. is the battery in constant current(CC) charge mode or in constant voltage(CV) charge mode?
during CC mode battery current will be close to charge current(with no load) but it will get
reduced gradually as the battery charging approaches CV mode. same for battery voltage.
in CC mode battery voltage will be less than charge voltage and as we approach CV mode 
battery voltage be close to charge voltage setting.

2. instantaneous battery current & voltage also depends on the load current.

we should read battery current & voltage from either PMIC/ADC channels or from fuel gauge chip.

Thanks,
Ram
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
