Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933388Ab2GCGOm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 02:14:42 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:14854 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932473Ab2GCGOk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 02:14:40 -0400
X-AuditID: cbfee60b-b7f866d00000631c-12-4ff28dcee1cd
Date: Tue, 03 Jul 2012 06:14:38 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: RE: Charger Manager Proposal.
To: "Tc, Jenny" <jenny.tc@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Anton Vorontsov (cbouatmailru@gmail.com)" <cbouatmailru@gmail.com>,
        "Anton Vorontsov (anton.vorontsov@linaro.org)" 
	<anton.vorontsov@linaro.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>,
        =?euc-kr?Q?=C3=D6=C2=F9=BF=EC?= <cw00.choi@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20120703061359580@myungjoo.ham
Msgkey: 20120703061359580@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120703061359580@myungjoo.ham
X-ParentMTR: 
X-ArchiveUser: 
X-CPGSPASS: N
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <14051592.104301341296077424.JavaMail.weblogic@epml05>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNIsWRmVeSWpSXmKPExsVy+t/t6brnej/5G6x7wmFxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyHrW1MRa01Fa8vdjG3MD4pLKLkZNDSEBdYtGSk2wgtoSAicSz
	3h4mCFtM4sK99UBxLqCa+YwS2/c/ZQVJsAioSHxfugzI5uBgE9CTmPk5GSQsLKAlcXTBVWYQ
	WwSoZGrLdyaQXmaBfmaJtv17mCCWKUms2feKBcTmFRCUODnzCQvEMlWJTRsnQMXVJN4d7GaH
	iEtIzJp+gRXC5pWY0f4Uql5OYtrXNcwQtrTE+VkbGGGOXvz9MVScX+LY7R1MIHeC9D65Hwwz
	ZvfmL1D/CkhMPXMQqlVLYvaCP1Br+STWLHzLAjNm16nlzDC997fMBXuFWUBRYkr3Q3YIW0vi
	y499bKje4gCynSSefcibwCg3C0lmFpLuWUi6kdUsYGRZxSiaWpBcUJyUnmqoV5yYW1yal66X
	nJ+7iREc5c+4dzDOarA4xCjAwajEw8vR8clfiDWxrLgy9xCjBAezkghv3JGP/kK8KYmVValF
	+fFFpTmpxYcYpTlYlMR5J1lf8BcSSE8sSc1OTS1ILYLJMnFwSjUwBvOKhxywr6x/rcUkunDG
	gdzXLSm6u9t8WhZFtVcwTz/+RSBkN/e1vLVKzfP619/ctZfxBatQusoHnpOJy52tm7R3lN/v
	qXUKC9n14IxvSPAbve5nM/pOP/yQV3dxRYSO74fmuc0sc58lKGT9ifi4d4VQ0IELmxcF3vYO
	fMnEyGe1hu+qbL2PEktxRqKhFnNRcSIAPjifkO4CAAA=
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q636EoMb013928

> Hi,
> 
> Thanks a lot for your reply. 
> 
> To give more insight to the requirements please find the battery profile format we use.
> 
> Charge Termination current 
> 	* Should be programmed to charger or used by charger driver to stop charging along with the voltage level for charger full. The charge full voltage level will change based on temperature zone or maintenance charging

Each charger should be responsible for this. Personally, I've been implementing this feature as a current-limit regulator (topoff) at a charger or a PMIC regulator drivers. If we add this at charger-manager, we will be adding a variable that is not used or only used by ABI-read only. I'm not aware of charger-manager related code that need to access this information other than chargers themselves, yet.


> Maximum voltage
> 	* Maximum voltage battery can support in any temperature zone

Is this "CV"?
Or the V-Batt value that is supposed to be "full"? (included as "fullbatt_uV")

> Battery type
> 	* Type of battery (Li-ION)

I'm not sure what would it mean in charger-manager. Who's going to use this value?

However, if we are going to provide arbitraty power-supply-class properties via charger-manager, we may need to add something to charger_desc. For example,
char *psy_abi_provider may be added in charger_desc to provide get_property() for additional enum power_supply_property that is not supported in default charger-manager including "Type of battery" you mentioned. I don't think we need to support such values natively in charger-manager as it is not shared between entities connected via charger-manager.

