Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751118Ab2KLJnZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 04:43:25 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:61843 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750736Ab2KLJnY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 04:43:24 -0500
Message-ID: <50A0C4B8.3000605@gmail.com>
Date: Mon, 12 Nov 2012 10:43:20 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.6esrpre) Gecko/20120817 Icedove/10.0.6
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 2/2] pinctrl: dove: Checking valid config in dove_audio1_ctrl_set
References: <1352641495.3113.1.camel@phoenix> <1352641569.3113.2.camel@phoenix>
In-Reply-To: <1352641569.3113.2.camel@phoenix>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2012 02:46 PM, Axel Lin wrote:
> Move the code checking valid config to dove_audio1_ctrl_set(), this ensures we
> always set valid config. And then dove_audio1_ctrl_get() always returns correct
> config.
>
> Signed-off-by: Axel Lin<axel.lin@ingics.com>

Axel,

although correct in a software point-of-view, I don't think we should move this
from _get to _set because the hardware allows to set these bits without changing
the actual function. There are some dominant bits in this settings so the masking
is done to not have ~5 different values for the same function here.

The pinctrl driver will set one of the (software) supported values anyway but on
reset there could be one of the values mentioned above written into the registers.

Sebastian

