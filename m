Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758194Ab0IGTnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 15:43:00 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:41284 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757476Ab0IGTm5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 15:42:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Wc+dc8m2zS8QPC1hcjPaf1lguAqZLPmQA2hbt+QiwH1mpLvykL0+Tj0U2JK8wIg4q7
         q0MM4OXpAp8XVf8lxBEY4m9GFMF+24UMvJlWoHz0YYgZatd13rZM28J1B5ZtpJFpuR1T
         JntHyilx2rjNaubxT6gR8sNPbtB0iG+sqjZP0=
MIME-Version: 1.0
In-Reply-To: <1283772201-15453-1-git-send-email-nicolas.ferre@atmel.com>
References: <201009060548.18521.fg@emlix.com>
	<1283772201-15453-1-git-send-email-nicolas.ferre@atmel.com>
Date: Tue, 7 Sep 2010 21:42:56 +0200
Message-ID: <AANLkTin+vCsG3FUvX6DTUfFe7ZJpbkYyqw_TLvH9ujrJ@mail.gmail.com>
Subject: Re: [PATCH] AT91: SAM9G45 - add a separate clock entry for every
 single TC block
From: "avictor.za@gmail.com" <avictor.za@gmail.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Fabian Godehardt <fg@emlix.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi,

> +/* One additional fake clock for second TC block */
> +static struct clk tcb1_clk = {
> +       .name           = "tcb1_clk",
> +       .pmc_mask       = 0,
> +       .type           = CLK_TYPE_PERIPHERAL,
> +       .parent         = &tcb0_clk,
> +};
> +

Looking at this again...  since type is CLK_TYPE_PERIPHERAL, when you
call clk_register() the "parent" is changed to the master clock.

Which means, then later you call clk_enable() the "pmc_mask" is still
0, so 0 gets written (in pmc_periph_mode) to AT91_PMC_PCER.  So the
TCB clock won't be enabled.

Or am I missing something?


Regards,
  Andrew Victor
