Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab2DNSnJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Apr 2012 14:43:09 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:59362 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755096Ab2DNSnI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Apr 2012 14:43:08 -0400
Date: Sat, 14 Apr 2012 14:43:05 -0400 (EDT)
Message-Id: <20120414.144305.2085076886038926579.davem@davemloft.net>
To: xiong@qca.qualcomm.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        qca-linux-team@qualcomm.com, nic-devel@qualcomm.com
Subject: Re: [PATCH 04/12] atl1c: remove VPD register
From: David Miller <davem@davemloft.net>
In-Reply-To: <1334397568-8444-5-git-send-email-xiong@qca.qualcomm.com>
References: <1334397568-8444-1-git-send-email-xiong@qca.qualcomm.com>
	<1334397568-8444-5-git-send-email-xiong@qca.qualcomm.com>
X-Mailer: Mew version 6.4 on Emacs 24.0.95 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sat, 14 Apr 2012 11:43:06 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: xiong <xiong@qca.qualcomm.com>
Date: Sat, 14 Apr 2012 17:59:20 +0800

> VPD register is only used for L1(devid=PCI_DEVICE_ID_ATTANSIC_L1) to
> access external NV-memory.
> l1c & later chip doesn't use it any more.
> no special userspace tool interpret the dumpped registers.
> dumpping them via ethtool is just for debug.
> 
> Signed-off-by: xiong <xiong@qca.qualcomm.com>
> Tested-by: Liu David <dwliu@qca.qualcomm.com>

I'm really disappointed that you're posting this patch again and
completely ignoring our feedback.

You're making this code buggy, and you're make me extremely irritated.

What's the point of our feedback if you just completely ignore it?

You can't crap up the register dump like this, you have to make
several modifications if you want to change the layout in any
way:

1) You have to adjust AT_REGS_LEN, because you're reporting one
   less register.

2) You have to adjust the offsets at the end of atl1c_get_regs(),
   the ones that explicitly use regs_buff[73] and regs_buf[74],
   otherwise you're leaving a gap between that area that's filled
   in using those p++ pointer increments and the entries filled
   in with these explicit offsets into reg_buff[].

3) You have to increment the register dump version, via the struct
   ethtool_regs 'version' field, so that userland programs can know
   that you've changed it.

So, tell me, are you going to completely ignore our feedback on
this issue again?
