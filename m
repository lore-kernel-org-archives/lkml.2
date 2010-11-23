Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754814Ab0KWRPx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 12:15:53 -0500
Received: from casper.infradead.org ([85.118.1.10]:60876 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753774Ab0KWRPw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 12:15:52 -0500
Subject: Re: [tip:sched/core] cpu: Remove incorrect BUG_ON
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: linux-tip-commits@vger.kernel.org, linux-kernel@vger.kernel.org,
        hpa@zytor.com, mingo@redhat.com, tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <20101123150813.GA535@redhat.com>
References: <tip-51a96c77815e7f139892a6e9c8275a50e9baebdf@git.kernel.org>
	 <20101123143910.GA31502@redhat.com> <1290524704.2072.412.camel@laptop>
	 <20101123150813.GA535@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Nov 2010 18:16:08 +0100
Message-ID: <1290532568.2072.416.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 16:08 +0100, Oleg Nesterov wrote:
> > Ah,. uhm,. you mean, not do anything at all?
> >
> > Dunno, really, let me try and read the code there.
> 
> Thanks. This is very minor of course, but it would be nice to
> undestand the reason. To me it looks unneeded, but I don't trust
> myself.  (snippets from my previous email below).
> 
> 
I think because the call to __cpu_die (-> native_cpu_die) relies on the
remote cpu running the idle thread, and the CPU_DEAD notifier callback
wants to run with the guarantee the remote cpu is in fact dead as a
doornail.
