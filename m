Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752235Ab1BDUFr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 15:05:47 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:50478 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab1BDUFq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 15:05:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QgppNKOtSj43xFCB4Wf8QwBM+f6G0vHZgxJyTNoEzE2/r4W8ImD4LLMdYil/fxCuW4
         GKAlLfYWiHqHxsawk19J1si9RSM4ZtQayu6M0jY50jvgpR9tyYd+ZOBrFxNlUVZbEZG2
         sYvCSD8hhA9Uf8NpKvBBiFJvk+ffroN8kccsQ=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1102041326330.4611@router.home>
References: <AANLkTinbnrAMMKVZSBQChtZjUyw6Yk1otp8xmqJNvWm3@mail.gmail.com>
	<alpine.DEB.2.00.1102041326330.4611@router.home>
Date: Fri, 4 Feb 2011 15:05:45 -0500
Message-ID: <AANLkTimZTbWt19hg8XWxL+Q5TBFY0P8wF-TfFDLYjBCw@mail.gmail.com>
Subject: Re: Thread Affinity structure
From: Sri Ram Vemulpali <sri.ram.gmu06@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Kernel-newbies <kernelnewbies@nl.linux.org>,
        linux-kernel-mail <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Christoph,

  Thanks for response. Can you please explain in little bit elaborate
what do you mean

 "The value returned  from a call to gettid(2) can be passed in the argument
 pid.  Specifying pid as 0 will set the attribute for the calling thread,
 and passing the value returned from a call to getpid(2) will set the
 attribute for the main thread of the thread group."

To whom I should pass the id. I did not understood.

Thanks,
Sri.

On Fri, Feb 4, 2011 at 2:29 PM, Christoph Lameter <cl@linux.com> wrote:
> On Fri, 4 Feb 2011, Sri Ram Vemulpali wrote:
>
>>     I have doubt regarding how the thread affinity (to processor) is
>> defined in a process (task). If there is only single thread in a
>> process, then when process calls itself on binding to a core, will let
>> run on that core forever. But, what if there are multiple threads, in
>> a process (task). If the main thread calls set affinity to a core, is
>> it going to get inherited to all other threads, or just the calling
>> thread in a task. What happens when forked a process with threads that
>> has affinity to a core. Please can anyone point me to the literature
>> on this. Thanks in advance.
>
> See "man sched_setaffinity"
>
> "
> The affinity mask is actually a per-thread attribute that can be
> adjusted independently for each of the threads in a thread group.  The
> value returned  from a call to gettid(2) can be passed in the argument
> pid.  Specifying pid as 0 will set the attribute for the calling thread,
> and passing the value returned from a call to getpid(2) will set the
> attribute for the main thread of the thread group.  (If you  are  using
> the  POSIX threads API, then use pthread_setaffinity_np(3) instead of
> sched_setaffinity().)
> "
>
>
>
> The setting of the affinity occurs for the running thread if pid == 0.
> Affinity masks are inherited across forks.
>
>
>
>
>
>



-- 
Regards,
Sri.
