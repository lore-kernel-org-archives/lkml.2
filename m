Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1IXCes (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 22:34:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:35649 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753225Ab1IXCer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 22:34:47 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:from:date:
	message-id:subject:to:cc:content-type:x-system-of-record;
	b=CBFS9lMVnw5pQ0mkJnmtHL7JiO5cgJbGb8o/YaVTKsqbKzfcnBFLcgolVCrzr11Dv
	VZBdQU+Vy2/heSj/skRgg==
MIME-Version: 1.0
In-Reply-To: <1316825684.6387.5.camel@gandalf.stny.rr.com>
References: <1316825684.6387.5.camel@gandalf.stny.rr.com>
From: Greg Thelen <gthelen@google.com>
Date: Fri, 23 Sep 2011 19:34:23 -0700
Message-ID: <CAHH2K0Z_MsVceOjoFwT=qORSsKrFWjs_V602NMtPBysasJLEww@mail.gmail.com>
Subject: Re: [PATCH] memcg: Fix race condition in memcg_check_events() with
 this_cpu usage
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        PeterZijlstra <peterz@infradead.org>, ChristophLameter <cl@linux.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 5:54 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>
> The code in memcg_check_events() calls this_cpu_read() on
> different variables without disabling preemption, and can cause
> the calculations to be done from two different CPU variables.
>
> Disable preemption throughout the check to keep apples and oranges
> from becoming a mixed drink.
>
> [ Added this_cpu to __this_cpu conversion by Johannes ]
>
> Cc: Greg Thelen <gthelen@google.com>
> Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Cc: Balbir Singh <balbir@linux.vnet.ibm.com>
> Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Peter Zijlstra <peterz@infradead.org>
> Cc: Christoph Lameter <cl@linux.com>
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
> Link: http://lkml.kernel.org/r/20110919212641.015320989@goodmis.org

Looks good to me.  Thanks.

Reviewed-by: Greg Thelen <gthelen@google.com>
