Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753940Ab1HZUJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 16:09:00 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:36010 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868Ab1HZUI7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 16:08:59 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6450"; a="113302992"
Message-ID: <4E57FD5A.5080005@codeaurora.org>
Date: Fri, 26 Aug 2011 13:08:58 -0700
From: Jeff Ohlstein <johlstei@codeaurora.org>
User-Agent: Thunderbird 2.0.0.24 (X11/20100623)
MIME-Version: 1.0
To: linux-pm@lists.linux-foundation.org
CC: LKML <linux-kernel@vger.kernel.org>
Subject: Sysfs nodes deleted and recreated on SMP suspend
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So I have been working with the cpufreq sysfs nodes on an SMP system,
and one thing I noticed is that they go away each time I suspend and
resume. This is due to the use of the hotplug mechanism for suspend. I
am able to handle these failures by checking for the error and reopening
the file, but having to do this each time the system suspends seems
unnecessary to me.

Does anyone see any value in making these nodes stay around, at least in
the suspend case of hotplug? I understand that they should go away on
systems where a cpu can actually be physically removed, but if we are
just suspending it seems like we should be as transparent to userspace
as possible.

Jeff
-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
