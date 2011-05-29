Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1E2U1q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 16:27:46 -0400
Received: from a.ns.miles-group.at ([95.130.255.143]:41873 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751408Ab1E2U1p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 16:27:45 -0400
From: Richard Weinberger <richard@nod.at>
To: cl@linux.com
Subject: slub: UML and CONFIG_CMPXCHG_LOCAL
Date: Sun, 29 May 2011 22:25:46 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.37.6-0.5-desktop; KDE/4.6.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, penberg@kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105292225.46544.richard@nod.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph,

With commit 1759415e you've removed all #ifdef CONFIG_CMPXCHG_LOCAL's from slub.
This change breaks slub (again) on UML.
UML does not implement this_cpu_cmpxchg16b_emu().

Starting with 2.6.39 (commit 084189a) I've disabled CONFIG_CMPXCHG_LOCAL on UML do bypass the issue.
This fix does no longer help.

Is there anything I can do to have slub on UML?
Implementing this_cpu_cmpxchg16b_emu for UML is not really an option.
See:
http://comments.gmane.org/gmane.linux.kernel/1125183

Thanks,
//richard


