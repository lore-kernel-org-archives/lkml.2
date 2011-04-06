Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1DFNPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 09:15:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:46884 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755870Ab1DFNPx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 09:15:53 -0400
Date: Wed, 6 Apr 2011 14:15:48 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [RFC][PATCH 1/5] signals: Always place SIGCONT and SIGSTOP on
 'shared_pending'
Message-ID: <20110406141548.1e0736ce@mfleming-mobl1.ger.corp.intel.com>
In-Reply-To: <20110406125757.GA12099@redhat.com>
References: <1302031310-1765-1-git-send-email-matt@console-pimps.org>
	<1302031310-1765-2-git-send-email-matt@console-pimps.org>
	<20110405201958.GA1404@redhat.com>
	<20110405215003.636e950b@mfleming-mobl1.ger.corp.intel.com>
	<20110406125757.GA12099@redhat.com>
X-Mailer: Claws Mail 3.7.8cvs52 (GTK+ 2.22.0; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 Apr 2011 14:57:57 +0200
Oleg Nesterov <oleg@redhat.com> wrote:
 
> Argh, sorry, I was not clear.
> 
> First of all, only SIGSTOP is never delivered to user-space, other
> sig_kernel_stop() signals can have a handler and in this case, say,
> SIGTTIN doesn't stop but acts like the normal signal. This means you
> can't put it into shared_pending.

Yeah, good point. This patch definitely needs dropping from the series.

> But even SIGSTOP should be routed properly. If the process is ptraced,
> the tracee reports SIGSTOP to the debugger first. This means that
> tkill(SIGSTOP) should be delivered to the right target.

Right, thanks.

-- 
Matt Fleming, Intel Open Source Technology Center
