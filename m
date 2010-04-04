Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752088Ab0DDH4T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 03:56:19 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55234 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751621Ab0DDH4P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 03:56:15 -0400
Message-ID: <4BB8461B.3060502@dcl.info.waseda.ac.jp>
Date: Sun, 04 Apr 2010 16:56:11 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
       Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH RFC 00/11] lock monitor: Separate features related to
 lock
References: <1268563128-6486-1-git-send-email-mitake@dcl.info.waseda.ac.jp>	 <1268590435.9440.8.camel@laptop> <20100317013236.GB5258@nowhere>	 <20100317095230.GD17146@elte.hu> <4BA1C141.8050409@dcl.info.waseda.ac.jp>	 <20100318211633.GG5103@nowhere> <4BA4638C.40307@dcl.info.waseda.ac.jp>	 <4BA4860C.3050001@dcl.info.waseda.ac.jp> <1269358360.5109.88.camel@twins>
In-Reply-To: <1269358360.5109.88.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/10 00:32, Peter Zijlstra wrote:
 > On Sat, 2010-03-20 at 17:23 +0900, Hitoshi Mitake wrote:
 >> In lockdep, held_locks of task_struct are accessed this arithmetical way
 >>                  prev = curr->held_locks + i;
 >> Of course this is valid way, but I feel it is more simple and 
natural way
 >>                  prev = curr->held_locks[i];
 >>
 >
 > The latter is a type mis-match, an equivalent expression would be:
 >     &curr->held_locks[i];
 >

Yeah, sorry.

And is there reason that the statement is not
     &curr->held_locks[i];
but
     prev = curr->held_locks + i;
?

Of course, curr->held_locks + i style statement causes no problem.
But I had a little interest in the selection of style.
Do you know the reason?

Thanks,
	Hitoshi
