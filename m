Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab1AQKWu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:22:50 -0500
Received: from racecourse.oldelvet.net ([93.93.128.81]:37370 "EHLO
	racecourse.oldelvet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751033Ab1AQKWs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:22:48 -0500
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: Richard Mortimer <richm@oldelvet.org.uk>
To: David Miller <davem@davemloft.net>
Cc: richm@oldelvet.org.uk, 609371@bugs.debian.org, ben@decadent.org.uk,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        rostedt@goodmis.org, fweisbec@gmail.com, mingo@redhat.com,
        Jesper.Nilsson@axis.com, jeffm@suse.com
In-Reply-To: <20110116.220755.179947617.davem@davemloft.net>
References: <4D302B2F.7030108@oldelvet.org.uk>
	 <4D3074FE.3030707@oldelvet.org.uk>
	 <20110115.211722.39173519.davem@davemloft.net>
	 <20110116.220755.179947617.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 17 Jan 2011 10:22:41 +0000
Message-ID: <1295259761.32152.20.camel@duncow>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-16 at 22:07 -0800, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sat, 15 Jan 2011 21:17:22 -0800 (PST)

> > I think the problem we have here is that the _ftrace_events section is
> > not aligned sufficiently.  That ".align 4" mnemonic is a good indication
> > of this.  It should at least "8" on sparc64.
> 
I noticed another potentially 64 bit unfriendly alignment on struct
tracepoint in include/linux/tracepoint.h. I don't think that the
alignment of 32 breaks anything but it does leave a 24 byte hole. I
don't know enough about tracing to know if that is necessary.

struct tracepoint {
        const char *name;               /* Tracepoint name */
        int state;                      /* State. */
        void (*regfunc)(void);
        void (*unregfunc)(void);
        struct tracepoint_func *funcs;
}  __attribute__((aligned(32)));        /*
                                         * Aligned on 32 bytes because it is
                                         * globally visible and gcc happily
                                         * align these on the structure size.
                                         * Keep in sync with vmlinux.lds.h.
                                         */

Note I spotted this when looking at some residual sparc64 relocation
issues when _ftrace_events alignment is changed to 8. I'll follow those
issues up in a separate email when I get time later today.

Regards

Richard


