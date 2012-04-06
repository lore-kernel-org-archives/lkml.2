Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756920Ab2DFAbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:31:09 -0400
Received: from mailout3.samsung.com ([203.254.224.33]:13566 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab2DFAbH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:31:07 -0400
X-AuditID: cbfee61a-b7c49ae0000061d4-ad-4f7e39461b94
Message-id: <4F7E3945.6000800@samsung.com>
Date: Fri, 06 Apr 2012 09:31:01 +0900
From: Chanwoo Choi <cw00.choi@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216
 Thunderbird/10.0.2
MIME-version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-pm@vger.kernel.org,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: [RESEND PATCH v2 0/2] power_supply: update Charger-Manager
References: <4F72FF0F.3000107@samsung.com>
In-reply-to: <4F72FF0F.3000107@samsung.com>
X-Forwarded-Message-Id: <4F72FF0F.3000107@samsung.com>
Content-type: text/plain; charset=ISO-8859-1
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Initially, the main role of Charger-Manager is to monitor battery health
while the system is in suspend-to-RAM.

This patchset updates the initial Charger-Manager to poll the battery state
in normal state and provide function for in-kernel use.

As Mr. Kim Donggeun leaved the company as personal reason, I follow up of
this patchset. So I replied about your comment based on following link
last week.
- https://lkml.org/lkml/2012/2/29/506
- https://lkml.org/lkml/2012/2/29/524
- https://lkml.org/lkml/2012/3/4/137

The following patch url are replies which was posted on last week.
Re: power_supply: Charger-Manager: poll battery health in normal state
- https://lkml.org/lkml/2012/3/19/733
Re: power_supply: Charger-Manager: provide function for in-kernel use
- http://comments.gmane.org/gmane.linux.kernel/1270020

v2
- Code clean according to comment of Rafael J. Wysocki
- Use Power management wakeup interface for waking up the system
  from sleep when event is happended
- Cancle work/delayed_work in remove function

Donggeun Kim (2):
  power_supply: Charger-Manager: poll battery health in normal state
  power_supply: Charger-Manager: provide function for in-kernel use

 Documentation/power/charger-manager.txt |   41 +++-
 drivers/power/charger-manager.c         |  391
+++++++++++++++++++++++++++++++
 include/linux/power/charger-manager.h   |   49 ++++-
 3 files changed, 471 insertions(+), 10 deletions(-)
