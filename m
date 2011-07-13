Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab1GMV4B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 17:56:01 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:52444 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab1GMV4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 17:56:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM mailing list <linux-pm@lists.linux-foundation.org>
Subject: [PATCH 0/3] PM / Domains / shmobile fixes
Date: Wed, 13 Jul 2011 23:52:59 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Paul Mundt <lethal@linux-sh.org>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201107132352.59801.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The following three patches fix a couple of issues in the code currently
in my pm-domains branch at:

git://git.kernel.org/pub/scm/linux/kernel/git/rafael/suspend-2.6.git pm-domains

[1/3] - Use genpd_queue_power_off_work() for queuing up the powering off
        of A4LC (this avoids attempting to queue up a work item while it is
        pending).

[2/3] - Make the generic PM domains code react to -EBUSY returned from a
        PM domain's .power_down() callback (needed for [3/3]).

[3/3] - Return -EBUSY from the A4LC's .power_down() callback to indicate that
        the domain hasn't been powered down on purpose and remove the confusing
        (and now redundant) pm_genpd_poweron(A4LC) from pd_power_down_a3rv().

Thanks,
Rafael
