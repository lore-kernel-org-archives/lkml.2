Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756612Ab1BCRQM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 12:16:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:51779 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756584Ab1BCRQK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 12:16:10 -0500
Subject: Re: [RFC][PATCH 17/18] sched: Move the second half of ttwu() to
 the remote cpu
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: frank.rowand@am.sony.com
Cc: Oleg Nesterov <oleg@redhat.com>, Chris Mason <chris.mason@oracle.com>,
        "Rowand, Frank" <Frank_Rowand@sonyusa.com>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Galbraith <efault@gmx.de>, Paul Turner <pjt@google.com>,
        Jens Axboe <axboe@kernel.dk>, Yong Zhang <yong.zhang0@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <4D435988.2090002@am.sony.com>
References: <20110104145929.772813816@chello.nl>
	 <20110104150103.164045216@chello.nl> <20110105210754.GA2579@redhat.com>
	 <1294326577.2016.373.camel@laptop>  <20110107152207.GA16341@redhat.com>
	 <1295368688.30950.925.camel@laptop>  <4D435988.2090002@am.sony.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 03 Feb 2011 18:16:53 +0100
Message-ID: <1296753413.26581.465.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-01-28 at 16:04 -0800, Frank Rowand wrote:
> 
> I haven't yet tried to twist my head around either the sched_fair or the
> sched_rt load balance paths.  But wouldn't it just be safer (especially
> given that the load balance code will be modified by somebody at some
> point in the future, and that this locking complexity does require head
> twisting) to just add the pi_lock in the load-balance paths also? 

I don't think that's needed, and I'm generally hesitant to add atomics
where not strictly needed.


