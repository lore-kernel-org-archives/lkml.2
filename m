Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753471Ab1GUTjq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 15:39:46 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:61784 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752419Ab1GUTjp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 15:39:45 -0400
MIME-Version: 1.0
In-Reply-To: <20110721183820.GA381@elte.hu>
References: <20110705062148.GA6056@program> <d1a1b6416d71a5062fb3b3e364f9db6b6d4ef6b2.1311258580.git.luto@mit.edu>
 <20110721170824.GA28974@tassilo.jf.intel.com> <CAObL_7HyjsPKnyDEEa0T8iTetpkd9Hq7RTBymieazzGOsXQLdA@mail.gmail.com>
 <20110721183820.GA381@elte.hu>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 21 Jul 2011 15:39:06 -0400
X-Google-Sender-Auth: Mxzb4OtxOqYCgrC1HhqJw5hmJKc
Message-ID: <CAObL_7H=wh4exBfyjJyumtOBgvAjLnewu3dp6eeyaoQi3txXwQ@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix memory leak of init_vdso_vars()
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <ak@linux.intel.com>, mingo@redhat.com, wzt <wzt.wzt@gmail.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org, tglx@linutronix.de,
        hpa@zytor.com, Michal Hocko <mhocko@suse.cz>,
        Zhitong Wang <zhitong.wangzt@alibaba-inc.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 2:38 PM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Andrew Lutomirski <luto@mit.edu> wrote:
>
>> On Thu, Jul 21, 2011 at 1:08 PM, Andi Kleen <ak@linux.intel.com> wrote:
>> > On Thu, Jul 21, 2011 at 10:33:14AM -0400, Andy Lutomirski wrote:
>> >> From: Zhitong Wang <wzt.wzt@gmail.com>
>> >>
>> >> If init_vdso_vars ran out of memory (not very likely), then it would
>> >> leak a few pages as well.
>> >>
>> >> Also rename init_vdso_vars to just init_vdso, since initializing
>> >> vvars is just about the only thing this function doesn't do.
>> >
>> > Just add a GFP_PANIC, there's no way to recover from this.
>> > Your system will not work without a vdso.
>>
>> Ingo objected to this before, although I'm not convinved.  Calling
>> init_vdso_vars more than once will cause major problems (like
>> double-patching of alternatives).  If there's too little memory for
>> it to work, then presumably there's also too little memory to start
>> init.
>>
>>  (Also, I bet that no one ever audited whether the ELF loader works
>> right if the vDSO failed to load.)
>>
>> Ingo?
>
> This assumes that the system actually needs an ELF loader - if a
> static binary is booted via a init= boot parameter it might not be
> needed.

I actually meant the kernel's loaded.  But I just looked and it appears correct.

But I think this whole thing is silly, because I can't see any good
reason that the vdso needs to allocate memory in the first place.
I'll send a patch.

--Andy
