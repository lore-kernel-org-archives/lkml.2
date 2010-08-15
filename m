Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081Ab0HOFZr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Aug 2010 01:25:47 -0400
Received: from smtpauth.tellcom.com.tr ([92.45.6.165]:24793 "EHLO
	smtpout1.superonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751933Ab0HOFZq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Aug 2010 01:25:46 -0400
Message-ID: <4C677A49.4030904@superonline.com>
Date: Sun, 15 Aug 2010 08:25:29 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100813 Icedove/3.1.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: [Bisected Regression in 2.6.35] A full tmpfs filesystem causes hibernationto hang
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: 2.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello all,

I am using Debian Sid on a Toshiba Satellite A100 laptop. After testing
2.6.35 for a while, I noticed that sometimes my hibernation attempts
would fail. I should say that I never had such a problem before 2.6.35.
The hibernation process hangs with 2.6.35 after printing the following:

=== 8< ===
...
Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
PM: Preallocating image memory...
=== >8 ===

After a short investigation, I found out that this only happens when my
tmpfs filesystem on /tmp had a lot of data in it. When my tmpfs is empty,
I have no problems.

So I wrote a short script which fills up the tmpfs on /tmp and tries to
hibernate, and I bisected the kernel using this script.

The end result is that the following commit causes this regression:

=== 8< ===
commit bb21c7ce18eff8e6e7877ca1d06c6db719376e3c
Author: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date:   Fri Jun 4 14:15:05 2010 -0700

    vmscan: fix do_try_to_free_pages() return value when priority==0 reclaim failure

    ...
=== >8 ===

I have run 2.6.35-rc6, 2.6.35 and 2.6.35.1 with this commit reverted,
and I am happy to say that I haven't experienced any problems for at
least 17 days.

It looks like this change was included with 2.6.35-rc1. I am sorry
for not testing earlier.

I am willing to do testing in case anyone would like me to try patches.

Regards,

M. Vefa Bicakci
