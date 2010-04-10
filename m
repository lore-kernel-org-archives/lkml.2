Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab0DJOua (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 10:50:30 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:62329 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751743Ab0DJOu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 10:50:29 -0400
Message-ID: <4BC09032.1060004@dcl.info.waseda.ac.jp>
Date: Sat, 10 Apr 2010 23:50:26 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.7) Gecko/20100111 Lightning/1.0b1 Thunderbird/3.0.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: mingo@elte.hu, linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] Add "nested" field to event of lock_release
References: <1270896100-7935-1-git-send-email-mitake@dcl.info.waseda.ac.jp> <1270907986.4222.2.camel@twins>
In-Reply-To: <1270907986.4222.2.camel@twins>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/10 22:59, Peter Zijlstra wrote:
 > On Sat, 2010-04-10 at 19:41 +0900, Hitoshi Mitake wrote:
 >> State machine of perf lock requires "nested" field of lock_release(),
 >> so this patch adds it to event.
 >>
 >> Signed-off-by: Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>
 >> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
 >> Cc: Paul Mackerras<paulus@samba.org>
 >> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
 >> Cc: Frederic Weisbecker<fweisbec@gmail.com>
 >
 > The nested flag only indicates if it could be nested, not if it was
 > actually nested. So no, this doesn't make any sense at all.
 >
 > (in fact, pretty much every lock_release out there has nested=1)
 >

Ah, sorry, I misunderstood.
When looked at rwlock_release(), I judged that nested is required,
because double or more read_lock() is allowed.

Thanks for your correction :)
        Hitoshi
