Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135Ab1GGVRm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 17:17:42 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36693 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750798Ab1GGVRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 17:17:40 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH] power: introduce Charger-Manager
Date: Thu, 7 Jul 2011 23:18:45 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc5+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@lists.linux-foundation.org, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, Randy Dunlap <rdunlap@xenotime.net>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, dg77.kim@samsung.com,
        myungjoo.ham@gmail.com, "Greg Kroah-Hartman" <gregkh@suse.de>,
        linux-kernel@vger.kernel.org
References: <1309424069-15965-1-git-send-email-myungjoo.ham@samsung.com>
In-Reply-To: <1309424069-15965-1-git-send-email-myungjoo.ham@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201107072318.45500.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, June 30, 2011, MyungJoo Ham wrote:
> Charger Manager provides in-kernel battery charger management that
> requires temperature monitoring during both normal and suspend-to-RAM states
> and where each battery may have multiple chargers attached and the userland
> wants to look at the aggregated information of the multiple chargers.
> 
> For the discussions about the need for in-suspend monitoring, please
> refer to the discussions of suspend-again in PM:
> v1 https://lists.linux-foundation.org/pipermail/linux-pm/2011-April/031052.html
> v2 https://lists.linux-foundation.org/pipermail/linux-pm/2011-April/031111.html
> v3 https://lists.linux-foundation.org/pipermail/linux-pm/2011-May/031267.html
> v4 https://lists.linux-foundation.org/pipermail/linux-pm/2011-May/031357.html
> v5 (last, applied) https://lists.linux-foundation.org/pipermail/linux-pm/2011-June/031561.html
> 
> To see the usage example, please refer to:
> http://git.infradead.org/users/kmpark/linux-2.6-samsung/shortlog/refs/heads/charger-manager
> In this git branch, a test code for Exynos4-NURI is shown.
> 
> Charger Manager is a platform_driver with power-supply-class entries.
> An instance of Charger Manager (a platform-device created with
> Charger-Manager) represents a battery with chargers. If there are multiple
> batteries with their own chargers acting independently in a system,
> the system may need multiple instances of Charger Manager.
> 
> Charger Manager glues multiple charger-related frameworks (regulators of
> chargers, power-supply-class from chargers and fuel-gauge, RTC,
> suspend-again, ...) together to provide aggregated information and
> transparent battery monitoring to userspace.
> 
> Because battery health monitoring should be done even when suspended,
> it needs to wake up and suspend periodically. Thus, userspace battery
> monitoring may incur too much overhead; every device and task is waked
> up periodically. Charger Manager uses suspend-again (in next PM) to provide
> in-suspend monitoring. Multiple chargers (e.g., USB, wireless, and solar
> panels) may be included as pairs of a regulator and a power-supply-class
> per charger. Charger Manager provides power-supply-class aggregating
> information from multiple chargers and a fuel-gauge and UEVENT notifying
> status changes.  Multiple instances of Charger Manager enable multiple
> batteries.
> 
> Signed-off-by: MyungJoo Ham <myungjoo.ham@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

I have tried to review this patch, but it is _huge_.  Is there any reasonable
way to split it into a series of smaller patches that would be easier to
comprehend?

Rafael
