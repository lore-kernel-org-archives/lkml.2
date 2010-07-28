Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755094Ab0G1TdS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 15:33:18 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:12545 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754723Ab0G1TdP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 15:33:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6057"; a="49104461"
From: Patrick Pannuto <ppannuto@codeaurora.org>
To: linux-kernel@vger.kernel.org
Cc: ppannuto@codeaurora.org, apw@canonical.com, corbet@lwn.net
Subject: [PATCH v2 0/4] timer: Added usleep[_range] timer
Date: Wed, 28 Jul 2010 12:33:03 -0700
Message-Id: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After writing both documentation and a checkpatch rule explaining
why the usleep API should never be used, it occurred to me that
perhaps such an API should never be added :) - at least not in its
previous form.

This iteration is similar, with the notable difference that now
usleep has a "built-in slack" of 200%. This is analogous to msleep,
which has a built-in slack of 0.4% (since it relies on legacy timers,
which have a built-in slack of 0.4%). 200% slack is significantly
greater than 0.4%, but the scale of usleep is also significantly
different than that of msleep, and I believe 200% to be a sane
default.

It is my opinion that this interface will most often mirror what
developers actually intend - indeed some people who have begun
trying to use the API raised this point -, however, I would like
some input as it is possibly confusing that the API will "double
your sleep" by default.

The usleep_range API is still included, since it provides an
interface to override the "default slack" of 200% by providing
an explicit range, or to allow callers to specify an even larger
slack if possible.


This patch series is NOT based off of tip (read: it will conflict
with the previous usleep patch in -mm) since it is slighly
different, and Andrew Morton lamented to loss of the detailed
changelog info in the previous iteration - it is included here.

This series also includes the "full set", that is
   1: Adds the usleep[_range] API
   2: Adds timers-howto documentation
   3: Checkpatch: prefer usleep over udelay
   4: Checkpatch: warn about unexpectedly long msleep's


*** Changes in v2
   * Add "default slack" to usleep
   * Fix missing usec->nsec for delta in do_usleep_range
   * Fix Documentation typos
   * Better checkpatch regex's

