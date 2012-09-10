Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372Ab2IJVV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:21:57 -0400
Received: from nm13-vm3.bullet.mail.ne1.yahoo.com ([98.138.91.143]:33204 "HELO
	nm13-vm3.bullet.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753884Ab2IJVV4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:21:56 -0400
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 47955.91636.bm@omp1046.mail.ne1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Mailer:References:Message-ID:Date:From:Reply-To:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=hrbti2uoY5sMGNd43evebTfCT+XBeFmMUcgzZdvwXZO5PxX764Wi8RD51xCPo5fZPU9rW6Iy4qxLpv4ZPOal1Ada4F3ViZRK/8eQBntCQplVakkoaJt++7d/THwkMTY+EsTIVY+Z+4ox0oZCPK9iIeR6iOUOIXkWT2L2MdS5rus=;
X-YMail-OSG: MeLje2oVM1nZ_Sp0SqrWn8qS6i9oNZvsRa6SzNAixQDWn65
 VVWgaZaC2S3OLu7tbSmGVNKNvgGqwCMZ1RsDjVX32f7tMf00vu5_Q4MYoHi9
 rpgPu.kM5.E4qO6a1Dyv3ni4vqRy1jBPPSZJxOZBTnUZyvqeoBG9HumRaIYk
 DHBY2hnWRYpCtA2a7HdlHS.RIel2n1c_xHdSGy2U4D7qq_q7wsiYL.qkXJl.
 sDFYjTsHFMF6_CQ4uThmzIgEXbuEQ8y.vEz.1WHT8bKL0OpSzxAKPiUaJ_R_
 .i4BggbNPEW.VloLe4mHTUHaiAMUQ0EzlxZQlHEijD6u54LSusISPVe4Qqm7
 x1xRxCoH2CvN_q4xIJvecAYU443sxlLeXTZ_CvlbkInAV12.4aONbaJ9SLDe
 dqs1sYFAqWFZ38Ojpqc1nPYhHPsK57m7suv.ndLB4GlSCCWvsq30Wi4f4utf
 kUoGOzJ6S1sA7BdJ1YPvli6JciqiLK7zPxoZiZiI9
X-Mailer: YahooMailWebService/0.8.121.416
References: <504B4F2D.40002@yahoo.com> <s5hligitcd0.wl%tiwai@suse.de> <1347272938.6237.YahooMailNeo@web120301.mail.ne1.yahoo.com> <s5hfw6qtbhq.wl%tiwai@suse.de>
Message-ID: <1347312114.44166.YahooMailNeo@web120301.mail.ne1.yahoo.com>
Date: Mon, 10 Sep 2012 14:21:54 -0700 (PDT)
From: Chris Rankin <rankincj@yahoo.com>
Reply-To: Chris Rankin <rankincj@yahoo.com>
Subject: Re: [alsa-devel] snd-intel-hda: screaming IRQ with 3.5.3 kernel (HDMI)
To: Takashi Iwai <tiwai@suse.de>
Cc: "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <s5hfw6qtbhq.wl%tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----

>  Did you try any workaround boot options such as irqpoll, pci=nocrs or whatever?

Actually, it turns out that booting with "irqpoll=1" simply means that this problem takes longer to happen:

irq 17: nobody cared (try booting with the "irqpoll" option)
Pid: 3347, comm: wineserver Not tainted 3.5.3 #2
Call Trace:
 [<c1063806>] ? __report_bad_irq+0x11/0x94
 [<c1063a2d>] ? note_interrupt+0x120/0x19b
 [<c1062325>] ? handle_irq_event_percpu+0xe8/0xfb
 [<c1062361>] ? handle_irq_event+0x29/0x40
 [<c1064163>] ? handle_fasteoi_irq+0x67/0x90
 [<c1003957>] ? handle_irq+0x63/0x70
 [<c1003625>] ? do_IRQ+0x2e/0x83
 [<c1229829>] ? common_interrupt+0x29/0x30
handlers:
[<f8d09b75>] azx_interrupt [snd_hda_intel]
Disabling IRQ #17

Cheers,
Chris