> Lower temperature limit
> 	* Lowest temperature zone at which charging is allowed.
> Number of temperature monitoring Ranges 
> 	* As per PSE standard it's 6
> 
> Each zone as the following attributes
> Upper temperature Limit
> 	* Upper temperature zone for this range
> Full charge voltage
> 	* CV for this range
> Full charge current
> 	* CC for this range
> Maintenance restart voltage
> 	* In maintenance mode, charging will be resumed on this voltage level.
> Maintenance charging stop voltage
> 	* This voltage is used as CV in maintenance voltage. Used with charge termination current to stop charging in maintenance charging mode.
> Maintenance charge current
> 	* CC for maintenance charging mode. This gives a flexibility to use a lower CC in maintenance mode so that we can keep the battery relaxed.

All these can be handled if we add "generalized temperature event handling" feature in charger-manager.

Then, we will need to
1. Remove "temperature_out_of_range" callback, add "get_temperature" callback or integrate with IIO subsystem for temperature sensors.
2. Add a data structure supporting
2.1. Range of temperatures with hysterisis support
2.2. (force) Disable chargers
2.3. CV and CC values (we will need to add CC and CV regulators)
2.4. Behaviors in maintenance mode? (still don't get it what's maintenance mode)
3. Use the above data structure at sampling/polling mechanism (along with get_temperature or integrated IIO)

> 
> The charging algorithm will make use of the above battery profile and control the charging parameters in different phase of charging.  So the primary requirement is to have a common charging framework which will listen to different charger or battery events and modify the charging parameters appropriately.

Except for the temperature events generated by charger manager and timed-events related with voltage drop after full event, every event is generated externally via cm_notify_event().

Please note that having notifier chains for such seems unnecessary; charger manager is the only listener here.


> 
> Along with controlling the charging parameters we are trying to implement the following requirements
> 	* Hybrid charge termination
> 		* Charger driver/charging framework will listen to the h/w charge termination notification. On receiving this notification, software logic will read the charge current and voltage to ensure that battery is actually full. 		If it's not full, a software charge termination logic is used to ensure a battery full. Software charge termination logic internally need to turn of the h/w charge termination logic

This can be implemented inside fullbatt_handler() and fullbat_vchk(). The current charger manager also verifies whether the battery is really full with software logic after hardware tells that the battery is full via cm_notify_event().

> 	* Controlling INLIMIT for charger
> 		* Chargers will have different capabilities. For example a USB SDP charger can support 900mA(USB3.0)/500mA/100mA. A CDP/DCP can support 1500mA. Charger chip supports an INLMT which controls the 			maximum current that can be drawn from a charger.  The INLMT is different from CC which just tells the battery charging current, but it doesn't put limitation on the current drawn from the charger to meet system 		requirements. Looking at the latest charger manager patch (interfacing with the extcon class), it seems like controlling the CC and not the INLMT (Correct me if I am wrong).
> 	* Control the charger power path
> 		* Disable Charging (Disable charging. Charger will continue to supply power to platform)
> 		* Enable charging ( Enable charging)
> 		* Disable charger (Disable charging and turn off power to platform)
> 		* Enable charger (Enable charger and turn on power to platform)
> 			* The last two power path controls are used to throttle the charger.

The patch you've seen (Chanwoo's) does this if you define charger_cable.charger == charger regulator. We don't have CC controlling mechanisms; CC is determined by (at least in software logic) the sum of active charger regulators' current limit. For example, if USB cable and TA cable may be attached seperatedly (no mutual exclusiveness) making them seperated chargers connected to the same battery and each has 500mA and 1500mA as its current limit, then, if both cables are attached, USB's current limit will be 500mA, TA's current limit will be 1500mA, and (effective) CC will be 2000mA.

> 
> The challenge I see in implementing the above requirements in charger manager is, some of  the above requirements are not supported by the regulator framework (disable/enable charger, Controlling the INLMT, disable h/w charge termination etc). So it would be difficult to control  the charger completely using a regulator framework. Also I would like to make the charging algorithm more generic and less dependent on the platform layer code. This includes implementing  a battery identification framework which will give the battery profile in a generic manner. 

You can implement a charger as a regulator (or a pair of regulators).
The one registered in charger_desc->charger_regulator->consumer enabled and disable
The one registered in charger_desc->charger_regulator->consumer controls current limit (along with extcon), INMNT

