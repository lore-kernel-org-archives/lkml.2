Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263Ab2LOXPH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 18:15:07 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34360 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751869Ab2LOXPF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 18:15:05 -0500
MIME-Version: 1.0
In-Reply-To: <50CCF6F6.4020107@zytor.com>
References: <20121211170605.GD28827@liondog.tnic>
	<50C76F9E.4080001@zytor.com>
	<CAE9FiQXS7HK-xzQN-zy3vMwpVm6=88OsKKem2NJSvJdE2KnwiQ@mail.gmail.com>
	<50C7C859.60405@zytor.com>
	<CAE9FiQXMiFWFu=Z9NqMLo_y_1nZE5dqoJURssKBeQgz9hybWgQ@mail.gmail.com>
	<50C82ABF.3020907@zytor.com>
	<20121212133853.GC8760@liondog.tnic>
	<50C963B1.3040609@zytor.com>
	<50C96717.3020407@zytor.com>
	<20121213191317.GE31485@liondog.tnic>
	<50CA4A7A.10104@zytor.com>
	<CAE9FiQX38Ea19_v6yJO7buQcqOP9t7jp+91kbBZx-QrjB1AimA@mail.gmail.com>
	<50CB8213.9000908@zytor.com>
	<CAE9FiQWRzmG7b+fzwzJKmK4Wjp3dkvu=07Q6mT97og4wsexeSA@mail.gmail.com>
	<CAE9FiQUXyYCe5i8-hTF2rddTihdgTzh4Wg-MeVEZxjkSD2zsBA@mail.gmail.com>
	<CAE9FiQXx+4KKUu2nwOd+uKq5jmLRnomG37mYpRqBRgjBp6Ba6Q@mail.gmail.com>
	<50CCCFD0.7030704@linux.intel.com>
	<CAE9FiQXeODfyPJmrL7reW+nHe1RXEbTKnC=DqMfpkNKYywPWSw@mail.gmail.com>
	<50CCEE49.3080801@zytor.com>
	<CAE9FiQUPeK-WB163KViPPLYFgw5pUq6Rk=CvvOrWQEfjS=FBEQ@mail.gmail.com>
	<50CCF6F6.4020107@zytor.com>
Date: Sat, 15 Dec 2012 15:15:02 -0800
X-Google-Sender-Auth: F0Bmb8WfhNZ0RaO1llNiLB7DbIA
Message-ID: <CAE9FiQULAJhPUw62UVjyBakn-YcK8x0pzDgRi+FdJXS-_ekABg@mail.gmail.com>
Subject: Re: [tip:x86/microcode] x86/microcode_intel_early.c: Early update
 ucode on Intel's CPU
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, Borislav Petkov <bp@alien8.de>,
        "Yu, Fenghua" <fenghua.yu@intel.com>,
        "mingo@kernel.org" <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 15, 2012 at 2:17 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 12/15/2012 02:13 PM, Yinghai Lu wrote:
>>
>>
>> AMD system could have all mem between TOLM and TOHM all WB, and don
>> need to set them in MTRRs entries.
>>
>
> I include the TOM2 mechanism in the overall umbrella of MTRRs for this
> purpose.
>
>
>> and also your switchover change that handle cross 1G, and 512g, and it
>> is not 1G aligned.
>> for example, if kernel at 4095G+512M, it will map from 4095G+512M to
>> 4096G + 512M.
>
>
> That is for the kernel region itself (that code is actually unchanged from
> the current code), and yes, we could cap that one to _end if there are
> systems which have bugs in that area.  The dynamic page tables map 1G
> aligned at a time.

dynamic should be 2M too.

AMD system:

http://git.kernel.org/?p=linux/kernel/git/tip/tip.git;a=commitdiff;h=66520ebc2df3fe52eb4792f8101fac573b766baf

 BIOS-e820: [mem 0x0000000100000000-0x000000e037ffffff] usable
 BIOS-e820: [mem 0x000000e038000000-0x000000fcffffffff] reserved
 BIOS-e820: [mem 0x0000010000000000-0x0000011ffeffffff] usable

the hole is not 1G aligned.

or HT region is from e040000000 ?
