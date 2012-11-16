Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753807Ab2KPXWW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 18:22:22 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46857 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679Ab2KPXWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 18:22:21 -0500
Date: Fri, 16 Nov 2012 15:22:19 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -mm]
 percpu_rw_semaphore-reimplement-to-not-block-the-readers-unnecessari ly.fix
Message-Id: <20121116152219.d4acc6d0.akpm@linux-foundation.org>
In-Reply-To: <20121111182744.GA25282@redhat.com>
References: <20121019192838.GM2518@linux.vnet.ibm.com>
	<Pine.LNX.4.64.1210221910150.25995@file.rdu.redhat.com>
	<20121030184800.GA16129@redhat.com>
	<20121031194135.GA504@redhat.com>
	<20121031194158.GB504@redhat.com>
	<CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com>
	<20121102180606.GA13255@redhat.com>
	<20121108134805.GA23870@redhat.com>
	<20121108134849.GB23870@redhat.com>
	<20121108120700.42d438f2.akpm@linux-foundation.org>
	<20121111182744.GA25282@redhat.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 Nov 2012 19:27:44 +0100
Oleg Nesterov <oleg@redhat.com> wrote:

>  lib/percpu-rwsem.c |   35 +++++++++++++++++++++++++++++++++--

y'know, this looks like a great pile of useless bloat for single-CPU
machines.  Maybe add a CONFIG_SMP=n variant which simply calls the
regular rwsem operations?


