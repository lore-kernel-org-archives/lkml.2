Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761301Ab2D0TPQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 15:15:16 -0400
Received: from mga10.intel.com ([192.55.52.92]:52314 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760475Ab2D0TPL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 15:15:11 -0400
MIME-Version: 1.0
In-Reply-To: <CALLzPKajCrfPz-V=9yftoq=FGQuMYvzCwFMKDcZpm+=QPnJJ1g@mail.gmail.com>
References: <1334865448.2429.35.camel@falcor>
	<20120420004303.GB6871@ZenIV.linux.org.uk>
	<alpine.LSU.2.00.1204201133340.1450@eggly.anvils>
	<20120420190418.GK6871@ZenIV.linux.org.uk>
	<CA+55aFwVJ7SFbb3ZVxnon-Vv19pbNvUN4oungH479q7DUjBtwQ@mail.gmail.com>
	<20120420195833.GM6871@ZenIV.linux.org.uk>
	<CA+55aFzaC8YfN_q1TxPbNgpD7AnoAVac2Bqa+ysEji3u7ZQ18A@mail.gmail.com>
	<20120420221315.GN6871@ZenIV.linux.org.uk>
	<CA+55aFzEwsW1kdLo2hpgW2PUCRkyaRxS_KB40iwmuk1FDgV+cg@mail.gmail.com>
	<CALLzPKarZY11htkukZPi+7ny5r=au9hMdKBOy20wAdFjSBOyjA@mail.gmail.com>
	<20120427173417.GK6871@ZenIV.linux.org.uk>
	<CALLzPKajCrfPz-V=9yftoq=FGQuMYvzCwFMKDcZpm+=QPnJJ1g@mail.gmail.com>
Date: Fri, 27 Apr 2012 22:15:10 +0300
Message-ID: <CALLzPKZsWWZAx5WHGm5Eafwb6chJvOFKDnaneYvD3FJ=-Q_fUg@mail.gmail.com>
Subject: Re: [RFC] situation with fput() locking (was Re: [PULL REQUEST] :
 ima-appraisal patches)
From: "Kasatkin, Dmitry" <dmitry.kasatkin@intel.com>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, linux-fsdevel@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Safford <safford@linux.vnet.ibm.com>,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 9:52 PM, Kasatkin, Dmitry
<dmitry.kasatkin@intel.com> wrote:
> On Fri, Apr 27, 2012 at 8:34 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Fri, Apr 27, 2012 at 10:35:25AM +0300, Kasatkin, Dmitry wrote:
>>
>>> But have you seen the proposed patch for __fput()?
>>> [PATCH v4 10/12] ima: defer calling __fput()
>>>
>>> It defers only of course the last AND mmap_sem is locked AND open for write.
>>>
>>>       if (current->mm && rwsem_is_locked(&current->mm->mmap_sem)) {
>>>               if (ima_defer_fput(file) == 0)
>>>                       return;
>>>       }
>>>
>>> Just 5 out of ~100,000 mmap_sem held fput() calls were deferred.
>>
>> Let me get it straight.
>>        a) You still ignore all the problems with that described in the
>> posting right in the beginning of this thread.
>>        b) You ignore the problems with semantics changes from user-visible
>> delays of fput() past the return from syscall (described in Linus' posting
>> upthread - they apply to this "solution" as well).
>>        c) You seem to consider the fact that this path will be exercised
>> very rarely, thus making any races on it damn hard to reproduce and debug
>> as a good thing.
>>
>> And as for the sentiment expressed in the beginning of your posting (that
>> smaller patch size is worth more than clean locking rules, maintainability
>> of resulting kernel, etc.)...  I'm sorry, but you guys need to decide
>> what IMA is.  If it's a first-class part of the kernel, you have your
>> priorities backwards...
>
> Hello,
>
> I do not ignore anything.
> I said that we were thinking about solution to get the list of file to
> fput them after mmap unlock.
> And I do understand the issues discussed.
> I just wanted to know more opinions on proposed patch.
>
> - Dmitry

For sure we are happy to see the discussion about the problem. Thanks
for your attention to it.
And our target to solve it in best possible way.
So let's agree the solution and we will be happy to implement the patch.

- Dmitry
