Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755085Ab2KISTO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Nov 2012 13:19:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:36494 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060Ab2KISTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Nov 2012 13:19:10 -0500
Date: Fri, 9 Nov 2012 19:19:44 +0100
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Anton Arapov <anton@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND v2 1/1] percpu_rw_semaphore: reimplement to not
	block the readers unnecessarily
Message-ID: <20121109181944.GA2078@redhat.com>
References: <20121031194135.GA504@redhat.com> <20121031194158.GB504@redhat.com> <CA+55aFx0yyke6V1+wgMPBN4QZ0w=YoV7yBRqp0uy6aGKbcmC5g@mail.gmail.com> <20121102180606.GA13255@redhat.com> <20121108134805.GA23870@redhat.com> <20121108134849.GB23870@redhat.com> <20121108120700.42d438f2.akpm@linux-foundation.org> <20121109154656.GA26134@redhat.com> <20121109170107.GB2419@linux.vnet.ibm.com> <20121109181048.GA1184@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121109181048.GA1184@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/09, Oleg Nesterov wrote:
>
> 	static bool xxx(brw)
> 	{
> 		down_write(&brw->rw_sem);
> 		if (!atomic_read(&brw->slow_read_ctr))
>			return true;

I meant, try_to_down_write(). Otherwise this can obviously deadlock.

Oleg.

