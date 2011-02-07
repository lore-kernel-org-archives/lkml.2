Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754482Ab1BGCfq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Feb 2011 21:35:46 -0500
Received: from out01.mta.xmission.com ([166.70.13.231]:47665 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754373Ab1BGCfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Feb 2011 21:35:44 -0500
From: ebiederm@xmission.com (Eric W. Biederman)
To: Rob Landley <rlandley@parallels.com>
Cc: Simon Horman <horms@verge.net.au>,
        "Ahmed S. Darwish" <darwish.07@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>, Vivek Goyal <vgoyal@redhat.com>,
        Haren Myneni <hbabu@us.ibm.com>, <kexec@lists.infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, <linux-doc@vger.kernel.org>
References: <20110206154108.GA16542@laptop>
	<20110206215733.GB26233@verge.net.au> <4D4F5810.3070300@parallels.com>
Date: Sun, 06 Feb 2011 18:35:34 -0800
In-Reply-To: <4D4F5810.3070300@parallels.com> (Rob Landley's message of "Sun,
	6 Feb 2011 20:25:20 -0600")
Message-ID: <m1lj1sbmh5.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX18ObaRcF1GFREUWl9YhZm0/zN8liYBmMRc=
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa02 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_14 obfuscated drug references
	*  0.5 XM_Body_Dirty_Words Contains a dirty word
	*  0.0 T_TooManySym_01 4+ unique symbols in subject
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa02 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Rob Landley <rlandley@parallels.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH -next] Documentation: Improve crashkernel= description
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rob Landley <rlandley@parallels.com> writes:

2> On 02/06/2011 03:57 PM, Simon Horman wrote:
>> On Sun, Feb 06, 2011 at 05:41:08PM +0200, Ahmed S. Darwish wrote:
>>> (Also applicable over 2.6.38-rc3)
>>>
>>> Had to explore two C code files to make sense of the 'crashkernel='
>>> kernel parameter values.  Improve the situation.
>>>
>>> Signed-off-by: Ahmed S. Darwish <darwish.07@gmail.com>
>>> ---
>>>
>>> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
>>> index 89835a4..8f26b42 100644
>>> --- a/Documentation/kernel-parameters.txt
>>> +++ b/Documentation/kernel-parameters.txt
>>> @@ -545,9 +545,12 @@ and is between 256 and 4096 characters. It is defined in the file
>>>  			Format:
>>>  			<first_slot>,<last_slot>,<port>,<enum_bit>[,<debug>]
>>>  
>>> -	crashkernel=nn[KMG]@ss[KMG]
>>> -			[KNL] Reserve a chunk of physical memory to
>>> -			hold a kernel to switch to with kexec on panic.
>>> +	crashkernel=size[KMG][@offset[KMG]]
>>> +			[KNL] Using kexec, Linux can switch to a 'crash kernel'
>>> +			upon panic. This parameter reserves the physical
>>> +			memory region [offset, offset + size] for that kernel
>>> +			image. If the '@offset' part was ignored, Linux finds
>>> +			a suitable crash image start address automatically.
>> 
>> I think this would be further improved as:
>> 
>> 			... If '@offset' is omitted then a suitable
>> 			offset is selected automatically.
>
> Suitable offset as in parses a known image type (ELF, bzImage, etc) to
> find the start address?  Or just assumes the entry point and load
> address are the same?

Neither.  Suitable as in an offset that is naturally aligned for the
size up to I think 16MB where the kernel doesn't care anymore. Saying
that somewhere would be good but I don't think the definition of
suitable belongs in a reference doc like kernel-parameters.txt

The important things for users is to know that they don't need to
specify offset anymore.

> Is this the size for just the kernel image, or also for the physical
> memory it uses so it won't overwrite the existing kernel's stuff on the
> way up?  (If a compressed kernel wants to decompress itself or extract
> an initramfs for itself, what happens?)

The size is the size of the area reserved for the crash capture kernel to run
in. The crash capture kernel never uses anything else.

All of the parsing etc is done in user space via /sbin/kexec.

Eric
