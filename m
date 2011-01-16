Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab1APPm5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jan 2011 10:42:57 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40016 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752888Ab1APPmz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jan 2011 10:42:55 -0500
Message-ID: <4D3311FA.8020202@redhat.com>
Date: Sun, 16 Jan 2011 17:42:50 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: "Zhai, Edwin" <edwin.zhai@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "mtosatti@redhat.com" <mtosatti@redhat.com>
Subject: Re: [PATCH -v2] vmx: increase ple_gap default to 64
References: <20110103101907.2926ecca@annuminas.surriel.com>	<4D229221.8070305@intel.com> <20110104095133.62525567@annuminas.surriel.com>
In-Reply-To: <20110104095133.62525567@annuminas.surriel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/2011 04:51 PM, Rik van Riel wrote:
> On some CPUs, a ple_gap of 41 is simply insufficient to ever trigger
> PLE exits, even with the minimalistic PLE test from kvm-unit-tests.
>
> http://git.kernel.org/?p=virt/kvm/kvm-unit-tests.git;a=commitdiff;h=eda71b28fa122203e316483b35f37aaacd42f545
>
> For example, the Xeon X5670 CPU needs a ple_gap of at least 48 in
> order to get pause loop exits:
>
> # modprobe kvm_intel ple_gap=47
> # taskset 1 /usr/local/bin/qemu-system-x86_64 -device testdev,chardev=log -chardev stdio,id=log -kernel x86/vmexit.flat -append ple-round-robin -smp 2
> VNC server running on `::1:5900'
> enabling apic
> enabling apic
> ple-round-robin 58298446
> # rmmod kvm_intel
> # modprobe kvm_intel ple_gap=48
> # taskset 1 /usr/local/bin/qemu-system-x86_64 -device testdev,chardev=log -chardev stdio,id=log -kernel x86/vmexit.flat -append ple-round-robin -smp 2
> VNC server running on `::1:5900'
> enabling apic
> enabling apic
> ple-round-robin 36616
>
> Increase the ple_gap to 128 to be on the safe side.  Is this enough
> for a CPU with HT that has a busy sibling thread, or should it be
> even larger?   On the X5670, loading up the sibling thread with an
> infinite loop does not seem to increase the required ple_gap.
>

Applied, thanks.

-- 
error compiling committee.c: too many arguments to function

