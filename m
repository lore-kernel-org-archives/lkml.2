Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754900Ab1LBUW5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 15:22:57 -0500
Received: from relay2.sgi.com ([192.48.179.30]:60447 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751820Ab1LBUW4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 15:22:56 -0500
Date: Fri, 2 Dec 2011 14:22:54 -0600
From: Dimitri Sivanich <sivanich@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] specific do_timer_cpu value for nohz off mode
Message-ID: <20111202202254.GG2164@sgi.com>
References: <20111108191149.GA7236@sgi.com>
 <20111122160802.e99d6218.akpm@linux-foundation.org>
 <20111130152959.GA19205@sgi.com>
 <20111130161131.31cdccff.akpm@linux-foundation.org>
 <20111130161610.69c516f7.akpm@linux-foundation.org>
 <20111201020727.GB30097@sgi.com>
 <20111130181318.38f4659d.akpm@linux-foundation.org>
 <20111201163740.GA11693@sgi.com>
 <20111201145623.d2bf252e.akpm@linux-foundation.org>
 <20111202201452.GF2164@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111202201452.GF2164@sgi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 02, 2011 at 02:14:52PM -0600, Dimitri Sivanich wrote:
> So at that time, we could be off +- almost a tick.  The question is, how
> critical is that?  When you down a cpu, the same sort of thing could 
> happen via tick_handover_do_timer(), which itself does nothing more than
> change tick_do_timer_cpu.

I should clarify that by 'same sort of thing' I mean that the target cpu
might've just gone through tick_periodic(), so we could miss a tick before
the next update.
