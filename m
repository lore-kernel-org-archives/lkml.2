Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932696Ab1J1Mat (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 08:30:49 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60367 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932552Ab1J1Mas (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 08:30:48 -0400
Date: Fri, 28 Oct 2011 18:00:02 +0530
From: Rabin Vincent <rabin@rab.in>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Jason Baron <jbaron@redhat.com>, Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] x86: call stop_machine_text_poke() on all CPUs
Message-ID: <20111028123002.GA3012@debian>
References: <1319702072-32676-1-git-send-email-rabin@rab.in>
 <4EAA1357.8060802@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EAA1357.8060802@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 11:28:39AM +0900, Masami Hiramatsu wrote:
> (2011/10/27 16:54), Rabin Vincent wrote:
> > It appears that stop_machine_text_poke() wants to be called on all CPUs,
> > like it's done from text_poke_smp().  Fix text_poke_smp_batch() to do
> > this.
> 
> cpu_mask==NULL finally falls back to cpu_online_mask, but even though
> it should be specified correctly.

Not quite.  Passing NULL to __stop_machine means that the function will
be called on any one CPU only, while passing cpu_online_mask means that
the function will be called on all CPUs.  So this patch is a behaviour
change/bug fix, not just a clarification.
