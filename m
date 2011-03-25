Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753314Ab1CYNui (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 09:50:38 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:43091 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752549Ab1CYNug (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 09:50:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=A5hyhPs8VS3Y/uD5jDhbAKr7x/TJgjbAQxDy8nQ2/nri0TGfnC4FvLLIfrbEmlltPC
         1HAQw8cSCoHFtbqxGwFrYvugmaj+/Kw6yok7HB3rvBOLmeY1/+7S9TmTCJ9CWSoo5TNq
         awQEjevdLaUy9Q2wNXSwU+Yp/uOX3DUYiJBA0=
MIME-Version: 1.0
In-Reply-To: <1301058727.14261.174.camel@gandalf.stny.rr.com>
References: <20110323153727.GB12003@htj.dyndns.org> <20110324094119.GD12038@htj.dyndns.org>
 <20110324094151.GE12038@htj.dyndns.org> <20110325033956.GB9313@home.goodmis.org>
 <AANLkTimO3b3D+SofYFLyh8Txk+e4Ke4ToKrBiatdFghr@mail.gmail.com> <1301058727.14261.174.camel@gandalf.stny.rr.com>
From: Andrey Kuzmin <andrey.v.kuzmin@gmail.com>
Date: Fri, 25 Mar 2011 16:50:10 +0300
Message-ID: <AANLkTi=BaRFeAL1mS1Rjq_QGgcMb1rOKkvf=ig+23jvP@mail.gmail.com>
Subject: Re: [PATCH 2/2] mutex: Apply adaptive spinning on mutex_trylock()
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Tejun Heo <tj@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 4:12 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 2011-03-25 at 14:13 +0300, Andrey Kuzmin wrote:
>> Turning try_lock into indefinitely spinning one breaks its semantics,
>> so deadlock is to be expected. But what's wrong in this scenario if
>> try_lock spins a bit before giving up?
>
> Because that will cause this scenario to spin that "little longer"
> always, and introduce latencies that did not exist before. Either the
> solution does not break this scenario, or it should not go in.

Broken semantics and extra latency are two separate issues. If the
former is fixed, the latter is easily handled by introducing new
mutex_trylock_spin call that lets one either stick to existing
behavior (try/fail) or choose a new one where latency penalty is
justified by locking patterns.

Regards,
Andrey

>
> -- Steve
>
>
>
