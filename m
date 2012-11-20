Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2KTJcR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 04:32:17 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:40312 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab2KTJcL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 04:32:11 -0500
MIME-Version: 1.0
In-Reply-To: <20121120092419.GA27280@lizard>
References: <509B0A0F.5000406@samsung.com>
	<20ADAB092842284E95860F279283C5644017F6@BGSMSX101.gar.corp.intel.com>
	<1352521082.1526.230.camel@anish-Inspiron-N5050>
	<20ADAB092842284E95860F279283C56442034B@BGSMSX101.gar.corp.intel.com>
	<CAK7N6vpEbVrM-w+zLytf8BWmwt5j68py4Q64HEy9maCW2OMDjg@mail.gmail.com>
	<20ADAB092842284E95860F279283C56444A584@BGSMSX101.gar.corp.intel.com>
	<50AAEB15.6000703@samsung.com>
	<20ADAB092842284E95860F279283C56444A6A1@BGSMSX101.gar.corp.intel.com>
	<50AB1ECA.5020005@samsung.com>
	<20ADAB092842284E95860F279283C56444C915@BGSMSX101.gar.corp.intel.com>
	<20121120092419.GA27280@lizard>
Date: Tue, 20 Nov 2012 01:32:10 -0800
Message-ID: <CAK7N6vpg2U5h+uxMG4=E__K77Ta9Rfb=zzvsyD4kSsT+513M3Q@mail.gmail.com>
Subject: Re: [PATCH] extcon : callback function to read cable property
From: anish singh <anish198519851985@gmail.com>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: "Tc, Jenny" <jenny.tc@intel.com>, Chanwoo Choi <cw00.choi@samsung.com>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myunjoo.ham@gmail.com" <myunjoo.ham@gmail.com>,
        "lockwood@android.com" <lockwood@android.com>,
        "peterhuewe@gmx.de" <peterhuewe@gmx.de>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "lars@metafoo.de" <lars@metafoo.de>,
        "jic23@kernel.org" <jic23@kernel.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 1:24 AM, Anton Vorontsov <cbouatmailru@gmail.com> wrote:
> On Tue, Nov 20, 2012 at 09:14:41AM +0000, Tc, Jenny wrote:
> [...]
>> > For example,
>> > Firstly, the power_supply charging framework check state of charger cable
>> > whether attached or detached cable. Second, when power_supply charging
>> > framework receive the changed state of host system from 'Host system
>> > notifier', change charging current of charger cable.
>>
>> Not just SUSPEND, but we need to handle RESUME , UPDATE etc.  Also this doesn’t help us to
>> define a standard interface for the charger cable state/properties. IMHO it's not right
>> to provide different interfaces for different cables. This doesn't help us to standardize
>> the charger cable interface.
>>
>> This thread has been running for a quite long time. Unfortunately we couldn't make an
>> agreement on the final solution. I would like to recap the overall requirement and
>> would like to propose alternate solutions. The requirements is  to
>> "Provide a generic interface for charger cable states and charger cable properties"
>>
>> Even though extcon subsystem handles charger cable states, it's not enough to handle
>> all kind of charger cable states. It can handle just 2 states CONNECT/DISCONNECT.
>> But there are scenarios where we need to handle more than 2 states
>> (eg. USB SUSPEND/RESUME/UPDATE etc). Also extcon doesn't have any mechanism to
>> read cable properties in a generic way.  Extcon charger-cable consumer driver
>> implementations (eg charger-manager), defines charger cable properties statically (current in mA)
>> inside the consumer driver. This is not enough, since the charger cable properties may change dynamically
>>
>> In existing form extcon cannot support different charger cable states and their
>> properties in a generic way. Also we couldn't find a final solution on how to modify the
>> extcon to support these requirements. From the whole discussion what I conclude is
>>  * extcon is not designed to support cable properties
>
> The idea of using union seemed good to me, what happened to it?
>
> I mean, MyungJoo Ham wrote:
>
> | We may have:
> |        enum extcon_cable_type {
> |                EXTCON_CT_REGULATOR,
> |                EXTCON_CT_PSY,
> |                EXTCON_CT_CHARGER_CB,
> |                ...
> |        };
> | and have the following included at struct extcon_cable:
> |        union {
> |                struct regulator *reg;
> |                struct power_supply *psy;
> |                struct charger_cable *charger_cb;
> |                ...
> |        } cable data;
> |        enum extcon_cable_type cable_type;
>
> This sounds good to me...
+1 for this idea.
>
>>  * extcon is not designed to support any cable state other than CONNECT/DISCONNECT
>
> Dunno for this one. Can we get these additional states via "properties" as
> described above?
>
> Thanks,
> Anton.
