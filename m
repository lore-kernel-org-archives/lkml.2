Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752220Ab0HSAFA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 20:05:00 -0400
Received: from mms1.broadcom.com ([216.31.210.17]:4898 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751103Ab0HSAE6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 20:04:58 -0400
X-Server-Uuid: 02CED230-5797-4B57-9875-D5D2FEE4708A
Message-ID: <4C6C7513.2080603@broadcom.com>
Date: Wed, 18 Aug 2010 17:04:35 -0700
From: "Brian Norris" <norris@broadcom.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11)
 Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: "Abdoulaye Walsimou GAYE" <awg@embtoolkit.org>
cc: "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "Artem Bityutskiy" <dedekind1@gmail.com>,
        "Linux Kernel" <linux-kernel@vger.kernel.org>,
        "mike@it-loops.com" <mike@it-loops.com>,
        "David Woodhouse" <dwmw2@infradead.org>
Subject: Re: [PATCH] mtd: nand: Fix regression in BBM detection
References: <1282155904-10113-1-git-send-email-norris@broadcom.com>
 <4C6C34DE.2050904@embtoolkit.org>
In-Reply-To: <4C6C34DE.2050904@embtoolkit.org>
X-WSS-ID: 6072AA9C37O66468543-01-01
Content-Type: text/plain;
 charset=iso-8859-1;
 format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/18/2010 12:30 PM, Abdoulaye Walsimou GAYE wrote:
> Brian,
> Sorry for the long delay!
> I tested the above patch unfortunately it does not help in my case!

Understood. That makes sense. In fact, your problem is most likely *not* 
related to this commit. As I mentioned before, please try narrowing down 
what specifically caused this; if I read correctly, you jumped from 
2.6.33 to 2.6.36-rc1. There have been several important changes between 
those releases. Notably, this commit may be giving Samsung chips problems:
426c457a3216fac74e

This thread is covering a few problems with Samsung:
http://lists.infradead.org/pipermail/linux-mtd/2010-August/031590.html

> And when I go further and put a JFFS2 in that partition and boot the
> board I have
<snip>
> Despite these errors I can actually use the board (no kernel panic)!
> The part is Samsung K9F1208U0C - PCB0

Unless you really know what you're doing, I wouldn't be writing/erasing 
the flash if it's not detecting bad blocks properly.

Let me know if you have trouble with narrowing down to the problem commit.

Brian

