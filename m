Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab1GaSYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jul 2011 14:24:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:36811 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752494Ab1GaSYG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jul 2011 14:24:06 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/9] PM / Domains: Allow generic PM domains to have multiple parents
Date: Sun, 31 Jul 2011 19:46:06 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107311946.06654.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset modifies the generic PM domains code so that it's possible
for a PM domain to have multiple parent domains (i.e. domains it depends on).
This makes the framework applicable to more use cases and allows us to
address one issue one a system already using it.

Patch [1/9] is for 3.1, patches [2-9/9] are 3.2 material, if there are no
objections.

[1/9] - Fix genpd_power_on().
[2/9] - Make subdomain counts be atomic.
[3/9] - Don't acquire parent locks in genpd_power_on() and genpd_power_off().
[4/9] - Make genpd_power_on() always survive parent removal.
[5/9] - Add PM domain status value GPD_STATE_WAIT_PARENT.
[6/9] - Allow generic PM domains to have multiple parents.
[7/9] - Rename GPD_STATE_WAIT_PARENT to GPD_STATE_WAIT_MASTER.
[8/9] - Rename the second argument of pm_genpd_add_subdomain().
[9/9] - Make A3RV be a subdomain of A4LC on SH7372.

Thanks,
Rafael
