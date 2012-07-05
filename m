Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757284Ab2GETS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 15:18:57 -0400
Received: from na3sys009aog118.obsmtp.com ([74.125.149.244]:33401 "EHLO
	na3sys009aog118.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757213Ab2GETSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 15:18:55 -0400
MIME-Version: 1.0
In-Reply-To: <4FF4E679.10909@nvidia.com>
References: <1341313938-17861-1-git-send-email-rnayak@ti.com> <4FF4E679.10909@nvidia.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Thu, 5 Jul 2012 12:18:30 -0700
Message-ID: <CAJOA=zMZwOBq7TKoigiGqDHh9kXAxsy-uH5koSOtH+r7p1=SJw@mail.gmail.com>
Subject: Re: [PATCH] clk: fix parent validation in __clk_set_parent()
To: Prashant Gaikwad <pgaikwad@nvidia.com>
Cc: Rajendra Nayak <rnayak@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>, swarren@nvidia.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 5:57 PM, Prashant Gaikwad <pgaikwad@nvidia.com> wrote:
> On Tuesday 03 July 2012 04:42 PM, Rajendra Nayak wrote:
>>
>> The below commit introduced a bug in __clk_set_parent()
>> which could cause it to *skip* the parent validation
>> which makes sure the parent passed to the api is a valid
>> one.
>
>
> Need this fix for Tegra too.
>

Hi Prashant,

You'll find it if you pull the latest clk-next.

Regards,
Mike

>
>>      commit 7975059db572eb47f0fb272a62afeae272a4b209
>>      Author: Rajendra Nayak<rnayak@ti.com>
>>      Date:   Wed Jun 6 14:41:31 2012 +0530
>>
>>          clk: Allow late cache allocation for clk->parents
>>
>> This was identified by the following compiler warning..
>>
>>      drivers/clk/clk.c: In function '__clk_set_parent':
>>      drivers/clk/clk.c:1083:5: warning: 'i' may be used uninitialized in
>> this function [-Wuninitialized]
>>
>> .. as reported by Marc Kleine-Budde.
>>
>> There were various options discussed on how to fix this, one
>> being initing 'i' to clk->num_parents, but the below approach
>> was found to be more appropriate as it also makes the 'parent
>> validation' code simpler to read.
>>
>> Reported-by: Marc Kleine-Budde<mkl@pengutronix.de>
>> Signed-off-by: Rajendra Nayak<rnayak@ti.com>
>>
>
