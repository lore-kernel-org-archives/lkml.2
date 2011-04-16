Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1DPN1y (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Apr 2011 09:27:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:53374 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752468Ab1DPN1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Apr 2011 09:27:47 -0400
Date: Sat, 16 Apr 2011 14:27:25 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 5/5] signals: Don't hold shared siglock across
 signal delivery
Message-ID: <20110416142725.55720caa@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110414192059.GB23517@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
	<1302031310-1765-6-git-send-email-matt@console-pimps.org>
	<20110413201219.GB15330@redhat.com>
	<20110414115750.1a6703b6@mfleming-mobl1.ger.corp.intel.com>
	<20110414192059.GB23517@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011 21:20:59 +0200
Oleg Nesterov <oleg@redhat.com> wrote:

> Btw, I forgot to mention another problem. We should not dequeue from
> signal->shared_pending before task->pending. There are various reasons
> why we shouldn't, but in particular please look at a27341cd
> "Prioritize synchronous signals over 'normal' signals".

Oh, that's an interesting point! I hadn't thought of that.

OK, I'll swap the dequeue order back to the way it was. This actually
makes things a little easier as we can now get away with not reading
the list of pending shared signals in the fast path.

-- 
Matt Fleming, Intel Open Source Technology Center
