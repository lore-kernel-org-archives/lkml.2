Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932157Ab1FHBFK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jun 2011 21:05:10 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:54963 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab1FHBFJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jun 2011 21:05:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=chromium.org; s=google;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BxeYKZAD326vnuIvDES/x9Gao6Bi4ulPP5jnmCAyO8p/1Ruf93rDI1x9EuZrPt0/jA
         tKlCJy32lbSCMg3zJaMSi2fvmxO4IOXyzQTn5x9Epzpsjs8u5kfMTTAEF8ufSj1bjOu5
         Sudr5HgYSZZjdBer4QGedTz7gaCzNvUdRH1tI=
MIME-Version: 1.0
In-Reply-To: <20110607235613.GA21645@linux.vnet.ibm.com>
References: <1307133252-23259-1-git-send-email-wad@chromium.org>
	<1307133252-23259-4-git-send-email-wad@chromium.org>
	<20110607235613.GA21645@linux.vnet.ibm.com>
Date: Tue, 7 Jun 2011 20:05:07 -0500
Message-ID: <BANLkTikSFUqtvw8VZa2oXWOZL3tUnt+UEg@mail.gmail.com>
Subject: Re: [PATCH v4 04/13] seccomp_filter: add process state reporting
From: Will Drewry <wad@chromium.org>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, kees.cook@canonical.com,
        torvalds@linux-foundation.org, tglx@linutronix.de, mingo@elte.hu,
        rostedt@goodmis.org, jmorris@namei.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 7, 2011 at 6:56 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Jun 03, 2011 at 03:34:03PM -0500, Will Drewry wrote:
>> Adds seccomp and seccomp_filter status reporting to proc.
>> /proc/<pid>/seccomp_filter provides the current seccomp mode
>> and the list of allowed or dynamically filtered system calls.
>>
>> v4: move from rcu guard to mutex guard
>
> Just in case the mutex guard turns into a bottleneck...  Replacing
> your earlier racy rcu_assign_pointer() with xchg() would allow
> the "winner" to free up the "loser"'s structure.
>
> Of course, if the mutex guard works well for you, why bother?

In my tests so far, the overhead has been quite low (since the fast
path is usually taken).  If it turns into a pain point for any reason
(increased contention, arch-specific pain, whatever), I'll certainly
look at replacing it with an xchg().  I opted for the simplest
approach for now in hopes I wouldn't do it wrong yet-again.

Thanks!
will
