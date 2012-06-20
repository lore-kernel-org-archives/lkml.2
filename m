Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab2FTJlR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 05:41:17 -0400
Received: from mga09.intel.com ([134.134.136.24]:29610 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756176Ab2FTJlO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 05:41:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="159951433"
From: "Tc, Jenny" <jenny.tc@intel.com>
To: "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Anton Vorontsov (cbouatmailru@gmail.com)" <cbouatmailru@gmail.com>,
        "Anton Vorontsov (anton.vorontsov@linaro.org)" 
	<anton.vorontsov@linaro.org>,
        "Pallala, Ramakrishna" <ramakrishna.pallala@intel.com>
Subject: Charger Manager Proposal.
Thread-Topic: Charger Manager Proposal.
Thread-Index: Ac1OyM5M4skyl4l9RsWEumrV58dVvQ==
Date: Wed, 20 Jun 2012 09:41:02 +0000
Message-ID: <20ADAB092842284E95860F279283C564286A0B@BGSMSX101.gar.corp.intel.com>
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

MyungJoo,

I would like to align with the charger-manager activities and would like to propose few changes for charger-manager. The changes I would like to have in the charger manager is 

	* Manage charging based on a battery profile - Each battery  can have a different  profile and the charging should be done based on this profile. So there should be a mechanism inside the charger-manager to read the battery profile. To start with we can make it available as platform data for the charger-manager.
	* The charge parameters (CC and CV) needs to be changed as per the batter profile. The battery profile will have a different CC and CV for different  temperature zone. So charger-manager needs to listen  battery Temperature change events (using power_supply_changed events from FG?)  and modify the CC and CV.
	* It's good to have a hybrid (Software and Hardware mode) full detection logic. This give more flexibility to define the charge full detection thresholds. So charger-manager can listen to charge-full detection from charger-hardware and can start a thread to verify the thresholds from software. 
	* Need to have a maintenance upper voltage threshold. The upper threshold needs to be less than the Battery FULL voltage threshold and this can part of battery profile. This approach helps to increase the battery life.

I would like to start implementing these features for charger manager. But I would like to align with your planned charger-manager activities so that we don't end up in duplicating the effort. Please let me know your suggestions on this.

-jtc


