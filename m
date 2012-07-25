Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab2GYLU1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 07:20:27 -0400
Received: from db3ehsobe006.messaging.microsoft.com ([213.199.154.144]:40792
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756459Ab2GYLUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 07:20:25 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-SpamScore: -4
X-BigFish: VPS-4(zzbb2dI98dI9371I1432Izz1202hzzz2dh668h839hd25he5bhf0ah107ah)
X-WSS-ID: 0M7PRHS-01-4OB-02
X-M-MSG: 
Message-ID: <500FD5C3.1070100@amd.com>
Date: Wed, 25 Jul 2012 13:17:23 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Vladimir Davydov <vdavydov@parallels.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Borislav Petkov <bp@amd64.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Andi Kleen <ak@linux.intel.com>,
        Borislav Petkov <borislav.petkov@amd.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Pavel Emelianov <xemul@parallels.com>,
        Konstantin Khorenko <khorenko@parallels.com>,
        Daniel Lezcano <daniel.lezcano@linaro.org>
Subject: Re: [PATCH 2/2] cpu: intel, amd: mask cleared cpuid features
References: <73e09fb43e37de851acda10dc64bc495a5b68357.1342801662.git.vdavydov@parallels.com> <dd185bfa60b6478e7eb1bce455c9d082ec884abe.1342801662.git.vdavydov@parallels.com> <20120721103715.GA3632@aftab.osrc.amd.com>	<500E4960.8040307@parallels.com> <500E5951.5020900@amd.com>	<500E5CDF.5000504@parallels.com> <20120724101041.GA24739@aftab.osrc.amd.com>	<500E8280.6050905@parallels.com> <500E9664.9030306@amd.com> <20120724134405.7a42b5bd@pyramind.ukuu.org.uk> <500FCB02.2080603@parallels.com> <500FD158.2070503@amd.com> <500FD24B.4040703@parallels.com>
In-Reply-To: <500FD24B.4040703@parallels.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/25/2012 01:02 PM, Vladimir Davydov wrote:
> On 07/25/2012 02:58 PM, Andre Przywara wrote:
>> On 07/25/2012 12:31 PM, Vladimir Davydov wrote:
>>> On 07/24/2012 04:44 PM, Alan Cox wrote:
>>>>> This approach does not need any kernel support (except for the
>>>>> /proc/cpuinfo filtering). Does this address the issues you have?
>>>> You can do the /proc/cpuinfo filtering in user space too
>>>>
>>> How?
>> I wanted to write the same reply yesterday, but followed the hint in
>> Alan's previous mail:
>> # mount --bind /dev/shm/faked_cpuinfo /somepath/proc/cpuinfo
>>
>> I checked it, it works even with chroots and is not visible from within.
>
> If CPUs go online/offline?

Do you support CPU offlining from within the guest? My OpenVZ guest only 
has /sys/class and nothing else, so I cannot offline any CPU.

So you setup a "hand-crafted" cpuinfo for the guest and this should stay 
valid for the whole guest's runtime, right?

And since it is a dumped file, "host" CPU off/onlining does not affect 
it. Or do you want to propagate this to the guests?
(Sorry, but my thinking is more Xen/KVM oriented, where guests can only 
do most things if they are explicitly allowed to do it and separation 
between guests and host is much stricter).


Regards,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany

