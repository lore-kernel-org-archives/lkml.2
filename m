Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756568Ab0FQLYh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jun 2010 07:24:37 -0400
Received: from hera.kernel.org ([140.211.167.34]:35732 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750701Ab0FQLYg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jun 2010 07:24:36 -0400
Message-ID: <4C1A05AF.5010405@kernel.org>
Date: Thu, 17 Jun 2010 13:23:27 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, bphilips@suse.de,
       yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-10-git-send-email-tj@kernel.org> <20100616204854.4b036f87@infradead.org> <4C19DA64.8000409@kernel.org> <alpine.LFD.2.00.1006171310560.4290@localhost.localdomain>
In-Reply-To: <alpine.LFD.2.00.1006171310560.4290@localhost.localdomain>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 17 Jun 2010 11:23:29 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/17/2010 01:12 PM, Thomas Gleixner wrote:
>> Hmmm.... oh, I see.  Wouldn't it be much better to use moving avg of
>> IRQ durations instead of letting the driver specify it?  Drivers are
>> most likely to just hard code it and It's never gonna be accurate.
> 
> Right, but that's probably more accurate than the core code heuristics
> ever will be.

Eh, not really.  For ATA at least, there will be three different
classes of devices.  SSDs, hard drives and optical devices and if we
get running avg w/ fairly large stability part, the numbers wouldn't
be too far off and there's no reliable way for the driver to tell
which type of device is on the other side of the cable.  So, I think
running avg would work much better.

Thanks.

-- 
tejun
