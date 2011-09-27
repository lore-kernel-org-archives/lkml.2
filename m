Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752998Ab1I0JkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 05:40:05 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:63001 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752887Ab1I0JkD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 05:40:03 -0400
MIME-Version: 1.0
In-Reply-To: <1317114837.15383.1.camel@twins>
References: <1317110185-9219-1-git-send-email-lliubbo@gmail.com>
	<1317114837.15383.1.camel@twins>
Date: Tue, 27 Sep 2011 17:40:02 +0800
Message-ID: <CAA_GA1czUfsP-mr74zMsLbjifx2Gsa-Fnv+V4yjfa0PUpyg-ow@mail.gmail.com>
Subject: Re: [PATCH] spinlock: rm duplicated preempt en/disable for bottom half
From: Bob Liu <lliubbo@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, joe@perches.com,
        tglx@linutronix.de
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 5:13 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Tue, 2011-09-27 at 15:56 +0800, Bob Liu wrote:
>> local_bh_en/disable() has already deal with en/disable preempt, so rm the
>> dumplicated one from spinlock_api_up/smp.h head file.
>
> I bet you haven't tried booting this..  you just broke stuff like:
>

I only tried it on blackfin arch and can boot successfully
although it's a simple single-cpu ystem.

>  spin_lock_bh(&foo);
>  /* do crap */
>  spin_unlock(&foo);
>  /* do some other crap */
>  local_bh_enable();
>
>
> And yes that does happen.

Could you please give an example?  I did a simple search but no result.
I thought the user should use spin_lock_bh()/spin_unlock_bh() in pairs.

-- 
Regards,
--Bob
