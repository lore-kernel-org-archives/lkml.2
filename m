Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760204Ab0GSRBw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:01:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62659 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755167Ab0GSRBv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=SEWSbu+Q7JXcGw6QxRlODYaAAg3xmwhWQhkoZiail+chWHlrXg3jd90czelA2kjau0
         dxrex2JdRcGxOeZspSb5K+17m42z1YsSjTS8D0NelVGPirBUL89N9icZWTDdR7XpmYzT
         v2YJfVN0cnyf0/AKbB4kh4TYcZ9Uz+ySFqqBQ=
MIME-Version: 1.0
In-Reply-To: <4C435481.5080506@linux.vnet.ibm.com>
References: <AANLkTimhqRAMjaVNwo50GJO9B6kTzySWVtK04gEdu0rg@mail.gmail.com>
	<4C37C365.6090508@gmail.com>
	<AANLkTilH9Hn0MHvfOEOyEeRmDcPTrRXIFB3K8pq31yIH@mail.gmail.com>
	<AANLkTikZCBrZwROGgGTj-JREywN3fUnvaANtTGgkok--@mail.gmail.com>
	<AANLkTinbj4ScYca7WlnUiIKgsVkVbQwEO4ypgxFe5Zbo@mail.gmail.com>
	<AANLkTinSjNHPyariuoUuYZCRcbTf8nQALma81I4CPdsv@mail.gmail.com>
	<4C434A19.9050207@linux.vnet.ibm.com>
	<AANLkTim8s_noUR8u5FTmT-C8_MA1n6y6TP2LQz7oxxkh@mail.gmail.com>
	<4C435481.5080506@linux.vnet.ibm.com>
Date: Mon, 19 Jul 2010 10:01:48 -0700
Message-ID: <AANLkTiluZ0HQJEpE5wXyLSl9iS_YJVy_BZw-ZPicTBik@mail.gmail.com>
Subject: Re: Interrupt Affinity in SMP
From: Bryan Hundven <bryanhundven@gmail.com>
To: Ciju Rajan K <ciju@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, Robert Hancock <hancockrwd@gmail.com>,
        mchehab@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Again, I can set a TxRx interrupt to a specific core and this works
fine, but when I try to set that same TxRx interrupt to a set of
cores/processors - interrupts only occur on the first core/processor
of the set.

On Sun, Jul 18, 2010 at 12:22 PM, Ciju Rajan K <ciju@linux.vnet.ibm.com> wrote:
> Bryan Hundven wrote:
>>
>> On Sun, Jul 18, 2010 at 11:38 AM, Ciju Rajan K <ciju@linux.vnet.ibm.com>
>> wrote:
>>
>>>
>>> Bryan Hundven wrote:
>>>
>>>>
>>>> On Sat, Jul 10, 2010 at 6:20 PM, Robert Hancock <hancockrwd@gmail.com>
>>>> wrote:
>>>>
>>>>
>>>>>
>>>>> On Sat, Jul 10, 2010 at 1:46 PM, Bryan Hundven <bryanhundven@gmail.com>
>>>>> wrote:
>>>>>
>>>>>
>>>>>>
>>>>>> I was able to set eth0 and it's TxRx queues to cpu1, but it is my
>>>>>> understanding that 0xFFFFFFFF should distribute the interrupts across
>>>>>> all
>>>>>> cpus, much like LOC in my output of /proc/interrupts.
>>>>>>
>>>>>> I don't have access to the computer this weekend, but I will provide
>>>>>> more
>>>>>> info on Monday.
>>>>>>
>>>>>>
>>>>>
>>>>> That may be chipset dependent, I don't think all chipsets have the
>>>>> ability to distribute the interrupts like that. Round-robin interrupt
>>>>> distribution for a given handler isn't optimal for performance anyway
>>>>> since it causes the relevant cache lines for the interrupt handler to
>>>>> be ping-ponged between the different CPUs.
>>>>>
>>>>>
>>>>>
>>>>>>
>>>>>> -bryan
>>>>>>
>>>>>> On Jul 9, 2010 5:48 PM, "Robert Hancock" <hancockrwd@gmail.com> wrote:
>>>>>>
>>>>>> On 07/09/2010 04:59 PM, Bryan Hundven wrote:
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> Mauro, list,
>>>>>>>
>>>>>>> (please CC me in replies, I am not...
>>>>>>>
>>>>>>>
>>>>>>
>>>>>> Tried changing these files to exclude CPU0?
>>>>>>
>>>>>> Have you tried running the irqbalance daemon? That's what you likely
>>>>>> want to
>>>>>> be doing anyway..
>>>>>>
>>>>>>
>>>>>>
>>>>>>>
>>>>>>> =====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====8<=====
>>>>>>>
>>>>>>> =====8<=====8<=====8<==...
>>>>>>>
>>>>>>>
>>>>
>>>> Please see the two attached examples.
>>>>
>>>> Notice on the 5410 example how we start with the affinity set to 0xff,
>>>> and change it to 0xf0.
>>>> This should spread the interrupts over the last 4 cores of this quad
>>>> core - dual processor system.
>>>>
>>>> Also notice on the 5645 example, with the same commands we start with
>>>> 0xffffff and change to 0xfff000 to spread the interrupts over the last
>>>> 12 cores, but only the first of the last twelve cores receive
>>>> interrupts.
>>>>
>>>> This is the inconsistency I was trying to explain before.
>>>>
>>>>
>>>
>>> What was the status of irqbalance daemon? Was it turned on? If it is
>>> running, there is a chance that the interrupt count is within the
>>> threshold
>>> limit and interrupts are not being routed to the other core.
>>>
>>
>> irqbalance daemon was not running on either setup.
>>
>>
>>>
>>> Could you also try with increasing the interrupt load and see if the
>>> distribution is happening among the cores?
>>>
>>
>> We use spirent testcenter l2/l3 test equipment and pushed 100%
>> throughput with the same distribution. Nothing changed.
>>
>
> In the example that you have given, I could see just 7 interrupts after 15
> seconds.
> So thought of checking it. Let me try to see this problem locally.
>
> -Ciju
>>
>> This isn't affecting just ethernet drivers. I have also seen the same
>> issues with hardware encryption devices and other hardware that gets a
>> software interrupt.
>>
>> --Bryan
>>
>>
>>>
>>> -Ciju
>>>
>>>>
>>>> --Bryan
>>>>
>>>>
>>>
>>>
>>
>>
>>
>>
>
>



-- 
Bryan Hundven
bryanhundven@gmail.com
