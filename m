Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752279Ab1I0JOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 05:14:36 -0400
Received: from merlin.infradead.org ([205.233.59.134]:35852 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142Ab1I0JOf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 05:14:35 -0400
Subject: Re: [PATCH] spinlock: rm duplicated preempt en/disable for bottom
 half
From: Peter Zijlstra <peterz@infradead.org>
To: Bob Liu <lliubbo@gmail.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, joe@perches.com,
        tglx@linutronix.de
Date: Tue, 27 Sep 2011 11:13:56 +0200
In-Reply-To: <1317110185-9219-1-git-send-email-lliubbo@gmail.com>
References: <1317110185-9219-1-git-send-email-lliubbo@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1317114837.15383.1.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-27 at 15:56 +0800, Bob Liu wrote:
> local_bh_en/disable() has already deal with en/disable preempt, so rm the
> dumplicated one from spinlock_api_up/smp.h head file.

I bet you haven't tried booting this..  you just broke stuff like:

  spin_lock_bh(&foo);
  /* do crap */
  spin_unlock(&foo);
  /* do some other crap */
  local_bh_enable();


And yes that does happen.

  
