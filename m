Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755346Ab2BGHvf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 02:51:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:33255 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab2BGHve (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 02:51:34 -0500
Subject: Re: [BUG] perf: perf sched warning possibly due to clock
 granularity on AMD
From: Peter Zijlstra <peterz@infradead.org>
To: Venki Pallipadi <venki@google.com>
Cc: Borislav Petkov <bp@amd64.org>, Stephane Eranian <eranian@google.com>,
        linux-kernel@vger.kernel.org, acme@redhat.com, mingo@elte.hu,
        robert.richter@amd.com, eric.dumazet@gmail.com,
        Andreas Herrmann <andreas.herrmann3@amd.com>
In-Reply-To: <CABeCy1ZH_BQhoSegeyBnY0XkjL9afm5=onKrmt9SApufCWgs3A@mail.gmail.com>
References: <20120206132546.GA30854@quad> <1328538403.2482.4.camel@laptop>
	 <20120206153408.GA31237@aftab> <1328546246.2482.10.camel@laptop>
	 <20120206164626.GA31704@aftab> <1328547259.2482.11.camel@laptop>
	 <20120206202722.GA556@aftab> <1328560293.2482.24.camel@laptop>
	 <20120206203738.GB556@aftab>
	 <CABeCy1ZH_BQhoSegeyBnY0XkjL9afm5=onKrmt9SApufCWgs3A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Feb 2012 08:51:08 +0100
Message-ID: <1328601068.2482.46.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 13:19 -0800, Venki Pallipadi wrote:
> 
> Yes. If these two flags are set, TSC should be consistent and sched_clock_stable
> could be set and it will be reset if there is a call to mark_tsc_unstable(). 

Only trouble is that sched_clock_cpu() et al. will jump when you flip
sched_clock_stable to 0 after you started using it.. its something we
might want to fix.

