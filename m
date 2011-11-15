Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755694Ab1KONrF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 08:47:05 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64862 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755459Ab1KONrD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 08:47:03 -0500
MIME-Version: 1.0
In-Reply-To: <4EC21F67.10905@redhat.com>
References: <1318376345.2050.20.camel@boudreau>
	<j9r5m5$b18$1@dough.gmane.org>
	<1321296650.2066.17.camel@boudreau>
	<4EC21F67.10905@redhat.com>
Date: Tue, 15 Nov 2011 21:47:02 +0800
Message-ID: <CAM_iQpUCE5fB0KGcmmXkpqVnasqpx0cSt01qhXO1CNVRJcSWeA@mail.gmail.com>
Subject: Re: Crash during vmcore_init
From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
To: Dave Young <dyoung@redhat.com>
Cc: tim@edgecast.com, kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        tj@kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 15, 2011 at 4:14 PM, Dave Young <dyoung@redhat.com> wrote:
>> On Mon, 2011-11-14 at 13:39 +0000, WANG Cong wrote:
>>> On Tue, 11 Oct 2011 16:39:05 -0700, Tim Hartrick wrote:
>>>
>>>> Kexec,
>>>>
>>>> I have been experiencing the crash below on Ubuntu 10.04 running
>>>> 2.6.32-34-server and 2.6.38-8-server as the crashkernel on X86_64. The
>>>> tools are:
>>>>
>>>> kexec-tools 1:2.0.2-1ubuntu3
>>>> makedumpfile        1.3.7-2
>>>> kdump-tools 1.3.7-2
>>>>
>>>> I would be interested to know if this is a known problem and if so
>>>> whether or not there is a patch in the pipeline to correct the problem.
>>>>
>>>> I will be happy to provide any other details that are required including
>>>> debug builds if necessary.
>>> ....
>>>>
>>>> [    1.322100] ioremap: invalid physical address db74000000000000 [
>
>
> Searching db74000000000000 got several similar cases of this, all are
> about per cpu invalid crash_notes address, is this one more?
>

Why it is per cpu crash_note?

I bet Tim is using i386 machine, and on i386 we have,

kexec/arch/i386/crashdump-x86.c

static int get_crash_notes(int cpu, uint64_t *addr, uint64_t *len)
{
        char crash_notes[PATH_MAX];
        char line[MAX_LINE];
        FILE *fp;
        unsigned long vaddr;
        int count;

        sprintf(crash_notes, "/sys/kernel/crash_notes");
        fp = fopen(crash_notes, "r");
        if (fp) {
               <...>
        } else
                return get_crash_notes_per_cpu(cpu, addr, len);
}

As long as we have .notes section, /sys/kernel/crash_notes exists.
So I see no reason that is per cpu notes stuff.
