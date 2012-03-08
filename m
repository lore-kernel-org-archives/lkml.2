Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753140Ab2CHB3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 20:29:23 -0500
Received: from serv2.oss.ntt.co.jp ([222.151.198.100]:36941 "EHLO
	serv2.oss.ntt.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2CHB3E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 20:29:04 -0500
Message-ID: <4F580B5F.5070304@oss.ntt.co.jp>
Date: Thu, 08 Mar 2012 10:29:03 +0900
From: =?ISO-8859-1?Q?Fernando_Luis_V=E1zquez_Cao?= 
	<fernando@oss.ntt.co.jp>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Yinghai Lu <yinghai@kernel.org>
CC: Vivek Goyal <vgoyal@redhat.com>, Don Zickus <dzickus@redhat.com>,
        linux-tip-commits@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, mingo@redhat.com, tglx@linutronix.de,
        "Eric W. Biederman" <ebiederm@xmission.com>, hpa@zytor.com,
        mingo@elte.hu, torvalds@linux-foundation.org,
        akpm@linux-foundation.org
Subject: Re: [tip:x86/debug] x86/kdump: No need to disable ioapic/ lapic in
 crash path
References: <20120216215603.GH9751@redhat.com> <m1y5s2ku36.fsf@fess.ebiederm.org> <m1fwe9bpk2.fsf@fess.ebiederm.org> <20120217195430.GO9751@redhat.com> <m1y5s07rn3.fsf@fess.ebiederm.org> <20120220151419.GU9751@redhat.com> <m1obss39a4.fsf@fess.ebiederm.org> <20120221135934.GF26998@redhat.com> <m1ipip6xe8.fsf@fess.ebiederm.org> <4F573E1C.2060909@oss.ntt.co.jp> <20120307155018.GA13430@redhat.com> <CAE9FiQXLMzVLH7MW2OXFCpBU+5RRN-EnshGYhkj_3sO36c1Mkg@mail.gmail.com>
In-Reply-To: <CAE9FiQXLMzVLH7MW2OXFCpBU+5RRN-EnshGYhkj_3sO36c1Mkg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/08/2012 03:27 AM, Yinghai Lu wrote:

> 2012/3/7 Vivek Goyal<vgoyal@redhat.com>:
>> On Wed, Mar 07, 2012 at 07:53:16PM +0900, Fernando Luis Vázquez Cao wrote:
>>> We run into the same NMI problems and wrote some patches that tackle
>>> the kernel boot side of things. They have been extensively tested using
>>> qemu-kvm and things seem to be working as expected (after receiving an
>>> early NMI the kernel continues without problem; after the iret there is no
>>> stack corruption or register corruption).
>> What happens if NMI happens while we are still in purgatory code?
The system triple faults. As Eric said we need to fix both the reboot path
to kdump and kdump kernel's boot code. The two patches I sent address the
later. I sent these first because I had time to test them properly, fix a
real issue and can be applied independently.



> yes, you are right. that is too late to set that in arch/x86/kernel/head64.c
Of course, the reboot path needs to be fixed too. Now that I solved some
problems I was having with my qemu-kvm test environment (NMIs injected
through the qemu monitor only get devivered to the BSP, etc), I will make
sure that the code I wrote for it works as expected.

In the meantime, I would appreciate it if you could review/ack yesterday's
patches.

Thanks,
Fernando

