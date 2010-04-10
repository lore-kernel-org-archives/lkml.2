Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752249Ab0DJTUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Apr 2010 15:20:19 -0400
Received: from casper.infradead.org ([85.118.1.10]:43075 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0DJTUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Apr 2010 15:20:17 -0400
Subject: Re: [PATCH] Add "nested" field to event of lock_release
From: Peter Zijlstra <peterz@infradead.org>
To: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, h.mitake@gmail.com,
       Paul Mackerras <paulus@samba.org>,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4BC09032.1060004@dcl.info.waseda.ac.jp>
References: <1270896100-7935-1-git-send-email-mitake@dcl.info.waseda.ac.jp>
	 <1270907986.4222.2.camel@twins>  <4BC09032.1060004@dcl.info.waseda.ac.jp>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 10 Apr 2010 19:45:17 +0200
Message-ID: <1270921517.20295.3372.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-04-10 at 23:50 +0900, Hitoshi Mitake wrote:
> On 04/10/10 22:59, Peter Zijlstra wrote:
>  > On Sat, 2010-04-10 at 19:41 +0900, Hitoshi Mitake wrote:
>  >> State machine of perf lock requires "nested" field of lock_release(),
>  >> so this patch adds it to event.
>  >>
>  >> Signed-off-by: Hitoshi Mitake<mitake@dcl.info.waseda.ac.jp>
>  >> Cc: Peter Zijlstra<a.p.zijlstra@chello.nl>
>  >> Cc: Paul Mackerras<paulus@samba.org>
>  >> Cc: Arnaldo Carvalho de Melo<acme@redhat.com>
>  >> Cc: Frederic Weisbecker<fweisbec@gmail.com>
>  >
>  > The nested flag only indicates if it could be nested, not if it was
>  > actually nested. So no, this doesn't make any sense at all.
>  >
>  > (in fact, pretty much every lock_release out there has nested=1)
>  >

Just to clarify, nested=0 means the released lock needs to be at the top
of the lock stack. This means all locking needs to be perfectly
balanced:

 lock A
 lock B

 unlock A
 unlock B

Would be an invalid sequence in that scenario. I think when lockdep was
started it was thought it would be nice to be able to clean up locking
to be always perfectly balanced, but it was found quite early to be too
much, so it got relaxed to always nested=1, allowing the above sequence.