If you need to control CV (not supported, yet), another regulator, probably defined as charger_desc->battery_CV, maybe added.
As "CV" value is defined per battery (charger_desc), not per charger (charger_desc.charger_regulators), we need to have one per battery.
Maybe "CC" value may be added per battery (charger_desc) as well if it can be controlled independently, however, currently, it is a mere sum of INMNT values.


> 
> Considering all the requirements and challenges, I doubt supporting them in charger manager would be good or not. I am looking for your suggestions on this. 
> 
> Thanks in advance,
> -jtc

I think the features mentioned above are good to be included in charger manager as they look quite compatible with current structure with some modifications.



Thank you.


Cheers!
MyungJoo

> 
> > -----Original Message-----
> > From: MyungJoo Ham [mailto:myungjoo.ham@samsung.com]
> > Sent: Tuesday, June 26, 2012 6:27 AM
> > To: Tc, Jenny
> > Cc: linux-kernel@vger.kernel.org; Anton Vorontsov
> > (cbouatmailru@gmail.com); Anton Vorontsov (anton.vorontsov@linaro.org);
> > Pallala, Ramakrishna; √÷¬˘øÏ; π⁄∞ÊπŒ
> > Subject: Re: Charger Manager Proposal.
> > 
> > > MyungJoo,
> > >
> > > I would like to align with the charger-manager activities and would like to
> > propose few changes for charger-manager. The changes I would like to have
> > in the charger manager is
> > >
> > > 	* Manage charging based on a battery profile - Each battery  can have
> > a different  profile and the charging should be done based on this profile. So
> > there should be a mechanism inside the charger-manager to read the battery
> > profile. To start with we can make it available as platform data for the
> > charger-manager.
> > 
> > Yes, each instance of charger-manager devices represents a battery (or a set
> > of batteries controlled as a single battery.) Thus, the profile can be described
> > in struct charger_desc. What do you need additionally there?
> > 
> > > 	* The charge parameters (CC and CV) needs to be changed as per the
> > batter profile. The battery profile will have a different CC and CV for different
> > temperature zone. So charger-manager needs to listen  battery Temperature
> > change events (using power_supply_changed events from FG?)  and modify
> > the CC and CV.
> > 
> > Then, my suggestion is that
> > Plan A.
> >   1. Add a pair of CC and CV regulators at struct charger_desc, independently
> > defined in struct charger_desc from charger_desc.charger_regulators as
> > charger_regulators are to enable/disable chargers attached to the battery
> > described by struct charger_desc.
> >   2. Add an array of { temperature (min), CC-value, CV-value, hysterisis-temp
> > } with temperature = - MAX for "default" value.
> > Plan B.
> >   1. Add an array of { temperature (min), callback, hysterisis-temp}
> > 
> > If CC/CV values are the only ones to be controlled by temperature, Plan A is
> > fine. However, if we are going to need more, Plan B may be more
> > appropriate.
> > 
> > > 	* It's good to have a hybrid (Software and Hardware mode) full
> > detection logic. This give more flexibility to define the charge full detection
> > thresholds. So charger-manager can listen to charge-full detection from
> > charger-hardware and can start a thread to verify the thresholds from
> > software.
> > 
> > You can do this with cm_notify_event() and fullbatt_vchk() though we may
> > need more parameters to control the behavior of fullbatt_vchk().
> > 
> > > 	* Need to have a maintenance upper voltage threshold. The upper
> > threshold needs to be less than the Battery FULL voltage threshold and this
> > can part of battery profile. This approach helps to increase the battery life.
> > 
> > Could you please elaborate this one more? What do you do with "upper
> > threshold"?
> > 
> > >
> > > I would like to start implementing these features for charger manager. But I
> > would like to align with your planned charger-manager activities so that we
> > don't end up in duplicating the effort. Please let me know your suggestions
> > on this.
> > >
> > > -jtc
> > 
> > Another update or modification on-going is:
> > 	- Integrating with extcon subsystem
> > 	- Add current-limit for each charger
> > You can see the according patches at
> > http://git.infradead.org/users/kmpark/linux-
> > samsung/shortlog/refs/heads/charger-manager-for-next
> > 
> > 
> > Thanks. And sorry for late reply; we had the office moved which cut the
> > internetaccess for a while.
> > 
> > 
> > Cheers!
> > MyungJoo.
> 
> 
> 
> 
>        
>   
>          
> 
ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
