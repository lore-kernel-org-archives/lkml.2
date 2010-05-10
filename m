Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756551Ab0EJKZ5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 06:25:57 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:33210 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756432Ab0EJKZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 06:25:55 -0400
X-SecurityPolicyCheck: OK by SHieldMailChecker v1.5.1
Message-ID: <9D38EE7159934A5C85505E9517638040@rainbow>
From: "Iram Shahzad" <iram.shahzad@jp.fujitsu.com>
To: <linux-kernel@vger.kernel.org>
References: <20090206060328.181057235@goodmis.org>
Subject: hrtimer: about hres_active
Date: Mon, 10 May 2010 19:27:06 +0900
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-2022-jp";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Priority: 3
X-MSMail-Priority: Normal
X-Mailer: Microsoft Outlook Express 6.00.2900.5843
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.5579
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

I am trying to understand the purpose of "hres_active" of hrtimer
and have the following question in this regard.

It seems "hres_active" indicates whether high resolution mode is
active or not. But I am not clear about the idea behind it.

I see that hres_active is initialized to 0 here:
    hrtimer_init_hres

and set to 1 here:
    hrtimer_run_pending
       -> hrtimer_switch_to_hres

That means hrtimer becomes "active" at the 1st timer softirq
and remains so forever. Is this understanding correct?

My original concern is as follows:

hrtimer_get_next_event returns KTIME_MAX when hrtimer is "active".
So if the above understanding is correct, then after the 1st timer
softirq it will always return KTIME_MAX. This means cpu_idle will never
take the hrtimer event into account and will always base its decision
on the next event of the timer wheel. Is this intended behaviour?

I would highly appreciate any information about this.
Please CC me because I am not a member of this ML.

Best regards
Iram


