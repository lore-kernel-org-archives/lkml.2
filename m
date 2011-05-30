Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754823Ab1E3Xyh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 19:54:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:57067 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab1E3Xyf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 19:54:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=wdr1HEtiQlvxQmFR37XpmySIy4UP93IbKDK10zff/WPgWH2zTzCg1VllfT7mP0BOfV
         e2RGVDVKtVJvIoAlUj4Q==
MIME-Version: 1.0
In-Reply-To: <4DE337FB.3000804@jp.fujitsu.com>
References: <1306439537-23706-1-git-send-email-vnagarnaik@google.com>
 <1306519125-19301-1-git-send-email-vnagarnaik@google.com> <alpine.DEB.2.00.1105271618470.9445@chino.kir.corp.google.com>
 <BANLkTimfdkpY=9pgEmBZwE3ezCmooEtQTA@mail.gmail.com> <1306547453.3857.44.camel@gandalf.stny.rr.com>
 <4DE337FB.3000804@jp.fujitsu.com>
From: Vaibhav Nagarnaik <vnagarnaik@google.com>
Date: Mon, 30 May 2011 16:54:01 -0700
Message-ID: <BANLkTimSecAZsqDbMDDw63xNkfnqGSDmUA@mail.gmail.com>
Subject: Re: [PATCH] trace: Set oom_score_adj to maximum for ring buffer
 allocating process
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, David Rientjes <rientjes@google.com>,
        Ingo Molnar <mingo@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Michael Rubin <mrubin@google.com>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, May 29, 2011 at 11:23 PM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
> (2011/05/28 10:50), Steven Rostedt wrote:
>> On Fri, 2011-05-27 at 17:44 -0700, Vaibhav Nagarnaik wrote:
>>
>>> That said, I am open to changing it if Steven and you think using
>>> oom_killer_disabled is a better solution.
>>
>> My biggest concern is that we are setting policy in the kernel. If you
>> are concerned about this, why not just have the process that is going to
>> increase the size of the ring buffer adjust its own oom policy
>> with /proc/<pid>/oom_score_adj ? Only a privilege process can increase
>> the size of the ring buffer so it's not like we are worried about any
>> normal user task upping the ring buffer to kill other processes.
>
> I like Steven's approach.
>
> Because even if we apply Vaibhav's patch, we still have a oom issue.
> because when oom-killer killed echo commands, it doesn't shrink ring
> buffer. it only just die. So, the kernel is still under extreme memory
> shortage. Any admins operation may invoke next oom-killer.

The ring buffer allocation is done synchronously with the echo
command. When a process is picked by the OOM killer, it has a fatal
signal pending. Any further allocations by the process in that
scenario will return with a failure. The ring buffer allocation code
can handle this scenario very well and give up all the previously
allocated memory.



Vaibhav Nagarnaik
