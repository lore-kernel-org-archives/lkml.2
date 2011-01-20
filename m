Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755278Ab1ATV2q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 16:28:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:57034 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112Ab1ATV2n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 16:28:43 -0500
Message-ID: <4D38A836.5040003@zytor.com>
Date: Thu, 20 Jan 2011 13:25:10 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: matthieu castet <castet.matthieu@free.fr>
CC: Lin Ming <ming.m.lin@intel.com>, Oliver Neukum <oneukum@suse.de>,
        rjw@sisk.pl, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Andrew Morton <akpm@linux-foundation.org>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Denys Vlasenko <vda.linux@googlemail.com>,
        Michal Marek <mmarek@suse.cz>, Yinghai Lu <yinghai@kernel.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Borislav Petkov <bp@alien8.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Siarhei Liakh <sliakh.lkml@gmail.com>,
        Xuxian Jiang <jiang@cs.ncsu.edu>, Dave Airlie <airlied@redhat.com>,
        Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] S3 resume on SandyBridge doesn't work with NX protection
 (5bd5a45)
References: <20110119173710.GA1331@suse.de> <20110119230602.6dd34fa3@mat-laptop> <20110120134734.GA7230@suse.de> <1295535954.4d384f524c8f0@imp.free.fr> <20110120155909.GA21782@suse.de> <4D38A697.3040308@free.fr>
In-Reply-To: <4D38A697.3040308@free.fr>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/20/2011 01:18 PM, matthieu castet wrote:
> PS :
> x86 trampoline is a mess. There are many (wakeup, smpboot) and differ between 32 and 64 bit.
> H. Peter Anvin, aren't you rewriting them ?

Yes, working on it, starting with the framework used to install them.

They can't all be unified; they are used for different purposes and have
different requirements (for one thing, 32 vs 64 bits require different
trampoline code), but the install framework patchset is almost done, and
the recent change of keeping the 1:1 pagetable set around is also a
dramatic cleanup.

	-hpa

