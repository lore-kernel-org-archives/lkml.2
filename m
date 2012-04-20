Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932601Ab2DTDsl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 23:48:41 -0400
Received: from mga14.intel.com ([143.182.124.37]:55676 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932268Ab2DTDsk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 23:48:40 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="133194628"
From: "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
To: Mika Westerberg <mika.westerberg@iki.fi>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Anton Vorontsov <anton.vorontsov@linaro.org>
Subject: RE: [PATCH v2] smb347_charger: Cleanup power supply registration
 code in probe
Thread-Topic: [PATCH v2] smb347_charger: Cleanup power supply registration
 code in probe
Thread-Index: AQHNHl/WbV8uvtA/zUm/xFF6SyZHTZajEUtw
Date: Fri, 20 Apr 2012 03:48:35 +0000
Message-ID: <D854C92F57B1B347B57E531E78D05EAD10EC08@BGSMSX102.gar.corp.intel.com>
References: <1334809818-5958-1-git-send-email-ramakrishna.pallala@intel.com>
 <20120419190820.GB877@mwesterb-mobl.lan>
In-Reply-To: <20120419190820.GB877@mwesterb-mobl.lan>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Subject: Re: [PATCH v2] smb347_charger: Cleanup power supply registration code in probe
> 
> On Thu, Apr 19, 2012 at 10:00:18AM +0530, Ramakrishna Pallala wrote:
> > This patch checks if the usb or mains charging is enabled by the
> > platform before registering with the power supply class.
> 
> I still don't like the idea of having the power-supplies registered conditionally. Now
> you need to check in every place whether the corresponding power-supply is registered or
> not which makes the code uglier and more prone to errors.

These are the reasons behind this patch submission:
1. if we don't support USB/AC charging don't enable it, saves
	kernel resources and don't give user wrong idea about charging capabilities.
2. if a platform driver or any other chip can do USB/AC charging they will register with PS and
	user/userspace will not get confused b/w two sysfs interfaces.

I will leave the decision the Anton.

Thanks,
Ram
