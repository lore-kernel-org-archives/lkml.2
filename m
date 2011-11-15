Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753542Ab1KOMsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 07:48:05 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:15423 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526Ab1KOMsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 07:48:03 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6530"; a="137747770"
Message-ID: <faba552e7bd19ee5399c73c2b478a34d.squirrel@www.codeaurora.org>
In-Reply-To: <001e01cca2b2$3b449310$b1cdb930$%jun@samsung.com>
References: <620ec9ffa6bdbba9ae5f76998e36f8dc.squirrel@www.codeaurora.org>
    <001001cca043$395dbfc0$ac193f40$%jun@samsung.com>
    <CANfBPZ-Zn+R4GosEL-RJxh8gduAr8e+qN876uPwDkHfiEpdERw@mail.gmail.com>
    <ea21d88d904af165cb911354e3f51ea6.squirrel@www.codeaurora.org>
    <001e01cca2b2$3b449310$b1cdb930$%jun@samsung.com>
Date: Tue, 15 Nov 2011 04:48:02 -0800 (PST)
Subject: RE: [PATCH 2/2] mmc: core: Support packed command for eMMC4.5 
     device
From: merez@codeaurora.org
To: "Seungwon Jeon" <tgih.jun@samsung.com>
Cc: merez@codeaurora.org, "'S, Venkatraman'" <svenkatr@ti.com>,
        linux-mmc@vger.kernel.org, "'Chris Ball'" <cjb@laptop.org>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, dh.han@samsung.com
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> >>> >> >> > +       if (rqc)
>> >>> >> >> > +               reqs = mmc_blk_chk_packable(mq, rqc);
>> >>>
>> >>> It would be best to keep all the calls to blk_fetch_request in the
>> same
>> >>> location. Therefore, I suggest to move the call to
>> mmc_blk_chk_packable
>> >>> to
>> >>> mmc/card/queue.c after the first request is fetched.
>> >>
>> >> At the first time, I considered that way.
>> >> I'll do more, if possible.
> I considered more.
> I think that mmc_blk_chk_packable would rather be called only for r/w type
> than all request type(e.g. discard, flush).
>
mmc_blk_chk_packable can check the cmd_flags of the request to verify it's
not a flush/disacrad etc. In such cases will not pack.

