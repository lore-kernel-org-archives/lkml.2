Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934438Ab0J1UML (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 16:12:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:2202 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934382Ab0J1UME (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 16:12:04 -0400
Date: Thu, 28 Oct 2010 16:11:13 -0400
From: Jason Baron <jbaron@redhat.com>
To: David Daney <ddaney@caviumnetworks.com>
Cc: rth@redhat.com, "H. Peter Anvin" <hpa@zytor.com>, rostedt@goodmis.org,
        mingo@elte.hu, mathieu.desnoyers@polymtl.ca, tglx@linutronix.de,
        andi@firstfloor.org, roland@redhat.com,
        masami.hiramatsu.pt@hitachi.com, fweisbec@gmail.com, avi@redhat.com,
        davem@davemloft.net, vgoyal@redhat.com, sam@ravnborg.org,
        tony@bakeyournoodle.com, dsd@laptop.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] jump label: disable due to compiler bug
Message-ID: <20101028201112.GA4792@redhat.com>
References: <cover.1288212485.git.jbaron@redhat.com> <2d1b1d5d2b3930e1acb063cefffbcb2faf049854.1288212486.git.jbaron@redhat.com> <ce4ff595-f9d1-4c17-b68e-82739b07ad3e@email.android.com> <20101028141757.GA2875@redhat.com> <4CC9C724.3020004@caviumnetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC9C724.3020004@caviumnetworks.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 11:55:32AM -0700, David Daney wrote:
> On 10/28/2010 07:17 AM, Jason Baron wrote:
>> On Wed, Oct 27, 2010 at 03:21:55PM -0700, H. Peter Anvin wrote:
>>> Could you detail the bug, please?  static_cpu_has() also uses asm goto.
>>>
>>
>> It seems that gcc can leave the stack in an inconsistent state.
>>
>> I only saw this in the 'jmp' enabled case, I'm not sure if it can occur in the
>> straight-line code path as well.
>>
>
> Jason,
>
> Were you going to file a GCC bug on this issue?  Someone should.
>

I will file one. I did inform Richard Henderson about the bug, and he
has already developed a fix. I'm not sure yet, when the fix will be
included in gcc.

Also, Richard said that -maccumulate-outgoing-args flag avoids this bug.
That flag is already always set for x86_64 (see arch/x86/Makefile), but not
for x86. This is also consistent with our testing. We have not seen the
crash on x86_64, only x86.

Thus, I'm going to propose a patch, which makes jump label conditional
on x86_64 for now (adding -maccumulate-outgoing-args to x86 increases
the text size, so I'm not proposing adding the flag there).

I'm not sure whether other architectures are exposed to this bug or not.
I'm trying to find out.

thanks,

-Jason
