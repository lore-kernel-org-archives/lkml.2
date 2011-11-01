Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754629Ab1KAMsg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 08:48:36 -0400
Received: from nm5-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.135]:42628 "HELO
	nm5-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754462Ab1KAMsf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 08:48:35 -0400
X-Yahoo-Newman-Id: 599406.29784.bm@smtp110.mail.ne1.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: vdZ1ENMVM1lqa55MZ.uwxG_Imea6zzC49hwkL7r2uDWTXsQ
 1Qpsg9ur4lFmQ.2vu8Fd85Sv_xGVoE.oAcOi9x.HS.roiVj1AQ0W7HjTF6v7
 l8NlUeEGxcMGXfNDZ_o0DIMsROxAUUBf4l2oc7LM_rrdZhcmMSJrs8wE.sNO
 JDnx0BcNq5.7PP7hckGnIoLZ7a8t5GkclEy2e6yOzWYj5lI6NJa.JCTzTBTc
 Q4_g7piTnyIXM69cyla58KCerhKve2f7h2gkrvDwrpPLScZZhHpxnv6WSmUa
 YMWRCYZfe04MOlme4bXe7l7Pk1MZF7AjsSDPpoasItYFeDmIlyXsDncrvCge
 RGU37nSgSFUBviSbMspfZg2Fi3i05ysykMOFJu9ebCQxCu.Cqyw--
X-Yahoo-SMTP: gvIQca6swBCF5pMq54eC.XuJ8SoqXA5fBgqzSmaH
Date: Tue, 1 Nov 2011 07:48:19 -0500
From: Andrew Watts <akwatts@ymail.com>
To: linux-kernel@vger.kernel.org
Cc: linux-pm@lists.linux-foundation.org, tj@kernel.org,
        dmitry.torokhov@gmail.com
Subject: [REGRESSION]: hibernate/sleep regression w/ bisection
Message-ID: <20111101124759.GA1326@zeus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

Hibernate/sleep (echo disk/mem > /sys/power/state) has presented problems
for me starting with 2.6.39. Kernel 2.6.37.6 was the last completely bug-free
version I used (I skipped the 2.6.38 branch entirely).

The symptoms are that upon resume (from sleep/hibernate) there is no video
nor any keyboard input with the exception of sysrq.

It has been a frustrating bug to hunt down because it is not easily
reproduced; sometimes the bug doesn't pop up until after a long sequence of
hibernate/sleep cycles.

I successfully bisected the problem to: 8ee294cd9def000.

=======
Commit: 8ee294cd9def0004887da7f44b80563493b0a097
Author: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Date:   Mon Nov 15 01:39:57 2010 -0800
Input: serio - convert to common workqueue instead of a thread
=======

Backing out 8ee294cd9def000 (which requires reversing part of
1d64b655dc083df also) fixes this particular problem on 2.6.39.4,
3.0.8, and 3.1.

Unfortunately, in 3.0.8 and 3.1 I have other suspend/hibernate problems
that I will investigate next and detail in a different regression report.

~ Andy

System specs: P4/Radeon GPU

