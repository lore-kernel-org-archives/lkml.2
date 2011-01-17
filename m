Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752972Ab1AQO7i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 09:59:38 -0500
Received: from canuck.infradead.org ([134.117.69.58]:50767 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752439Ab1AQO7d convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 09:59:33 -0500
Subject: Re: [wake_afine fixes/improvements 1/3] sched: update
 effective_load() to use global share weights
From: Peter Zijlstra <peterz@infradead.org>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
In-Reply-To: <1295273497.30950.119.camel@laptop>
References: <20110115015749.692623529@google.com>
	 <20110115015817.069769529@google.com>  <1295273497.30950.119.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 17 Jan 2011 15:20:35 +0100
Message-ID: <1295274035.30950.122.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-01-17 at 15:11 +0100, Peter Zijlstra wrote:
> 
> > +             if (lw > 0 && wl < lw)
> > +                     wl = (wl * tg->shares) / lw;
> > +             else
> > +                     wl = tg->shares;
> 
> OK, so this computes the new load for this cpu, by taking the
> appropriate proportion of tg->shares, it clips on large wl, and does
> something funny for !lw -- on purpose? 

D'0h, when !lw, the tg is empty and we don't care what happens since it
won't get scheduled anyway..

Ok, very nice, applied!
