Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752752Ab2KCC5u (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 22:57:50 -0400
Received: from mga11.intel.com ([192.55.52.93]:25489 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751858Ab2KCC5s convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 22:57:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,702,1344236400"; 
   d="scan'208";a="242064792"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "'myungjoo.ham@samsung.com'" <myungjoo.ham@samsung.com>,
        "'???'" <cw00.choi@samsung.com>
CC: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>,
        "'anish kumar'" <anish198519851985@gmail.com>
Subject: RE: RE: [PATCH] extcon : callback function to read cable property
Thread-Topic: RE: [PATCH] extcon : callback function to read cable property
Thread-Index: AQHNsovp6G0DwL0rA0q1yJGiZGhCB5fJuemwgA2+lqA=
Date: Sat, 3 Nov 2012 02:57:35 +0000
Message-ID: <20ADAB092842284E95860F279283C5643F6B41@BGSMSX101.gar.corp.intel.com>
References: <16192195.128621351154225389.JavaMail.weblogic@epml11>
 <20ADAB092842284E95860F279283C5643E68A6@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <20ADAB092842284E95860F279283C5643E68A6@BGSMSX101.gar.corp.intel.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.223.10.10]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Myunjoo,

Ping. Could you please have a look at my response below?

-jtc

> -----Original Message-----
> From: Tc, Jenny
> Sent: Thursday, October 25, 2012 2:55 PM
> To: myungjoo.ham@samsung.com; ???
> Cc: linux-kernel@vger.kernel.org; anish kumar
> Subject: RE: RE: [PATCH] extcon : callback function to read cable property
> 
> > Subject: Re: RE: [PATCH] extcon : callback function to read cable
> > property
> > > For charger cable the current each cable can provide will be common.
> > > But may not be relevant for other cables.
> > >
> > > I understand your point on extcon role. But my concern is, when the
> > > consumer driver gets a notification on cable state change, how does
> > > the consumer query the cable properties in a generic way. Do you
> > > have any
> > suggestions for this?
> > >
> > > A use case can be as below
> > >
> > > When a USB host cable (SDP) connected to the platform, without USB
> > > enumeration it can support only up to 100mA(USB2.)/150mA(USB 3.0)
> > > (As
> > per USB charging spec).
> > > Once the enumeration is done this can be 500mA/950mA. If the
> > > consumer charger driver need to configure the charger chip, it need
> > > to know the
> > charger cable capabilities.
> > > For example a platform PLAT1 may have charger driver CHRGR1 and OTG
> > driver OTG1.
> > > But platform PLAT2 may have CHGR1 but different OTG driver OTG2. How
> > > CHGR1 driver can detect  the cable properties without having any
> > > platform layer hooks? The platform layer hooks (using platform
> > > data)will work only if the consumer is a platform driver. What if
> > > it's a
> > framework which will have the same flow in all platforms?
> >
> > In general,
> > an extcon user (extcon notifee) knows who's the extcon notifier; the
> > user is supposed to know the name of the notifier.
> >
> > Thus, the extcon user should be able to get the appropriate object;
> > i.e., a regulator struct in this case. Then, according to the USB
> > state, the current limit of the USB can be changed by the notifier;
> > which may notify (regulator subsystem has one) the extcon user to
> > react (change current limit of
> > charger?)
> 
> The flow we have is "notifier (OTG driver/cable notifier driver) -> extcon->
> charging framework->charger driver"
> 
> When the framework gets notification from the extcon, it just know cable is
> connected/disconnected
> 
> For a USB charging the state machine can be
> 
> For USB2.0
> 1) CONNECT (100mA)->UPDATE(500mA)->DISCONNECT(0mA)
> 2)CONNECT (100mA)->UPDATE(500mA)->HOST SUSPEND(2.5mA/500mA)-
> >DISCONNECT(0mA)
> 3) CONNECT (100mA)->UPDATE(500mA)->HOST SUSPEND(2.5mA/500mA)-
> >HOST RESUME(500mA)->DISCONNECT(0mA)
> 
> For USB 3.0
> 4) CONNECT (150mA)->UPDATE(900mA)->DISCONNECT(0mA)
> 5) CONNECT (150mA)->UPDATE(900mA)-> HOST SUSPEND(2.5mA/900mA)-
> >DISCONNECT(0mA)
> 6) CONNECT (100mA)->UPDATE(900mA)->HOST SUSPEND(2.5mA/900mA)-
> >HOST RESUME(900mA)->DISCONNECT(0mA)
> 
> >
> > Anyway, in your case of PLAT2, doesn't CHGR1 has (or is) a regulator
> > controlling the charger current and if the OTG2 regulator affects the
> > behavior of CHGR1, (the current of OTG2-reg goes to CHGR1-reg) the
> > consumer- supplier chain should be setup (if the BSP is ideal).
> >
> > OR
> >
> > If it is impossible to have any objects of OTG2 (looks strange,
> > but..), you may have two cables, USB (data) and Fast-charger.04 (add
> > +400mA to USB), where Fast-charger.04 is enabled when USB2
> enumeration
> > is done with 5
> 
> I got your point. It's not just 2 cables we may need 4 cables to support USB2.0
> and USB3.0 since the charge current can be 100/500 for USB2.0 and 150/900
> for USB 3.0. But what about the states?
> 
> .
> >
> >
> >
> > However, the following callback might be considered if there are cases
> > where an extcon user has information of extcon_name and cable_name
> > while the user CANNOT get any information on which device or object is
> > related with the specific cable; in struct extcon, with optional user
> > initializing data section:
> >
> > +	struct device **cable_device;
> > OR
> > +	char **cable_device_name;
> >
> > With any relevant changes in the status with cable_device, we may
> > notify any notifier-block that are interested in the specific cable.
> > Then, the notifier- block (for register_interest) is going to handle
> > extcon-state changes and cable_device notifications.
> >
> > Currently, the user's nb is for cable attach/detach events with
> > true/false value in the place of 32bit value (val). However, if we add
> > the third possible value for that parameter
> > (0: cable detached, 1: cable attached, 2: cable status changed; go
> > find out what's going on), it is still compatible.
> >
> > I considered using a void pointer instead of cable_device, too.
> > However, that would spoil the subsystem too much; we'll be creating a
> > total
> > chaos: "USB-A driver uses struct regulator", "USB-B driver uses struct
> > device", "USB-C driver uses true/false", and so on.
> 
> But just by getting the device instance how do we extract the cable
> properties like cable state and the charge current in a generic way?
> 

