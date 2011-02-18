Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756348Ab1BRIO5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 03:14:57 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:42914 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756241Ab1BRIOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 03:14:55 -0500
Message-ID: <184FA07B783D4F5FAAC09D5C11737A3F@subhasishg>
From: "Subhasish Ghosh" <subhasish@mistralsolutions.com>
To: "Wolfgang Grandegger" <wg@grandegger.com>
Cc: "Kurt Van Dijck" <kurt.van.dijck@eia.be>, <sachi@mistralsolutions.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        "open list:CAN NETWORK DRIVERS" <netdev@vger.kernel.org>,
        <nsekhar@ti.com>, "open list" <linux-kernel@vger.kernel.org>,
        "open list:CAN NETWORK DRIVERS" <socketcan-core@lists.berlios.de>,
        <linux-arm-kernel@lists.infradead.org>, <m-watkins@ti.com>
References: <1297435892-28278-1-git-send-email-subhasish@mistralsolutions.com>	<1297435892-28278-10-git-send-email-subhasish@mistralsolutions.com>	<20110211152026.GC373@e-circ.dyndns.org> <32A5399EB727427C98185089E5DBFA65@subhasishg> <4D5E2570.10108@grandegger.com>
In-Reply-To: <4D5E2570.10108@grandegger.com>
Subject: Re: [PATCH v2 09/13] can: pruss CAN driver.
Date: Fri, 18 Feb 2011 13:45:57 +0530
Organization: Mistral Solutions
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
Importance: Normal
X-Mailer: Microsoft Windows Live Mail 14.0.8117.416
X-MimeOLE: Produced By Microsoft MimeOLE V14.0.8117.416
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On 02/18/2011 08:07 AM, Subhasish Ghosh wrote:
>> --------------------------------------------------
>> From: "Kurt Van Dijck" <kurt.van.dijck@eia.be>
>
> ...
>>>> + /* register interrupt handler */
>>>> + err = request_irq(priv->trx_irq, &omapl_rx_can_intr, IRQF_SHARED,
>>>> +   "pru_can_irq", ndev);
>>> you're doing a lot of work _in_ the irq handler. Maybe threaded irq?
>>>
>> SG -Ok, will do
>
> No, please use NAPI instead.

We are using h/w filters, so the number of interrupts coming into the 
processor are not hogging it.
I feel that we may not require an interrupt mitigation.

-Subhasish 

