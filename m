Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755769Ab0KCT3P (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 15:29:15 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44561 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab0KCT3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 15:29:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:message-id:user-agent:mime-version
         :content-type;
        b=qGcLl32nV5NDkrxFnEzmssjdqQA+9SIyYGp2TbF8/hOloPmPkq/IGAdtIVt6flJl1M
         QCTmW/fKgjOStfKRTxi7tsegadTUu0dFqj9WKzJG3KQCgEd2/lb3+s8FKnRLzUbXp9xv
         OGQGLDoO9LAqjVF2u1QPrLBLnJcsNoAUtgTkg=
From: Francis Moreau <francis.moro@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: perf tools miscellaneous questions
Date: Wed, 03 Nov 2010 20:28:59 +0100
Message-ID: <m2eib2uryc.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I'm trying to use perf-tools and also to learn some internals about
them. So I prefer to ask all of them in one email.

The first one is about the list of pre-defined events given by
perf-list. I couldn't find any documentations that describes these
events so excuse me if the question is stupid.

What's the difference between 'cpu-clock' and 'task-clock' event ?

What's exactly the 'cache-misses' event ? does it include both instructions
_and_ data cache misses ? both L1 and L2 caches ?

I was expecting so but the following command makes me wondering:

  $ perf stat -e cache-misses:u,l1d-loads-misses:u true
    Performance counter stats for 'true':

                763  cache-misses            
                874  L1-dcache-load-misses   

        0.000916609  seconds time elapsed

Here cache-misses < L1-dcache-load-misses.

The last question is about the source code annotation done by
perf-report. I'm using it to locate the place in my code that generates
the most data cache miss events. I can read this during a perf-report
session:

   [...]
    0.00 :           df215:       c3                      retq
    0.00 :           df216:       66 2e 0f 1f 84 00 00    nopw   %cs:0x0(%rax,%rax,1)
    0.00 :           df21d:       00 00 00
   10.00 :           df220:       48 8b 75 00             mov    0x0(%rbp),%rsi
   80.00 :           df224:       48 89 df                mov    %rbx,%rdi
    0.00 :           df227:       41 ff d4                callq  *%r12
    0.00 :           df22a:       85 c0                   test   %eax,%eax
   [...]

If I read the output correctly, most of the dcache misses are coming from
'mov %rbx, %rdi', and AFAIK this intruction can't generate any dcache
miss. What am I missing ?

Thanks.
-- 
Francis
