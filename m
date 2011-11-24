Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab1KXOSM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 09:18:12 -0500
Received: from casper.infradead.org ([85.118.1.10]:42875 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab1KXOSL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 09:18:11 -0500
Message-ID: <1322144284.2921.59.camel@twins>
Subject: Re: [PATCH RFC] remove jump_label optimization for perf sched events
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Gleb Natapov <gleb@redhat.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu,
        Jason Baron <jbaron@redhat.com>, rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Thu, 24 Nov 2011 15:18:04 +0100
In-Reply-To: <20111124134542.GK2557@redhat.com>
References: <20111117123029.GB16853@redhat.com>
	 <1321534159.27735.33.camel@twins> <20111121131739.GF16853@redhat.com>
	 <1322140980.2921.49.camel@twins> <20111124134542.GK2557@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-24 at 15:45 +0200, Gleb Natapov wrote:
> Yes, I contemplated this. I didn't realized that there are tons of
> jump_labels though.

Yeah, every tracepoint has one, that's by far the biggest user
currently.

> > But is there really any other user for this? All the trace bits are root
> > only iirc and kvm itself only sets them on the guest kernel I think for
> > paravirt, so that's not a problem.
> > 
> The problem I am trying to fix with this patch is not strictly
> virtualization related. 

No I know, its about user-trigerably jump_label conversions, but afaik
that's only perf. The others: tracepoints, and paravirt can't be toggled
by unpriv. users.
