Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933228Ab2JTBkb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 21:40:31 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:46523 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759515Ab2JTBk3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 21:40:29 -0400
X-AuditID: cbfee61a-b7f976d000001eb9-ee-5082010b9c3a
Message-id: <5082010B.4040102@samsung.com>
Date: Sat, 20 Oct 2012 10:40:27 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        anish kumar <anish198519851985@gmail.com>
Subject: Re: [PATCH] extcon : callback function to read cable property
References: <18312556.138071350457714044.JavaMail.weblogic@epml24>
 <20ADAB092842284E95860F279283C5643BD887@BGSMSX101.gar.corp.intel.com>
In-reply-to: <20ADAB092842284E95860F279283C5643BD887@BGSMSX101.gar.corp.intel.com>
Content-type: text/plain; charset=EUC-KR
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrJLMWRmVeSWpSXmKPExsVy+t9jAV1uxqYAg3VLjSwu75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGir3LWAvuaFXsfDOXtYHxpVIXIyeHhICJxMuLFxghbDGJC/fW
	s3UxcnEICSxilHg+ewk7SEJIoItJor0/EMTmFdCS2DBpNUsXIwcHi4CqRHeTNUiYDSi8/8UN
	NpCwqECExK9+DohqQYkfk++xgNgiAioSU1u+M4GMZxZYzijR2HQbLCEs4CbRcOQ7M8TeLkaJ
	o7f/sIIkOAVCJObu+g5WxCygITH19WlGCFteYvOat8wTGAVmIVkyC0nZLCRlCxiZVzGKphYk
	FxQnpeca6hUn5haX5qXrJefnbmIEB+AzqR2MKxssDjEKcDAq8fBK9DUGCLEmlhVX5h5ilOBg
	VhLhXboIKMSbklhZlVqUH19UmpNafIhRmoNFSZy32SMlQEggPbEkNTs1tSC1CCbLxMEp1cDY
	caFvdtHtnqSdIhq2j0/a71/kIjhPIcjIQHjVacG7s7Q6LHveFn0zjZb+uav3eKv085+PAt03
	NzEvZHiU9Z9ZYeXUN7L+n7TuHTuc+pxHWbi+xerfwrfMt1O19vFlTSg5YdRq0cT/hO27oFag
	NpfF4tRwvtTN/41i3rIHHLgX2eX8hGu10EUlluKMREMt5qLiRABOEND9PAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/19/2012 12:13 PM, Tc, Jenny wrote:
> 
> 
>>>>>> Subject: Re: [PATCH] extcon : callback function to read cable
>>>>>> property
>>>>>>
>>>>>> I think the reason why we have extcon is in first place is to
>>>>>> only notify the clients of cable connection and disconnection
>>>>>> and it is up to the client to decide what else to do with the
>>>>>> cable such as finding which state it is in and other details.
>>>>>> So I feel this should not be handled in the extcon.
>>>>>>
>>>>>> However it is up to the maintainer to decide.
>>>>>
>>>>> Once the consumer gets the notification, it needs to take some action.
>>>>> One of the action is to read the cable properties. This can be
>>>>> done by proprietary calls which is known both to the consumer and the
>> provider.
>>>>> My intention is to avoid this proprietary calls. Since both the
>>>>> provider and consumer are communicating with the extcon subsystem
>>>>> , I feel having a callback function of this kind would help to
>>>>> avoid the use of proprietary calls. Also I agree that extcon
>>>>> notifier chains are used to notify the cable state
>>>>> (attach/detach). But if a cable has more than two states (like the
>>>>> charger cable) how do we support it without
>>>> having a callback function like this?
>>>>> Let the maintainer take the final decision.
>>>> Well this use case will keep on growing if we start factor in this
>>>> kind of changes and that is why I am opposed to adding any other state.
>>>> Maintainer?
>>>>>
>>>>>
>>>>
>>
>> Hello,
>>
>>
>> I don't think it's appropriate to declare the charger specific properties in
>> extcon.h. The status of a charger should be and can be represented by an
>> instance of regulator, power-supply-class, or charger-manager.
>>
> Agreed. We can move this to power supply subsystem.
> 
>> Thus, we may (I'm still not sure) need to let extcon to relay the instance
>> (struct device? or char *devname?) with some callback similar with
>> get_cable_device().  However, allowing (and encouraging) to pass void
>> pointer of cable_props to extcon users from extcon device appears not
>> adequete. If the both parties can use their own "private"
>> data structure, why they cannot simply pass their own data witht the
>> "private" data channel?
>>
>>
>> Recap:
>> - The later part of patch: NACK
>> - The first part of patch (callback): need to reconsider the data type.
>> We may get device pointer or device name that is correspondant to the
>> cable, which in turn, guides us to the corresponding data structure (charger-
>> manager, regulator, or something) However, I'm still not sure which should
>> be appropriate for this.
>>
> 
> The requirement for this feature came from the implementation of the
> power supply charging framework (http://www.spinics.net/lists/kernel/msg1420500.html 
> refer charger_cable_event_worker function). The charging framework is not a driver. It can
> be compiled with the power supply class driver to support charging. Also the
> private data structure may not provide a generic method for this implementation
> since the extcon provider drivers will be different in different platforms. So it's not
> necessary that the framework knows the private data structure of the provider.
> Basically the requirement is to have a generic method to retrieve the cable properties without
> knowing the extcon provider driver internal implementation. Can you suggest a generic approach
> for this problem?
> 
The rold of extcon inform only attached/detached state of extcon consumer driver
from extcon provider driver. After extcon consumer driver detect the state of cable
through extcon, extcon consumer driver or framework should get the additional information of cable
from other device driver except of extcon.

Also, extcon manage various cables (e.g., USB, TA, MHL, JIG-USB-ON, JIG-USB-OFF, Dock)
What are common properties among many cables expect attached or detached state?

> Also the cable states we support in extcon (attach/detach) is not sufficient
> to support the cable states of a charger cable which can have more than 2 states. The charger cable 
> states can be (1)attach/(2)detach, (3)suspend - host suspend (different from detach since it's possible to charge
> in this state but with a different charge current than the attached state),(4)resume - resume after the suspend,
> (5)update - update the cable properties after USB enumeration (USB cable supports 100(USB2.0)/150(USB3.0)
> in an un configured state. But after enumeration it can support up to 500mA(USB 2.0)/900(USB 3.0))
> 
> Since extcon is basically intended to support the cable states, how do we support cables with
> more than two states?

You explained about charger cable for charging framework. I think that extcon consumer driver
can detect the chagne of system state from idle to suspend, then extcon consumer driver change
charge current according to system state(idle or suspend).  Also, I think that the main of charging
is regulator and the regulator for charging defines max or min limitation of charge current with
H/W dependency. The extcon provider driver haven't decided the charge current according to cable type.

Now that extcon-max77693 MUIC device driver can detect difference between "MHL" and "MHL-TA"
when MHL/MHL-TA cable is attached/detached and define two type cable of MHL cable.

Thanks,
Chanwoo Choi
