Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758074Ab1FJUod (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jun 2011 16:44:33 -0400
Received: from one.firstfloor.org ([213.235.205.2]:52763 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757989Ab1FJUoa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jun 2011 16:44:30 -0400
Date: Fri, 10 Jun 2011 22:44:28 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 1/3] posix-timers: remove idr_lock
Message-ID: <20110610204428.GB10930@one.firstfloor.org>
References: <1307736788-25457-1-git-send-email-andi@firstfloor.org> <1307738438.2872.7.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1307738438.2872.7.camel@edumazet-laptop>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 10, 2011 at 10:40:38PM +0200, Eric Dumazet wrote:
> Le vendredi 10 juin 2011 à 13:13 -0700, Andi Kleen a écrit :
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > idr_lock is only used to protect the global posix_timers idr,
> > but idr does its own locking (or RCUing) anyways and doesn't
> > need it. So remove it.
> 
> Are you sure of this assertion Andi ?
> 
> I believe we need an external synchronization before calling
> idr_remove() / idr_get_new()

idr has its own lock and from a quick check it seemed to always
take it when needed. Also ipc/* don't take a lock for this as far
as I can see, and I think RCU idr was designed for that.

-Andi
