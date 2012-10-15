Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751787Ab2JOOxu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 10:53:50 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:35351 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750872Ab2JOOxt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 10:53:49 -0400
MIME-Version: 1.0
Reply-To: myungjoo.ham@gmail.com
In-Reply-To: <20ADAB092842284E95860F279283C56439C8F5@BGSMSX101.gar.corp.intel.com>
References: <7103095.833841349851943826.JavaMail.weblogic@epml02>
	<20ADAB092842284E95860F279283C56439C8F5@BGSMSX101.gar.corp.intel.com>
Date: Mon, 15 Oct 2012 23:53:48 +0900
X-Google-Sender-Auth: m2yZOIEnGnF2FH1CRFRB4YuK-zE
Message-ID: <CAJ0PZbQTR=DD8E-YGUSwtAqNRXrdtf0yoKbPyAksZY6QtjiXgg@mail.gmail.com>
Subject: Re: [PATCH] extcon : register for cable interest by cable name
From: MyungJoo Ham <myungjoo.ham@samsung.com>
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "???" <cw00.choi@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 7:37 PM, Tc, Jenny <jenny.tc@intel.com> wrote:
>
>
>> Subject: Re: [PATCH] extcon : register for cable interest by cable name
>>
>> > There are some scnearios where a driver/framework needs to register
>> > interest for a particular cable without specifying the extcon device
>> > name. One such scenario is charger notifications. The platform will
>> > have charger cabel which will be bound to any extcon device. It's not
>> > mandatory for the charger driver to know which extcon device it should
>> > use. This patch enables the support for registering interest for a
>> > cable just by cable name wihtout specifying the extcon device name
>> >
>> > Signed-off-by: Jenny TC <jenny.tc@intel.com>
>> > ---
>> []
>> > +extern struct extcon_dev *register_interest_cable_byname
>> > +           (struct extcon_specific_cable_nb *extcon_dev,
>> > +           const char *cable_name, struct notifier_block *nb);
>>
>> What about allowing extcon_register_interest() to support the functionality?
>>
> register_interest_cable_byname  internally uses extcon_register_interest   function.
> If we want to use  extcon_register_interest()  in both scenarios,  then we need to define
> two local functions

Then, you can use recursion. (calling recursively if the extcon_name
is NULL and when it calls recursively itself, extcon_name should not
be NULL)

>
>  extcon_register_interest__ and  register_interest_cable_byname.
>
> Then the code would be
>
> int extcon_register_interest(struct extcon_specific_cable_nb *obj,
>                  const char *extcon_name, const char *cable_name,
>                                 struct notifier_block *nb) {
>
>         if (extcon_name == NULL)
>                 return register_interest_cable_byname(obj,cable_name,nb);
>         else
>                 return extcon_register_interest__(obj,extcon_name,cable_name,nb);
> }
>
> Is that fine?
>
>> I.e., allowing extcon_register_interest() to accept NULL extcon_name.
>>
>>
>> ps. anyway, usually, the "platforms" have the list of node paths, don't they?
>>
> My intention is to make it generic and less dependent on platform data. This way the same consumer
> driver can work on any platform without looking for extcon dev name in the platform data.
> For example a charger driver can work on any platform without knowing the extcon provider name for
> The charger cable.
>
>
>



-- 
MyungJoo Ham, Ph.D.
Mobile Software Platform Lab, DMC Business, Samsung Electronics
