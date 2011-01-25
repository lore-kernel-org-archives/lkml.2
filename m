Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872Ab1AYLPD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:15:03 -0500
Received: from mga02.intel.com ([134.134.136.20]:15749 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751025Ab1AYLPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:15:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,373,1291622400"; 
   d="scan'208";a="596220729"
From: "R, Durgadoss" <durgadoss.r@intel.com>
To: Thomas Renninger <trenn@suse.de>, "Zhang, Rui" <rui.zhang@intel.com>
CC: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        "jdelvare@novell.com" <jdelvare@novell.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "linux-perf-users@vger.kernel.org" <linux-perf-users@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-trace-users@vger.kernel.org" 
	<linux-trace-users@vger.kernel.org>
Date: Tue, 25 Jan 2011 16:44:54 +0530
Subject: RE: Thermal kernel events API to userspace - Was: Re: thermal:
 Avoid CONFIG_NET compile dependency
Thread-Topic: Thermal kernel events API to userspace - Was: Re: thermal:
 Avoid CONFIG_NET compile dependency
Thread-Index: Acu8eGQFj4y2A8NuRymCFXIKUSEtewAAhr+AAAGLGkA=
Message-ID: <D6D887BA8C9DFF48B5233887EF046541094488C0CB@bgsmsx502.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p0PBF9qt004719

Hi Thomas,

> 
> I wonder which events would need userspace to take specific
> (configured) actions at all and what kind of action it could be.
> 
> What is THERMAL_USER_AUX0?
> When will it get thrown and what is userspace expected to do?
> 

This THERMAL_USER_AUX0 is meant for the DTS core thresholds.
In ACPI compliant systems, There are two core thresholds, that
Can be programmed and read via IA32_THERM_INTERRUPT MSR. One is the
Lower threshold (AUX0) and the other one is the higher threshold(AUX1).

When the Current temperature goes below the lower threshold, or above
the higher threshold, the HW generates an interrupt. This is what is
forwarded to the user space through the netlink events.

The user app can increase performance(increase CPU speed..)
on receiving AUX0 events, and try to reduce performance
(like CPU frequency reduction, display control..)on getting AUX1 events.
Basically, the app can do anything to reduce the temperature of the
Platform.

Thanks,
Durga
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
