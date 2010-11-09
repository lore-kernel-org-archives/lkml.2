Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab0KIQ4z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 11:56:55 -0500
Received: from casper.infradead.org ([85.118.1.10]:40842 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752134Ab0KIQ4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 11:56:49 -0500
Subject: Re: Q: perf_event && event->owner
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Prasad <prasad@linux.vnet.ibm.com>, Roland McGrath <roland@redhat.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101109155714.GA1903@redhat.com>
References: <20101108145647.GA3426@redhat.com>
	 <20101108145754.GB3434@redhat.com> <20101108201108.GA6777@nowhere>
	 <20101109155714.GA1903@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 09 Nov 2010 17:56:44 +0100
Message-ID: <1289321804.2191.57.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 16:57 +0100, Oleg Nesterov wrote:
> 
> If the creator of perf_event dies, nobody can use its ->perf_event_list
> anyway. What is the point to keep the reference to the dead task_struct
> and preserve this ->perf_event_list? 

But when the owner dies it will close all its fds, which means it will
clear its tsk->perf_event_list, no? (With exception of the case where
the fd was passed through a unix-socket to another process).

