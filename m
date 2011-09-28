Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754083Ab1I1NTB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 09:19:01 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:44710 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818Ab1I1NTA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 09:19:00 -0400
Subject: Re: [PATCH v5]: Improve performance of LZO hibernation
Date: Wed, 28 Sep 2011 23:18:55 +1000
From: "Bojan Smojver" <bojan@rexursive.com>
To: penberg@cs.helsinki.fi
Cc: linux-kernel@vger.kernel.org, rjw@sisk.pl
MIME-Version: 1.0
X-Mailer: LCG ProfiMail 3.48
Message-ID: <7978609203.1001719135@rexursive.com>
References: <1317183650.2067.10.camel@shrek.rexursive.com> <CAOJsxLGam5htmwtTZOuPka02+CZ1Fkv1b+SuYMJ8x9VRntFzRQ@mail.gmail.com> <1317194947.1998.18.camel@shrek.rexursive.com> <CAOJsxLFGpU53AQRw-nKsz_Lz_QMDP+RDUD5J3bYzbAA_+ngaAA@mail.gmail.com> <1317196456.1998.24.camel@shrek.rexursive.com> <CAOJsxLGUmV=5+fOJShbfc+kELcPS9pnE+DkNY9+TBS33VmzRFg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------- Original message -------
> From: Pekka Enberg

> On Wed, Sep 28, 2011 at 10:54 AM, Bojan Smojver <bojan@rexursive.com> 
> wrote:
>> I'm guessing here that you mean that parts of the kernel other than
>> hibernation code itself can do this (i.e. set the flag for the thread to
>> stop, so kthread_should_stop() returns true). Correct?
>
> Sorry, I'm not familiar this code. However, if you're checking for the
> condition..
>
> [snip]
>
>> Right now, this would result in - well I don't know what exactly - most
>> likely corrupted data on disk or on memory.
>
> ...this is not really an option for handling it.

Yeah, I changed the code in v7 to set the error code when this happens. So, 
if the thread exits because something sets should_exit flag, error code 
will terminate hibernation/thaw.

Now that I think about it, another problem may come up if the thread has 
been shut down by something else just as it's supposed to be cleaned up at 
end of the run. I can introduce a mutex in each structure and then 
set/check whether thread pointer is NULL before reping the thread.

V8, here we come...

--
Bojan 
