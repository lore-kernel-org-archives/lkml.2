Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760779Ab1LPXt0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 18:49:26 -0500
Received: from nm21.access.bullet.mail.sp2.yahoo.com ([98.139.44.148]:26119
	"HELO nm21.access.bullet.mail.sp2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751462Ab1LPXtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 18:49:21 -0500
X-Greylist: delayed 325 seconds by postgrey-1.27 at vger.kernel.org; Fri, 16 Dec 2011 18:49:21 EST
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 642568.77436.bm@omp1007.access.mail.sp2.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:Message-ID:Date:From:Reply-To:Subject:To:MIME-Version:Content-Type;
  b=ajLUpMfTfOi9cYv5JoPYUi9UrdhY9/lB+30V/Ho7zSNraHfY/VIJhMd6yUfjaShLP4bGBHbewhETjQ9RuMjLG0C7N2dKKPH/sjS0EETsqYULle8+ZJhlTxfVSxSOuhz4Gr5vVDJzo5fQDZ+881Lipf/clFnIpsLHLNjxCk2+7DI=;
X-YMail-OSG: S7zhgmUVM1lTbLR7oEmEftj_iY3nJh9rIZGJjdWmjkgCy2l
 flY6yjDkx5ErC3Ux2b_7f6ak0H9zs0xFVfW6eGT0D7Ks7M8_aqGTkFtdhXHb
 lvn4aSzhPSkOhec3.ZWDx6PAASOb2hdOQ6eNfrBK2lpdjd53VQzzS8xSWMZv
 Lp.DfDEJjSpgC.3mjzNQn9sp_Ve5TalHTw9kIdyAHfG2HOCu2.pmzpPYXp3A
 brN8_ehNmU9ZFGiWmdeKVXnnMOD8jVTPkR3Ovdc6TxkaLgTwtrkf13CWXezM
 Ol7lmkqGg1236appZ.YbuS_R3bLBaOX4Oneg4re4eLYvVJsnPaclAT0plzQ.
 siT9Ui.dE48.rHFu2f3irn5hiID4fez1nlf4VfpielPApyAv4NhSzL3W1Qhr
 dtXUvcRERX84mzTvE5I8wsLzA.2MMPlnl0Qj1WRyST3A07D5K73fpxYMYXuq
 8rTqjAmYs6uwJUliH3MQ_3Qc2tCDcOz8U
X-Mailer: YahooMailClassic/15.0.4 YahooMailWebService/0.8.115.331698
Message-ID: <1324079035.93669.YahooMailClassic@web84519.mail.ne1.yahoo.com>
Date: Fri, 16 Dec 2011 15:43:55 -0800 (PST)
From: d.stussy@yahoo.com
Reply-To: software+linux-kernel@kd6lvw.ampr.org
Subject: Kernel non-fatal(?) bug - IPsec - Holding atomic when calling scheduler.
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm getting a whole bunch of these (hostname deleted):

Dec  5 11:09:27 - kernel: BUG: scheduling while atomic:
named/909/0x00000200
Dec  5 11:09:27 - kernel: Modules linked in: xt_geoip ipt_set
ip_set_nethash ip_set xt_recent xt_TARPIT compat_xtables
Dec  5 11:09:27 - kernel: Pid: 909, comm: named Not tainted 3.1.4 #6
Dec  5 11:09:27 - kernel: Call Trace:
Dec  5 11:09:27 - kernel:  [<ffffffff8142b633>] ? __schedule+0x5d3/0x7a0
Dec  5 11:09:27 - kernel:  [<ffffffff8102ff3d>] ?
select_task_rq_fair+0x3ad/0x800
Dec  5 11:09:28 - kernel:  [<ffffffff8102f680>] ?
check_preempt_wakeup+0xe0/0x140
Dec  5 11:09:28 - kernel:  [<ffffffff8142bd2d>] ?
schedule_timeout+0x1bd/0x220
Dec  5 11:09:28 - kernel:  [<ffffffff8142aeca>] ?
wait_for_common+0xda/0x190
Dec  5 11:09:28 - kernel:  [<ffffffff81034cd0>] ?
try_to_wake_up+0x260/0x260
Dec  5 11:09:28 - kernel:  [<ffffffff81306b75>] ?
flow_cache_flush+0x75/0x90
Dec  5 11:09:28 - kernel:  [<ffffffff81383a8b>] ?
__xfrm_garbage_collect+0xb/0x90
Dec  5 11:09:28 - kernel:  [<ffffffff813c2171>] ?
xfrm6_garbage_collect+0x11/0x30
Dec  5 11:09:28 - kernel:  [<ffffffff812fc79b>] ? dst_alloc+0x13b/0x170
Dec  5 11:09:28 - kernel:  [<ffffffff81387c47>] ?
xfrm_bundle_lookup+0x287/0x3d0
Dec  5 11:09:28 - kernel:  [<ffffffff81306929>] ?
flow_cache_lookup+0x259/0x430
Dec  5 11:09:28 - kernel:  [<ffffffff813879c0>] ?
xfrm_policy_lookup_bytype.clone.42+0x250/0x250
Dec  5 11:09:28 - kernel:  [<ffffffff81386ef8>] ? xfrm_lookup+0x238/0x4d0
Dec  5 11:09:28 - kernel:  [<ffffffff813997d8>] ?
ip6_sk_dst_lookup_flow+0xe8/0x170
...
After this point, the call chain varies, and so does the process causing
it.  After about 1000 of such reports, the system usually crashes.

Prior to activating IPsec, I did not see these problems.  I have both IPv4 and IPv6 stacks on an x86-64 bit system.  I have ipsec-tools v0.8.0 as the user interface to IPsec.  I am using only transport mode, although tunnel mode is available (an unloaded module) and the user program does present a listener on UDP 4500 (as well as 500).  I have set all 3 IPsec options (ah, esp, and comp) to optional ("use" if available).

I see this ONLY when the kernel finds an IPsec policy statement (SPD) where there is no corresponding IPsec authorization definition (SAD) and therefore it is presumedly calling the userspace process via the PF_KEY interface to contact the remote side to do IPsec key exchange (IKE) via UDP port 500 (or 4500 if I had tunnel mode defined).  The problem does NOT surface when I have IPsec not loaded/compiled or when I do but the SPD table is empty.  If the SPD has policies which define none or discard, the issue does seem to happen.

I have seen this bug with kernel releases 3.1.4 and 3.1.5.  It may exist prior to those but I wasn't actively using IPsec before then.

Fix - guide to solution:  What atomic lock is being held when the scheduler is called?

Please fix this soon.  After a few hundred of these, the kernel seems to get sufficiently confused that it crashes and I have to hard-reset the machine.

