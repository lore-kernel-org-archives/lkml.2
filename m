Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab0G3Obx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 10:31:53 -0400
Received: from hera.kernel.org ([140.211.167.34]:39812 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756568Ab0G3Obv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 10:31:51 -0400
Message-ID: <4C52E22F.9060102@kernel.org>
Date: Fri, 30 Jul 2010 16:31:11 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.7) Gecko/20100713 Thunderbird/3.1.1
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: "Michael S. Tsirkin" <mst@redhat.com>, Sridhar Samudrala <sri@us.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        netdev <netdev@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Dmitri Vorobiev <dmitri.vorobiev@movial.com>,
        Jiri Kosina <jkosina@suse.cz>, Thomas Gleixner <tglx@linutronix.de>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH repost] sched: export sched_set/getaffinity to modules
References: <20100701144624.GA11171@redhat.com> <4C2CABF2.2020801@kernel.org> <1277996135.1917.198.camel@laptop> <4C2E2987.9040702@us.ibm.com> <1278094270.1917.288.camel@laptop> <20100702210637.GA12433@redhat.com> <20100726171230.GA27644@redhat.com> <1280166688.3375.5.camel@localhost> <20100726180834.GA26988@redhat.com> <20100727154155.GA13419@redhat.com> <20100730141901.GA9076@redhat.com>
In-Reply-To: <20100730141901.GA9076@redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 30 Jul 2010 14:31:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 07/30/2010 04:19 PM, Oleg Nesterov wrote:
> But I must admit, I personally dislike this idea. A kernel thread which
> is the child of the user-space process, and in fact it is not the "real"
> kernel thread. I think this is against the common case. If you do not
> care the signals/reparenting, why can't you fork the user-space process
> which does all the work via ioctl's ? OK, I do not understand the problem
> domain, probably this can't work.

Having kernel threads which are children of user process is plain
scary considering the many things parent/children relationship implies
and various bugs and security vulnerabilities in the area.  I can't
pinpoint any problem but I think we really shouldn't be adding
something like this for this specific use case.  If we can get away
with exporting a few symbols, let's go that way.

Thanks.

-- 
tejun
