Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754799Ab0CWPdT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 11:33:19 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:39050 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754735Ab0CWPdR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 11:33:17 -0400
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
 lock
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
In-Reply-To: <4BA4860C.3050001@dcl.info.waseda.ac.jp>
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere>
	 <20100317095230.GD17146@elte.hu> <4BA1C141.8050409@dcl.info.waseda.ac.jp>
	 <20100318211633.GG5103@nowhere> <4BA4638C.40307@dcl.info.waseda.ac.jp>
	 <4BA4860C.3050001@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 23 Mar 2010 16:32:40 +0100
Message-ID: <1269358360.5109.88.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-03-20 at 17:23 +0900, Hitoshi Mitake wrote:
> In lockdep, held_locks of task_struct are accessed this arithmetical way
>                 prev = curr->held_locks + i;
> Of course this is valid way, but I feel it is more simple and natural way
>                 prev = curr->held_locks[i];
> 

The latter is a type mis-match, an equivalent expression would be:
   &curr->held_locks[i];
