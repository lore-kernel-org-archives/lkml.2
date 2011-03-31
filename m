Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452Ab1CaJUq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:20:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20555 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756315Ab1CaJUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:20:44 -0400
Message-ID: <4D944764.4040202@redhat.com>
Date: Thu, 31 Mar 2011 11:20:36 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110307 Fedora/3.1.9-0.39.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.9
MIME-Version: 1.0
To: "Justin P. Mattock" <justinmattock@gmail.com>
CC: trivial@kernel.org, kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH]arch:x86:kvm:i8254.h Fix typo in kvm_pit
References: <1301501942-3937-1-git-send-email-justinmattock@gmail.com> <4D9359CC.6050508@redhat.com> <4D935AC3.2030509@gmail.com> <4D93659F.2020900@redhat.com> <4D936B7F.40407@gmail.com>
In-Reply-To: <4D936B7F.40407@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2011 07:42 PM, Justin P. Mattock wrote:
> On 03/30/2011 10:17 AM, Avi Kivity wrote:
>> On 03/30/2011 06:30 PM, Justin P. Mattock wrote:
>>> On 03/30/2011 09:26 AM, Avi Kivity wrote:
>>>> On 03/30/2011 06:19 PM, Justin P. Mattock wrote:
>>>>> The below patch changes base_addresss to base_address.
>>>>> Note: I have grepped for base_addresss and nothing shows up,
>>>>> grepping for base_address gets me lots of output, telling me that
>>>>> this is a typo, but could be wrong.
>>>>>
>>>>> Signed-off-by: Justin P. Mattock<justinmattock@gmail.com>
>>>>>
>>>>> ---
>>>>> arch/x86/kvm/i8254.h | 2 +-
>>>>> 1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>
>>>>> diff --git a/arch/x86/kvm/i8254.h b/arch/x86/kvm/i8254.h
>>>>> index 46d08ca..c2fa48b 100644
>>>>> --- a/arch/x86/kvm/i8254.h
>>>>> +++ b/arch/x86/kvm/i8254.h
>>>>> @@ -33,7 +33,7 @@ struct kvm_kpit_state {
>>>>> };
>>>>>
>>>>> struct kvm_pit {
>>>>> - unsigned long base_addresss;
>>>>> + unsigned long base_address;
>>>>> struct kvm_io_device dev;
>>>>> struct kvm_io_device speaker_dev;
>>>>> struct kvm *kvm;
>>>>
>>>> Why not remove the variable completely?
>>>>
>>>
>>> didnt even think to completely remove the variable(figured it was used
>>> somewhere).I will look at that and resend with removal of the variable
>>> for you..
>>
>> Well if it was used, you ought to have changed all of the users, no?
>>
>
> at the moment I see:
> (keep in mind my reading skills only go so far!)
>
>  grep -Re base_address kvm/* -n
> kvm/ioapic.c:276:       return ((addr >= ioapic->base_address &&
> kvm/ioapic.c:277:                (addr < ioapic->base_address + 
> IOAPIC_MEM_LENGTH)));
> kvm/ioapic.c:371:       ioapic->base_address = 
> IOAPIC_DEFAULT_BASE_ADDRESS;
> kvm/ioapic.h:38:        u64 base_address;
>
> so changing base_addresss; to base_address; gets kvm_ioapic_reset to 
> function correctly as well as ioapic_in_range?
> (but could be wrong)
>

Can you explain how kvm_ioapic_reset() would be affected by the change?

Really, you need to understand what you're doing before sending patches.

-- 
error compiling committee.c: too many arguments to function


