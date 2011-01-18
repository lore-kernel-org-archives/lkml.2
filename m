Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752849Ab1ARVws (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:52:48 -0500
Received: from smtp-out.google.com ([216.239.44.51]:41648 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751733Ab1ARVwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:52:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=Ee0J7JMnnv5Nh5WPYVpo64r9MKgl/jIZnauWjYJ65AvAFK27b+2jxh+YsiSjV5Nr8T
         HP/vmLIx1YzL/i/M4Vgw==
MIME-Version: 1.0
In-Reply-To: <1295273644.30950.121.camel@laptop>
References: <20110115015749.692623529@google.com> <20110115015817.160235155@google.com>
 <1295273644.30950.121.camel@laptop>
From: Paul Turner <pjt@google.com>
Date: Tue, 18 Jan 2011 13:52:14 -0800
Message-ID: <AANLkTimUzdGYjWVu9KpvJZuaSq+NFW40GULZGcDSkJRt@mail.gmail.com>
Subject: Re: [wake_afine fixes/improvements 2/3] sched: clean up task_hot()
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@kernel.dk>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 17, 2011 at 6:14 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Fri, 2011-01-14 at 17:57 -0800, Paul Turner wrote:
>> plain text document attachment (no_hot_sd.patch)
>> We no longer compute per-domain migration costs or have use for task_hot()
>> external to the fair scheduling class.
>
> Ok, so this a mostly a pure code move (aside from removing the unused sd
> argument). I do seem to remember that various folks played around with
> bringing the per sd cache refill cost back.. any conclusion on that?
>
> (not really a big point, we can easily add the argument back when
> needed)
>

Yeah this one's solely housekeeping.

I think there probably is value in a relative notion of what it means
to be hot that's based on the domain distance (especially with the
slightly more exotic topologies we're starting to see), but until some
framework exists I figured I might as well clean it up while I was
there.
