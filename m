Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751981Ab2KLDdl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 22:33:41 -0500
Received: from mail-ia0-f174.google.com ([209.85.210.174]:61772 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277Ab2KLDdk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 22:33:40 -0500
MIME-Version: 1.0
In-Reply-To: <509FFF8B.3010707@gmail.com>
References: <64c5278ebdec503f83e9b7002bf13affb7f3260f.1351225085.git.viresh.kumar@linaro.org>
	<50991C41.50705@gmail.com>
	<CAOh2x==LNuSFftB1r8cyJ6TOqOVJfExMTUVxKZnS16wL4B8eBA@mail.gmail.com>
	<509FB25F.3030307@gmail.com>
	<CAKohpoksQ4ShO_QFAQORO2_oEgNtOeENFnX1C3gN_5POQSGexg@mail.gmail.com>
	<509FFF8B.3010707@gmail.com>
Date: Mon, 12 Nov 2012 09:03:39 +0530
Message-ID: <CAKohponUFABC397w=dq7j+1f5QeiOX4BCOXv=OZSNOaOTmt9oQ@mail.gmail.com>
Subject: Re: [PATCH Resend V2] dt: add helper function to read u8 & u16
 variables & arrays
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Rob Herring <robherring2@gmail.com>
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        linaro-dev@lists.linaro.org, andriy.shevchenko@intel.com,
        patches@linaro.org, devicetree-discuss@lists.ozlabs.org,
        spear-devel@list.st.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 November 2012 01:12, Rob Herring <robherring2@gmail.com> wrote:
> On 11/11/2012 11:27 AM, Viresh Kumar wrote:
>> On 11 November 2012 19:42, Rob Herring <robherring2@gmail.com> wrote:
>>> On 11/06/2012 10:22 PM, viresh kumar wrote:
>>
>>>>                 cluster0: cluster@0 {
>>>> +                       data1 = <0x50 0x60 0x70>;
>>>> +                       data2 = <0x5000 0x6000 0x7000>;
>>>> +                       data3 = <0x50000000 0x60000000 0x70000000>;
>>>
>>> So there is a mismatch in our assumptions. You are just truncating
>>> 32-bit values. I assumed you were using the 8 and 16 bit sizes that are
>>> now supported in dts. I don't think we should just truncate values
>>> blindly. We have support for specifying 8 and 16 values now so you
>>> should use that and define that as part of a binding.
>>
>> Sorry couldn't get your point at all :(
>> What did you mean by "truncating 32 bit values" and how should we
>> tell via DT, that the value passed is 8 bit, 16 bit or 32 bit?
>>
>
> You are trying to retrieve an array of 8 or 16-bit values which are
> stored as 32-bit values in dtb. Why not define them in the binding as 8
> or 16 bit to begin with. Then there is never any ambiguity about their size.
>
> I don't think the size is stored in the dtb. It is only in the dts. You
> need to define the size in the binding definitions and use '/bits/'
> annotation. With this the data is packed. Then the array function used
> should match what the binding defines.

Aha, and in that case incrementing address by 4 in my patch will fail. Right?
Will fix it. Thanks for increasing my knowledge on this :)

--
viresh
