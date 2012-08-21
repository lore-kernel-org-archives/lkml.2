Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2HUIGi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 04:06:38 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:33826 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab2HUIGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 04:06:22 -0400
X-AuditID: cbfee61a-b7fc66d0000043b7-de-5033417b3565
From: Chanwoo Choi <cw00.choi@samsung.com>
To: anton.vorontsov@linaro.org
Cc: cbouatmailru@gmail.com, jenny.tc@intel.com, ramakrishna.pallala@intel.com,
        myungjoo.ham@samsung.com, kyungmin.park@samsung.com,
        linux-kernel@vger.kernel.org, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [PATCH 0/5] charger-manager: Update charger-manager to support various
 charging conditions
Date: Tue, 21 Aug 2012 17:05:59 +0900
Message-id: <1345536359-25778-1-git-send-email-cw00.choi@samsung.com>
X-Mailer: git-send-email 1.7.0.4
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrFJMWRmVeSWpSXmKPExsVy+t9jQd1qR+MAgweXrC0u75rD5sDo8XmT
	XABjFJdNSmpOZllqkb5dAlfGvZlPWAp28lZcfHuNrYFxAncXIyeHhICJxOE7v5ghbDGJC/fW
	s3UxcnEICUxnlLjSe4cFwlnKJLHq0UYWkCo2AS2J/S9usIHYIgJyEq/X/mUCKWIWOMUo8eji
	CbBRwgKpEps+NbOD2CwCqhLTjsxh7WLk4OAVcJXovJ4DsU1BonXZIfYJjNwLGBlWMYqmFiQX
	FCel5xrqFSfmFpfmpesl5+duYgT78JnUDsaVDRaHGAU4GJV4eH8sMgoQYk0sK67MPcQowcGs
	JMJbrW8cIMSbklhZlVqUH19UmpNafIhRmoNFSZyXv88wQEggPbEkNTs1tSC1CCbLxMEp1cB4
	3ED8zxKhtheFJ8RdM9PWdsTerLwQW7I5+NeO03qXpSKyNjef/bO8oOnmrcO8lgJ+8ovsHonf
	22x0Pznd/o7Kxu3RF5d9nV6+fcGRuA0NnN9OdBWmf9xh/MXRWnbLmojjgvdTymUO9a+4fKrL
	4tOpU1HuvUef5KpePmRyZ5+w69aPV2TkFoRtVmIpzkg01GIuKk4EAMt+GordAQAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset add new feature related to charging battery to complement
necessary feature for charging. This patchset include following new feature
for charging battery.

Explain implemented feature of this patchset:
- Code clean on first and second patch.
- Add support sysfs entry for charger(regulator) to control charger from user-space.
  If some development board use one more chargers(regulator) for charging but
  only need one charger on specific case which is dependent on user scenario
  or hardware restrictions, the user enter 1 or 0(zero) to "/sys/class/power_supply
  /battery/charger.[index]/externally_control". For example, if user enter 1 to
  "/sys/.../charger.[index]/externally_control", this charger isn't controlled
  from charger-manager and always stay off state of regulator.
- Check fully charged state of battery periodically to prevent overcharging.
- Limit maximum possible duration of charging to prevent overcharging,
  also check discharging duration to maintain fully charged state of battery
  and to prevent much drop voltage than given data through platform data of
  charger_desc.

Chanwoo Choi (5):
  charger-manager: Disable battery charging when charger cable is
    detached
  charger-manager: Use replacement variable to check state of battery
  charger-manager: Add support sysfs entry for charger
  charger-manager: Check fully charged state of battery periodically
  charger-manager: Support limit of maximum possible duration for
    charging/discharging

 drivers/power/charger-manager.c       |  437 +++++++++++++++++++++++++++++----
 include/linux/power/charger-manager.h |   45 +++-
 2 files changed, 429 insertions(+), 53 deletions(-)

