Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758069Ab1FJUw4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:52:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:58758 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757733Ab1FJUwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:52:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BAbn4s5ikvFY5b/sX9SyyYMEhvpBpJ/+ZuEuRHG8PSgvpfTJzlSx1JfnoeXFR50cq1
         SgZFaJ/DHNzaT3Czb6vj+2M4RF920p+4FFUbQBzVedD3SJOtPaoYYSllzNjRk3aOrKrM
         VhKkFdqMoiRaXJrT+q2ZniRXtJucMzPIUFYck=
Subject: Re: [PATCH 1/3] posix-timers: remove idr_lock
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de,
        Andi Kleen <ak@linux.intel.com>
In-Reply-To: <20110610204428.GB10930@one.firstfloor.org>
References: <1307736788-25457-1-git-send-email-andi@firstfloor.org>
	 <1307738438.2872.7.camel@edumazet-laptop>
	 <20110610204428.GB10930@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 10 Jun 2011 22:52:45 +0200
Message-ID: <1307739165.2872.12.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le vendredi 10 juin 2011 à 22:44 +0200, Andi Kleen a écrit :
> On Fri, Jun 10, 2011 at 10:40:38PM +0200, Eric Dumazet wrote:
> > Le vendredi 10 juin 2011 à 13:13 -0700, Andi Kleen a écrit :
> > > From: Andi Kleen <ak@linux.intel.com>
> > > 
> > > idr_lock is only used to protect the global posix_timers idr,
> > > but idr does its own locking (or RCUing) anyways and doesn't
> > > need it. So remove it.
> > 
> > Are you sure of this assertion Andi ?
> > 
> > I believe we need an external synchronization before calling
> > idr_remove() / idr_get_new()
> 
> idr has its own lock and from a quick check it seemed to always
> take it when needed. Also ipc/* don't take a lock for this as far
> as I can see, and I think RCU idr was designed for that.
> 

I dont think so. Just read idr_remove() code : its obviously unsafe.

RCU permits readers to only hold rcu_read_lock()

But writers need their (external) synchronization.






