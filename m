Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0FSJEZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 05:04:25 -0400
Received: from hera.kernel.org ([140.211.167.34]:34496 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754834Ab0FSJEY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 05:04:24 -0400
Message-ID: <4C1C87DC.6060405@kernel.org>
Date: Sat, 19 Jun 2010 11:03:24 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.10) Gecko/20100512 Thunderbird/3.0.5
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: Arjan van de Ven <arjan@infradead.org>, mingo@elte.hu, tglx@linutronix.de,
       bphilips@suse.de, yinghai@kernel.org, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       jeff@garzik.org, linux-ide@vger.kernel.org, stern@rowland.harvard.edu,
       gregkh@suse.de, khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-10-git-send-email-tj@kernel.org> <20100616204854.4b036f87@infradead.org> <87zkyro1xl.fsf@basil.nowhere.org> <4C1C830B.5020806@kernel.org> <20100619090031.GE18946@basil.fritz.box>
In-Reply-To: <20100619090031.GE18946@basil.fritz.box>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 19 Jun 2010 09:03:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 06/19/2010 11:00 AM, Andi Kleen wrote:
>> IIUC, it's not to help or optimize polling itself.  It just gives us a
>> way to estimate when the next interrupt would be so that power can be
>> optimized for non polling cases.
> 
> Shouldn't the idle governour estimate this already?

I'm not an expert on the subject.  According to Arjan,

  One of the hard cases right now that the C state code has is that it
  needs to predict the future. While it has a ton of heuristics,
  including some is there IO oustanding" ones, libata is a really good
  case: libata will know generally that within one seek time (5 msec
  on rotating rust, much less on floating electrons) there'll be an
  interrupt (give or take, but this is what we can do heuristics for
  on a per irq level).  So it's a good suggestion of what the future
  will be like, MUCH better than any hint we have right now... all we
  have right now is some history, and when the next timer is....

So, it seems like it would help.

Thanks.

-- 
tejun
