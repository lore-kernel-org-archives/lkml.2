Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab0HBMYU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 08:24:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:44072 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751827Ab0HBMYT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 08:24:19 -0400
Subject: Re: [PATCH RFC] perf lock: Add new event "lock_acquired_waittime"
 for contention analysis
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
        h.mitake@gmail.com, Ingo Molnar <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jason Baron <jbaron@redhat.com>,
        Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>,
        Jens Axboe <axboe@kernel.dk>
In-Reply-To: <4C5507F2.7090503@dcl.info.waseda.ac.jp>
References: <1279990529-8798-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <20100728163946.GB5394@nowhere>  <4C5507F2.7090503@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 02 Aug 2010 14:23:04 +0200
Message-ID: <1280751784.1923.146.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-08-01 at 14:36 +0900, Hitoshi Mitake wrote:
> I want to make lockdep production kernel feature with dynamic
> patching.

Not really feasible. Note that enabling lockdep grows the size of
spinlock_t (and others) quite significantly.

Then there is the problem that you need to pass all tasks through some
quiesent state in order to enable lockdep (there must be a guarantee of
no locks held).

Now, we could possibly make it all work, but I'm not at all convinced we
want to pay the price, which is a much _much_ more complex
infrastructure.

