Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754987Ab1C1Xqr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 19:46:47 -0400
Received: from smtp-out.google.com ([216.239.44.51]:45672 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752746Ab1C1Xqq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 19:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QbQ/Az/2YAIfmkYoUXwEyvxXhOd4u3OK2Lb/YZ8D5VOTACrP1oUclSQ5/wuqbKcsLb
         I8inaCOhiwTDupUOtEoA==
MIME-Version: 1.0
In-Reply-To: <AANLkTi=ng9vwoMJ=tseWwTsXMf9XZkMKUexcpEmQ45M_@mail.gmail.com>
References: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
	<20110324105222.GA2625@barrios-desktop>
	<20110325090411.56c5e5b2.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTi=f3gu7-8uNiT4qz6s=BOhto5s=7g@mail.gmail.com>
	<20110325115453.82a9736d.kamezawa.hiroyu@jp.fujitsu.com>
	<BANLkTim3fFe3VzvaWRwzaCT6aRd-yeyfiQ@mail.gmail.com>
	<20110326023452.GA8140@google.com>
	<AANLkTi=ng9vwoMJ=tseWwTsXMf9XZkMKUexcpEmQ45M_@mail.gmail.com>
Date: Mon, 28 Mar 2011 16:46:42 -0700
Message-ID: <BANLkTi=BJrqsTTAuxz-ZDeioCZ=Sc6hbSw@mail.gmail.com>
Subject: Re: [PATCH 0/4] forkbomb killer
From: Michel Lespinasse <walken@google.com>
To: Hiroyuki Kamezawa <kamezawa.hiroyuki@gmail.com>
Cc: Minchan Kim <minchan.kim@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Rik van Riel <riel@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 26, 2011 at 1:48 AM, Hiroyuki Kamezawa
<kamezawa.hiroyuki@gmail.com> wrote:
> 2011/3/26 Michel Lespinasse <walken@google.com>:
>> I haven't heard of fork bombs being an issue for us (and it's not been
>> for me on my desktop, either).
>>
>> Also, I want to point out that there is a classical userspace solution
>> for this, as implemented by killall5 for example. One can do
>> kill(-1, SIGSTOP) to stop all processes that they can send
>> signals to (except for init and itself). Target processes
>> can never catch or ignore the SIGSTOP. This stops the fork bomb
>> from causing further damage. Then, one can look at the process
>> tree and do whatever is appropriate - including killing by uid,
>> by cgroup or whatever policies one wants to implement in userspace.
>> Finally, the remaining processes can be restarted using SIGCONT.
>>
>
> Can that solution work even under OOM situation without new login/commands ?
> Please show us your solution, how to avoid Andrey's Bomb  with your way.
> Then, we can add Documentation, at least. Or you can show us your tool.

To be clear, I don't have a full solution. I just think that the
problem is approachable from userspace by freezing processes and then
sorting them out. The killall5 utility is an example of that, though
you would possibly want to add more smarts to it. If we want to
include a kernel solution, I do like the simplicity of Minchan's
proposal, too. But, I don't have a strong opinion on this matter, so
feel free to ignore me if this is not useful feedback.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
