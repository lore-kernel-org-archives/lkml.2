Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758030Ab2FZA5O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 20:57:14 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:41048 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757830Ab2FZA5G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 20:57:06 -0400
X-AuditID: cbfee60d-b7f056d000004fc9-dd-4fe908df1719
Date: Tue, 26 Jun 2012 00:57:03 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: Charger Manager Proposal.
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
X-MTR: 20120626005055283@myungjoo.ham
Msgkey: 20120626005055283@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20120626005055283@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <27205114.39211340672223116.JavaMail.weblogic@epv6ml01>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMIsWRmVeSWpSXmKPExsVy+t/tmbr3OV76G+yfZWZxedccNgdGj8+b
	5AIYo7hsUlJzMstSi/TtErgyfnT/Yi7Ypljxvnc+ewPjEYUuRk4OIQF1iUVLTrKB2BICJhK9
	/6exQNhiEhfurQeKcwHVzGeU6Du3ihkkwSKgKvHxyA7WLkYODjYBPYmZn5NBwsICahInbn1k
	ArFFBFQkprZ8ZwLpZRboZ5Zo27+HCWKZksSafa/AFvAKCEqcnPkEapmqxKe5X5kg4moSv7f8
	ZoaIS0jMmn6BFcLmlZjR/hSqXk5i2tc1UDXSEudnbWCEOXrx98dQcX6JY7d3MIHcCdL75H4w
	zJjdm79A/SsgMfXMQahWLYlfCy5Axfkk1ix8C7aKWUBRYkr3Q3YIW0viy499bKjO5wCynSXe
	zPWfwCgzC0lmFpLuWUi6kdUsYGRZxSiaWpBcUJyUnmqsV5yYW1yal66XnJ+7iREctc94dzDO
	bbA4xCjAwajEw2vA8NJfiDWxrLgy9xCjBAezkgjv7hsv/IV4UxIrq1KL8uOLSnNSiw8xSnOw
	KInzTrG+4C8kkJ5YkpqdmlqQWgSTZeLglGpg5Do2R4bhepP9HbOOW0s7jkj+2NgsoRC+dMJ5
	xlu1lr9Yp7jXPVCYkH9zG3efXPbladHZcmW2VmyyMhPC/He1SAo0qd7S+ybRXyshvHz6p1Bl
	1Wa9v0+1u76Kds82FRY2KLS+cuvU1JT2QxL6+Srz1lvwxDsGhx1ZM52t5OahG1EulRvZOsOU
	WIozEg21mIuKEwHOm5e11gIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q5Q0vVk2002044

> MyungJoo,
> 
> I would like to align with the charger-manager activities and would like to propose few changes for charger-manager. The changes I would like to have in the charger manager is 
> 
> 	* Manage charging based on a battery profile - Each battery  can have a different  profile and the charging should be done based on this profile. So there should be a mechanism inside the charger-manager to read the battery profile. To start with we can make it available as platform data for the charger-manager.

Yes, each instance of charger-manager devices represents a battery (or a set of batteries controlled as a single battery.) Thus, the profile can be described in struct charger_desc. What do you need additionally there?

> 	* The charge parameters (CC and CV) needs to be changed as per the batter profile. The battery profile will have a different CC and CV for different  temperature zone. So charger-manager needs to listen  battery Temperature change events (using power_supply_changed events from FG?)  and modify the CC and CV.

Then, my suggestion is that
Plan A.
  1. Add a pair of CC and CV regulators at struct charger_desc, independently defined in struct charger_desc from charger_desc.charger_regulators as charger_regulators are to enable/disable chargers attached to the battery described by struct charger_desc.
  2. Add an array of { temperature (min), CC-value, CV-value, hysterisis-temp } with temperature = - MAX for "default" value.
Plan B.
  1. Add an array of { temperature (min), callback, hysterisis-temp}

If CC/CV values are the only ones to be controlled by temperature, Plan A is fine. However, if we are going to need more, Plan B may be more appropriate.

> 	* It's good to have a hybrid (Software and Hardware mode) full detection logic. This give more flexibility to define the charge full detection thresholds. So charger-manager can listen to charge-full detection from charger-hardware and can start a thread to verify the thresholds from software. 

You can do this with cm_notify_event() and fullbatt_vchk() though we may need more parameters to control the behavior of fullbatt_vchk().

> 	* Need to have a maintenance upper voltage threshold. The upper threshold needs to be less than the Battery FULL voltage threshold and this can part of battery profile. This approach helps to increase the battery life.

Could you please elaborate this one more? What do you do with "upper threshold"?

> 
> I would like to start implementing these features for charger manager. But I would like to align with your planned charger-manager activities so that we don't end up in duplicating the effort. Please let me know your suggestions on this.
> 
> -jtc

Another update or modification on-going is:
	- Integrating with extcon subsystem
	- Add current-limit for each charger
You can see the according patches at 
http://git.infradead.org/users/kmpark/linux-samsung/shortlog/refs/heads/charger-manager-for-next


Thanks. And sorry for late reply; we had the office moved which cut the internetaccess for a while.


Cheers!
MyungJoo.

ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
