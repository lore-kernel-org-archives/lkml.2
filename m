Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758360Ab2K0Iqu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 03:46:50 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:56868 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757350Ab2K0Iqt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 03:46:49 -0500
MIME-Version: 1.0
In-Reply-To: <20121127084007.GA7897@gmail.com>
References: <57384ebc52c7d39d1bae31ba3baa6f820b4ac696.1353610436.git.viresh.kumar@linaro.org>
	<7a48ae364663ab3a336251fada9aee07ccd728b8.1353610437.git.viresh.kumar@linaro.org>
	<20121123094132.EFCB73E07BE@localhost>
	<CAKohpomAM2pw9kgB6khtHzQ2WCXKZ9_pi1_sOH2dQToVS8ep4w@mail.gmail.com>
	<20121126184015.784993E091F@localhost>
	<CAKohpo=dHz-fJRdwovOWesAZJwibgrNk-+2t--JK+T_sBsu9Tw@mail.gmail.com>
	<CAKohpomOxfLhpZqpk3aymdNa7UAGRcex7d+N5srkFDnrhtULTw@mail.gmail.com>
	<20121127084007.GA7897@gmail.com>
Date: Tue, 27 Nov 2012 14:16:48 +0530
Message-ID: <CAKohpomPMYU5H_tx1BF7TD6F7a5rp5O=xDf3r-TGZ-r9SBp3yA@mail.gmail.com>
Subject: Re: [PATCH V3 3/3] mfd: stmpe: Update DT support in stmpe driver
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Lee Jones <lee.jones@linaro.org>, rabin.vincent@stericsson.com,
        Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>, sameo@linux.intel.com,
        devicetree-discuss@lists.ozlabs.org, spear-devel@list.st.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 November 2012 14:10, Lee Jones <lee.jones@linaro.org> wrote:
> On Tue, 27 Nov 2012, Viresh Kumar wrote:
>> Problem is with invert polarity, which the interrupt controller is not aware of.
>> For example, suppose interrupt controller needs Rising edge interrupt, but
>> the board has inverted the line between stmpe and IC. So, we will get
>> Rising high from the routine you mentioned, but we need to generate
>> opposite of that to make it rising high.
>
> Surely that would be a hardware design error/quirk?

Yes.

> Can you give an example where this has happened?

I haven't seen this in any of SPEAr boards i have worked on. Maybe Rabin
would have, that's why he added that part of code :)

@Rabin/Linus: Do you remember why have you added this in stmpe driver:

+       if (stmpe->pdata->irq_invert_polarity)
+               icr ^= STMPE_ICR_LSB_HIGH;
+

Does somebody actually need it?

--
viresh
