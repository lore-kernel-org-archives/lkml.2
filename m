Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759000Ab2CHWsA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:48:00 -0500
Received: from 88-230.252-81.static-ip.oleane.fr ([81.252.230.88]:50506 "EHLO
	smtp.lii-enac.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758846Ab2CHWr5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:47:57 -0500
Subject: Re: [PATCH 4/5] HID: autoload hid-multitouch as needed
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=iso-8859-1
From: =?iso-8859-1?Q?St=E9phane_Chatty?= <chatty@enac.fr>
In-Reply-To: <20120308122303.GA11989@polaris.bitmath.org>
Date: Thu, 8 Mar 2012 23:47:54 +0100
Cc: Jiri Kosina <jkosina@suse.cz>,
        "benjamin.tissoires Tissoires" <benjamin.tissoires@gmail.com>,
        =?iso-8859-1?Q?Fabien_ANDR=C9?= <fabien.andre@enac.fr>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        USB list <linux-input@vger.kernel.org>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <2189FE61-4D55-4729-BBCE-C4880A7EAB2F@enac.fr>
References: <1331053026-21272-1-git-send-email-benjamin.tissoires@gmail.com> <1331053026-21272-5-git-send-email-benjamin.tissoires@gmail.com>  <alpine.LNX.2.00.1203072234550.29034@pobox.suse.cz>  <20120308105737.GA11201@polaris.bitmath.org>  <6E17845C-6F9F-4CB6-AA5D-DEEDCD2089E8@enac.fr>  <20120308113009.GA11416@polaris.bitmath.org>  <E18D154F-E02F-4DF9-8749-7F9EF92792CB@enac.fr> <20120308122303.GA11989@polaris.bitmath.org>
To: Henrik Rydberg <rydberg@euromail.se>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 8 mars 2012 à 13:23, Henrik Rydberg a écrit :

> On Thu, Mar 08, 2012 at 12:48:24PM +0100, Stéphane Chatty wrote:
>> 
>> Le 8 mars 2012 à 12:30, Henrik Rydberg a écrit :
>>> 
>>> The device-driver matching is done in the kernel, but driver (aka
>>> module) loading is done from userland. The crux is to be able to tell
>>> userland what driver to load for a certain device. In this case, it
>>> means giving more information to userland via the device/modalias
>>> construct. Or at least, that is the question. :-)
>>> 
>> 
>> Oook, I understand. The current solution used by distros is to load
>> the hid module statically, but then we don't want to do it for every
>> new kind of device-specific module, right? Is this your point?
> 
> Yes, half of it. The other half is the observation that the problem of
> device-driver assignment we face for hid devices seems to originate in
> the definition of what a hid device is, i.e., the hid device
> identifier. If the identifier was more detailed and one could
> construct a new hid device dynamically from the reports, the problem
> would go away. Consequentually, a more detailed identifier would solve
> the module-loading problem as well. The major concern I have is if
> this is feasible from a compatibility point of view.

Understood. This converges with my concerns about how device classes are handled in the hid core: there is no explicit device class or description of features, and with the new kinds of devices this leads to more and more complex tests in hid-input and in X drivers to reconstruct that information from the evdev axes so as to decide what to do with each device.

A few people in my group, including Benjamin, are developing an experimental event routing server in user space, to support new patterns of input processing. Given that plugging a device is just a particular kind of input, I'd be interested to see what it could do with hotplug events that contain more details about device types :-) BTW, HID reports constitute a richer language than evdev axes, and MacOS and Windows give a growing role to HID. It would be good if at some point we  could define device types based on something with the same kind of expressive power. 

> 
>> I had the feeling that the current hid code was somehow trying to be
>> universal, thus making the point moot, and figured that we would
>> need to reintegrate hid-multitouch into hid-core at some
>> point. You're suggesting another, more distributed option, in which
>> new categories of HID devices appear from time to time and are
>> handled in new modules, right? Sounds interesting to me, I'd like to
>> hear what the original designers of the hid module think of it.
> 
> Me too. Reading through the module code, it really seems to put
> userland in charge, only providing sufficient information to be able
> to load the right modules. If this was fully possible in hid, at least
> one of the special blacklists would disappear. One would also be able
> to split the current hid-input into several different drivers, for
> instance, gaining some clarity in addition to memory savings.

This would be a radical change from the current hid code that tends to restrict "true hid" to a limited range of HID usages and to reject the rest (cf the IS_INPUT_APPLICATION that caused us some difficulties three years ago). But this definitely would make sense to me. Jiri, Dmitry, what do you think?

St.


