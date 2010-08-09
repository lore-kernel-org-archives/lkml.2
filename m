Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756052Ab0HIJ4a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 05:56:30 -0400
Received: from smtp-out-166.synserver.de ([212.40.180.166]:1046 "HELO
	smtp-out-165.synserver.de" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with SMTP id S1755931Ab0HIJ42 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 05:56:28 -0400
X-SynServer-TrustedSrc: 1
X-SynServer-AuthUser: markus@trippelsdorf.de
X-SynServer-PPID: 31133
Date: Mon, 9 Aug 2010 11:56:19 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Tejun Heo <htejun@gmail.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, walt <w41ter@gmail.com>,
        linux-kernel@vger.kernel.org,
        Suresh Siddha <suresh.b.siddha@intel.com>
Subject: Re: [PATCH wq#for-linus] workqueue: workqueue_cpu_callback()
 should be cpu_notifier not hotcpu_notifier
Message-ID: <20100809095619.GA1621@arch.tripp.de>
References: <i3n3dh$t48$1@dough.gmane.org>
 <20100809063742.GA1632@arch.tripp.de>
 <20100809083053.GB2169@osiris.boeblingen.de.ibm.com>
 <20100809083451.GC2169@osiris.boeblingen.de.ibm.com>
 <4C5FC49B.9040208@kernel.org>
 <4C5FCC14.6030901@gmail.com>
 <20100809094630.GA1603@arch.tripp.de>
 <4C5FCF0C.2000100@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4C5FCF0C.2000100@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 09, 2010 at 11:49:00AM +0200, Tejun Heo wrote:
> Hello,
> 
> On 08/09/2010 11:46 AM, Markus Trippelsdorf wrote:
> > This fixes the boot problem here. Thanks.
> 
> Great.  May I add your Tested-by?

Sure.
    Tested-by: Markus Trippelsdorf <markus@trippelsdorf.de>

> > (The drm delayed enqueue problem, which I mentioned earlier still
> > persists.)
> 
> Yeah, I'm looking into it now but it looks like the error message is
> simply spurious.  queue_delayed_work() returns 1 if the work was
> actually queued and 0 if it was already pending and thus the function
> call was no-op.  output_poll_execute() is incorrectly interpreting 1
> return as error.  I'll look through the history and try to find out
> whether/how wq changes affected the behavior, but the fix is most
> likely simply killing the message.

Yes, this looks like a cosmetic issue and I observe no other graphics
problems at all.
-- 
»A man who doesn't know he is in prison can never escape.«
William S. Burroughs
