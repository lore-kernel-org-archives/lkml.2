Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756894Ab2FYVR4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 17:17:56 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:56284 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756024Ab2FYVRz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 17:17:55 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
Cc: snanda@chromium.org
Subject: [BUG, Regression, bisected] Marvell 88E8055 NIC (sky2) fails to
 detect carrier after resume from S3
To: linux-kernel@vger.kernel.org
Date: Mon, 25 Jun 2012 23:17:51 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
From: "Michal Zatloukal" <myxal.mxl@gmail.com>
Message-ID: <op.wgg9f1g716tawo@esprimo>
User-Agent: Opera Mail/11.62 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.
Note: Please CC me into replies, I'm not subscribed. Thank you.

I'm the reporter of Ubuntu bug 1007841
<https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1007841> and would
like to bring attention to it here, since it's in upstream kernel as well.
You can find all details collected by apport there. The gist of the
problem is, since around 3.2 (I haven't kept up-to-date and mostly used
2.6.35 on the machine), whenever I wake up the laptop from S3 by opening
the lid, the NIC loses carrier detection and it's reported as always down.

I have done bisection (my first, so don't automatically assume it's done
correctly ;-)  and have found the offending commit to be:

commit 7afe1845dd1e7c90828c942daed7e57ffa7c38d6
Author: Sameer Nanda <snanda@chromium.org>
Date: Mon Jul 25 17:13:29 2011 -0700

init: skip calibration delay if previously done

Hence, CCing author.
Let me know if I should supply any more info.

Best Regards,
Michal Zatloukal

-- 
Using Opera's revolutionary email client: http://www.opera.com/mail/
