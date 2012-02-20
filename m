Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab2BTKCj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 05:02:39 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:42029 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752524Ab2BTKCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 05:02:22 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jirislaby@gmail.com designates 10.213.3.198 as permitted sender) smtp.mail=jirislaby@gmail.com; dkim=pass header.i=jirislaby@gmail.com
Message-ID: <4F421A29.6060303@suse.cz>
Date: Mon, 20 Feb 2012 11:02:17 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120215 Thunderbird/10.0.2
MIME-Version: 1.0
To: n-horiguchi@ah.jp.nec.com, kamezawa.hiroyu@jp.fujitsu.com,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Slaby <jirislaby@gmail.com>,
        linux-mm@kvack.org
Subject: Regression: Bad page map in process xyz
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm getting a ton of
BUG: Bad page map in process zypper  pte:676b700029736c6f pmd:44967067
when trying to upgrade the system by:
zypper dup

I bisected that to:
commit afb1c03746aa940374b73a7d5750ee05a2376077
Author: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Date:   Fri Feb 17 10:57:58 2012 +1100

    thp: optimize away unnecessary page table locking

thanks,
-- 
js
suse labs
