Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932627Ab1KISHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 13:07:06 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:43374 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756051Ab1KISHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 13:07:04 -0500
From: "Chalhoub, Nicole" <n-chalhoub@ti.com>
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        "Hilman, Kevin" <khilman@ti.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Subject: RE: [PATCH] CPUIdle: Reevaluate C-states under CPU load to favor
 deeper C-states
Thread-Topic: [PATCH] CPUIdle: Reevaluate C-states under CPU load to favor
 deeper C-states
Thread-Index: AcybOzS2cRPCfXh/TbGadXrUO2MJgQDjPnsAABArA8A=
Date: Wed, 9 Nov 2011 18:06:41 +0000
Message-ID: <37CAE120BAE10B42A790DD1418C8021D0136C7@DNCE02.ent.ti.com>
References: <1316475315-5905-1-git-send-email-khilman@ti.com>
 <87d3d75zo6.fsf@ti.com> <4EBA6046.2060305@linux.vnet.ibm.com>
In-Reply-To: <4EBA6046.2060305@linux.vnet.ibm.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.167.100.201]
x-exclaimer-md-config: f9c360f5-3d1e-4c3c-8703-f45bf52eff6b
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Deepthi,

>
Texas Instruments France SA, 821 Avenue Jack Kilby, 06270 Villeneuve Loubet. 036 420 040 R.C.S Antibes. Capital de EUR 753.920

-----Original Message-----
> From: Deepthi Dharwar [mailto:deepthi@linux.vnet.ibm.com]
> Sent: Wednesday, November 09, 2011 12:13 PM
> To: Hilman, Kevin
> Cc: linux-kernel@vger.kernel.org; Arjan van de Ven; linux-arm-
> kernel@lists.infradead.org; linux-omap@vger.kernel.org; linux-
> pm@lists.linux-foundation.org; Chalhoub, Nicole
> Subject: Re: [PATCH] CPUIdle: Reevaluate C-states under CPU load to favor
> deeper C-states

[...]
> By setting timers when we enter non-deepest C-state possible, such that
> when it fires we
> can re-evaluate and try moving into deeper and deeper C-states enhancing
> the
> power savings is a good feature to have.
>
> Looking at the current implementation, is it possible to have it as
> configurable option
> where one can enable/disable this functionality through the backhand
> driver ?

The timeout values of the c state timers are set in the backhand driver.
By setting the timeout to 0 the timers will not fire so you'll not have this functionality enabled

> Also I am thinking, instead of having them in governor
> wouldnt it be a good idea to have it implemented in
> the backhand driver itself ?
> --Deepthi


In fact each C-state had its own configurable timer, so it is a parameter characterizing a C-state as it is for the exit_latency and target_residency parameters.
And we wanted the timer to fire only when we do not go in deep Cstate due to a high load. This decision is made in the CPU idle governor. So the functionality should be seen from the governor..

Thanks and Regards
Nicole


