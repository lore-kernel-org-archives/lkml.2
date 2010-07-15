Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935700Ab0GPG5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 02:57:20 -0400
Received: from terminus.zytor.com ([198.137.202.10]:39777 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935636Ab0GPG5S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 02:57:18 -0400
Message-ID: <4C3F8418.5020803@zytor.com>
Date: Thu, 15 Jul 2010 23:56:40 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-3.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: Borislav Petkov <borislav.petkov@amd.com>
CC: Michal Schmidt <mschmidt@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        Shaohua Li <shaohua.li@intel.com>, Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 1/2] x86: fix keeping track of AMD C1E
References: <20100713185816.2866.17837.stgit@localhost.localdomain> <20100713185957.2866.50995.stgit@localhost.localdomain> <20100714160704.GA10473@kryptos.osrc.amd.com> <20100714232201.00433aa9@hammerfall> <20100714233102.0f64614b@hammerfall> <4C3FDF43.6030203@zytor.com> <20100716063952.GB27546@aftab>
In-Reply-To: <20100716063952.GB27546@aftab>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 08:39 AM, Borislav Petkov wrote:
> From: "H. Peter Anvin"<hpa@zytor.com>
> Date: Fri, Jul 16, 2010 at 12:25:39AM -0400
>
>> On 07/14/2010 02:31 PM, Michal Schmidt wrote:
>>>
>>> This suggests that another way to fix my problem would be this (tested):
>>>
>>
>> This is a change of semantics from an AND to an OR across CPUs...
>
> You mean the c1e_detected variable and the CPUID flag, right? Well,
> frankly and if I'm not missing anything, we actually only need to track
> when either bits [27,28] get set in that MSR - MSR_K8_INT_PENDING_MSG -
> in order to do timer broadcast.
>
> And strictly speaking, we don't need a variable for that at all (nor a
> synthetic CPUID flag, for that matter) - we can simply read the MSR as
> much as we'd like after we've detected that this CPU supports C1E.
>
> But having the value cached is faster and doesn't enlarge checking
> code in acpi_processor_cstate_check().
>
> I think the reason for adding the syntetic cpuid flag is only to
> communicate to the ACPI processor module that we don't support deeper
> C-states on a C1E machine, see a8d6829044901a67732904be5f1eacdf8539604f.
> So we don't strictly need it and we can only export c1e_detected to the
> rest for simplicity.
>

No, the difference between using a separate variable and the CPU feature 
bit is that CPU feature bit is ANDed across all CPUs, whereas this 
variable is set if it is set on *any* CPU.

	-hpa

