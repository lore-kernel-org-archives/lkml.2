Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754910Ab0I1Nc2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 09:32:28 -0400
Received: from n21.bullet.mail.ukl.yahoo.com ([87.248.110.138]:36227 "HELO
	n21.bullet.mail.ukl.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754837Ab0I1Nc0 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 09:32:26 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 964373.17069.bm@omp237.mail.ukl.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.co.uk;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=gYfuFHY2i1ENyipWRkyu5ZPxLTnSz//XHCOXfwfbzlp/q8PCJ0Gia2KbTQuBpI5+IZOyKhTDt5KsZKTsOCkYM4Mxh9XGMLPa2kesTyHNrAa10yolAzhkBg6nL3Z8R5ASm5JetFsDUYtSOeMtclEKy8pxXUCQVMN9k7b+TFuDM+c=;
Message-ID: <864381.11683.qm@web25607.mail.ukl.yahoo.com>
X-YMail-OSG: blf3sCcVM1kQumVvFnPq7030h605xCXaeHowTG8cMJHbVJQ
 dGrfymuGPK05rGOsM7GG9rtw3N9IPSw6SLB5lgim4.f95ArMwf20NFCwg.qJ
 RD3Od_p_Re9LWj9rh90IiXVRLoLkF42O6oFVOEQMwrXP0CCig8GZQbYCJTuO
 pgw0YQghibaf4R6LsygVwqYm0A2O3jyfO8G4E1guS3dHaxrzV5Sw3oL9OBJf
 pMBwSoUmoim.9YKDvRRLN74B1g.RBAAbdZcoWRbbdZQ--
X-Mailer: YahooMailClassic/11.4.9 YahooMailWebService/0.8.105.279950
Date: Tue, 28 Sep 2010 13:32:24 +0000 (GMT)
From: emre kara <emrekara2002@yahoo.co.uk>
Subject: powerpc kernel 2.6.35.6 crash with gianfar ethernet at full line rate traffic 
To: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Cc: emrekara2002@yahoo.co.uk
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I have a serious problem with latest stable kernel (2.6.35.6) and gianfar ethernet driver.

I'am using default SMP kernel configuration and MPC8572DS development board and also using an hardware packet generator.

My test is ip forwarding between eth0 and eth1, and Hardware packet generator produces full duplex, full line rate traffic with random packet length and random payload . After 1.2 billion packet passed, kernel produces this bellow crash message.

I have done same test with an intel quad core pc and sky2 gigabit ethernet controller. No errors occured yet. So that it seems that this problem may be  related with gianfar.

Any comment and help are appreciated.



Thanks.

Emre





------------[ cut here ]------------

kernel BUG at net/core/skbuff.c:127!

Oops: Exception in kernel mode, sig: 5 [#1]

SMP NR_CPUS=8 MPC8572 DS

last sysfs file: /sys/devices/pci0002:03/0002:03:00.0/subsystem_device

Modules linked in:

NIP: c0255260 LR: c0255260 CTR: c0221f64

REGS: effebd70 TRAP: 0700   Not tainted  (2.6.35.6)

MSR: 00029000 <EE,ME,CE>  CR: 24028022  XER: 20000000

TASK = ef03ce10[3] 'ksoftirqd/0' THREAD: ef04a000 CPU: 0

GPR00: c0255260 effebe20 ef03ce10 0000007c 00021000 ffffffff c0225ac0 c04364cc

GPR08: c042e9ac c04364e0 effea000 c0430000 20028048 1001a108 ef550000 ef0f6d70

GPR16: ef0f6e18 ef0f685c 00000000 ef550800 00000008 00000001 ef0f6800 0000003f

GPR24: ef141a80 ef0f6b60 00000000 ef550950 ef0f6b60 00000420 ef3f0400 ef525600

NIP [c0255260] skb_put+0x8c/0x94

LR [c0255260] skb_put+0x8c/0x94

Call Trace:

[effebe20] [c0255260] skb_put+0x8c/0x94 (unreliable)

[effebe30] [c023e004] gfar_clean_rx_ring+0x10c/0x4d8

[effebe90] [c023e794] gfar_poll+0x3c4/0x5f4

[effebf60] [c0262498] net_rx_action+0xf8/0x1a4

[effebfa0] [c0049dcc] __do_softirq+0xe0/0x178

[effebff0] [c0010790] call_do_softirq+0x14/0x24

[ef04bf50] [c0004868] do_softirq+0x90/0xa0

[ef04bf70] [c004a98c] run_ksoftirqd+0xb4/0x164

[ef04bfb0] [c005dacc] kthread+0x78/0x7c

[ef04bff0] [c0010b9c] kernel_thread+0x4c/0x68

Instruction dump:

81030098 2f800000 409e000c 3d20c03d 3809e0d8 3c60c03d 7c8802a6 7d695b78

3863ee60 90010008 4cc63182 4bdefaa9 <0fe00000> 48000000 9421fff0 7c0802a6

Kernel panic - not syncing: Fatal exception in interrupt

Call Trace:

[effebb20] [c00082fc] show_stack+0x4c/0x180 (unreliable)

[effebb50] [c0043720] panic+0xa0/0x11c

[effebbe0] [c000db44] die+0x184/0x1d0

[effebc10] [c000dcfc] _exception+0x114/0x130

[effebd60] [c0011440] ret_from_except_full+0x0/0x4c

--- Exception: 700 at skb_put+0x8c/0x94

    LR = skb_put+0x8c/0x94

[effebe30] [c023e004] gfar_clean_rx_ring+0x10c/0x4d8

[effebe90] [c023e794] gfar_poll+0x3c4/0x5f4

[effebf60] [c0262498] net_rx_action+0xf8/0x1a4

[effebfa0] [c0049dcc] __do_softirq+0xe0/0x178

[effebff0] [c0010790] call_do_softirq+0x14/0x24

[ef04bf50] [c0004868] do_softirq+0x90/0xa0

[ef04bf70] [c004a98c] run_ksoftirqd+0xb4/0x164

[ef04bfb0] [c005dacc] kthread+0x78/0x7c

[ef04bff0] [c0010b9c] kernel_thread+0x4c/0x68

Rebooting in 180 seconds..


      

