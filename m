Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab1BUQyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 11:54:49 -0500
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:35359 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752270Ab1BUQyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 11:54:47 -0500
Date: Mon, 21 Feb 2011 18:54:43 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: balbi@ti.com, David Cohen <dacohen@gmail.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu,
        linux-omap@vger.kernel.org, linux-media@vger.kernel.org,
        Alexey Dobriyan <adobriyan@gmail.com>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH v2 1/1] headers: fix circular dependency between
 linux/sched.h and linux/wait.h
Message-ID: <20110221165443.GL23087@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1298299131-17695-1-git-send-email-dacohen@gmail.com>
 <1298299131-17695-2-git-send-email-dacohen@gmail.com>
 <1298303677.24121.1.camel@twins>
 <AANLkTimOT6jNG3=TiRMJR0dgEQ6EHjcBPJ1ivCu3Wj5Q@mail.gmail.com>
 <1298305245.24121.7.camel@twins>
 <20110221162939.GK23087@legolas.emea.dhcp.ti.com>
 <1298306607.24121.18.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298306607.24121.18.camel@twins>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Feb 21, 2011 at 05:43:27PM +0100, Peter Zijlstra wrote:
> > > And then make sched.c include signal.h and completion.h.
> > 
> > you wouldn't prevent the underlying problem which is the need to include
> > sched.h whenever you include wait.h and use wake_up*()
> 
> If you'd applied your brain for a second before hitting reply you'd have
> noticed that at this point you'd (likely) be able to include sched.h
> from wait.h. which is the right way about, you need to be able to
> schedule in order to build waitqueues.

someone's in a good mood today ;-)

What you seem to have missed is that sched.h doesn't include wait.h, it
includes completion.h and completion.h needs wait.h due the
wait_queue_head_t it uses.

If someone finds a cleaner way to drop that need, then I'm all for it as
my original suggestion to the original patch was to include sched.h in
wait.h, but it turned out that it's not possible due to the reasons
already explained.

-- 
balbi
