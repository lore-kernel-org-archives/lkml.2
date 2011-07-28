Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1G1Jqu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 05:46:50 -0400
Received: from mx1.emlix.com ([193.175.82.238]:36908 "EHLO mx1.emlix.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754797Ab1G1Jqn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 05:46:43 -0400
Message-ID: <4E312FF5.1080007@emlix.com>
Date: Thu, 28 Jul 2011 11:46:29 +0200
From: =?ISO-8859-1?Q?Daniel_Gl=F6ckner?= <dg@emlix.com>
Organization: emlix GmbH
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Alessandro Zummo <a.zummo@towertech.it>,
        "George G. Davis" <gdavis@mvista.com>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rtc-omap: Fix initialization of control register
References: <1310381866-25584-1-git-send-email-dg@emlix.com> <20110727141907.53225270.akpm@linux-foundation.org>
In-Reply-To: <20110727141907.53225270.akpm@linux-foundation.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/2011 11:19 PM, Andrew Morton wrote:
> On Mon, 11 Jul 2011 12:57:46 +0200
> Daniel Gl__ckner <dg@emlix.com> wrote:
> 
>> As the comment explains, the intention of the code is to clear the
>> OMAP_RTC_CTRL_MODE_12_24 bit, but instead it only clears the
>> OMAP_RTC_CTRL_SPLIT and OMAP_RTC_CTRL_AUTO_COMP bits, which should be
>> kept. OMAP_RTC_CTRL_DISABLE, OMAP_RTC_CTRL_SET_32_COUNTER,
>> OMAP_RTC_CTRL_TEST, and OMAP_RTC_CTRL_ROUND_30S are also better off
>> being cleared.

> What were the user-visible effects of the bug?

The contents of the control register is undefined after a complete power
loss. On our board the RTC has been observed to sometimes power up with the
OMAP_RTC_CTRL_SET_32_COUNTER bit being set, which stops the clock.

  Daniel

-- 
Dipl.-Math. Daniel Glöckner, emlix GmbH, http://www.emlix.com
Fon +49 551 30664-0, Fax +49 551 30664-11,
Bertha-von-Suttner-Straße 9, 37085 Göttingen, Germany
Sitz der Gesellschaft: Göttingen, Amtsgericht Göttingen HR B 3160
Geschäftsführer: Dr. Uwe Kracke, Ust-IdNr.: DE 205 198 055

emlix - your embedded linux partner
