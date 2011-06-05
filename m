Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab1FEAIl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jun 2011 20:08:41 -0400
Received: from nm2.bt.bullet.mail.ird.yahoo.com ([212.82.108.233]:28235 "HELO
	nm2.bt.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754485Ab1FEAIj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jun 2011 20:08:39 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Sat, 04 Jun 2011 20:08:38 EDT
X-Yahoo-Newman-Property: ymail-3
X-Yahoo-Newman-Id: 501308.37572.bm@omp1001.bt.mail.ird.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=talk21.com;
  h=Message-ID:X-YMail-OSG:Received:X-Mailer:Date:From:Subject:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding;
  b=Wux+lRl5FMyjLss44RtE0q7Rw2MfNjZ/31O+8iozudcWTg4XZ/XsU7WYo/yVt4t4Vk/NTcyXvP95jgqEnHODEoD5XMvyn/Fm26PWnHCm17riCcHMZbBMooADeO5zBuziIDzHNabKE78h67rHloOzsn9pcLq2Himgf8+j9llnJoA=;
Message-ID: <327832.31822.qm@web87014.mail.ird.yahoo.com>
X-YMail-OSG: sIssEaIVM1lROFeQEr49GjGWhvo3aESBaub1luo0q7jJupm
 ohaYcO5RHEvpAXNWM8SknJW9S1MKih8h77grq4l2pF3kWISA67UJ5osYCnt5
 xKTCwgcsddovhJzGq_36T6Ojdlhk.LTbRPxMdob8UHeWaTlMNGfBxf0.XL5i
 V3nr348BarbqtXwGC03FrH004vA.WiMwDi5gAKmQdB7QsktNSZv1_oAm6E.G
 d5teZ4PdhRtRP6kqtnJ4py1wAPeSbZO0oZQMWATZqrE.cyYQBt4WdKDaQqr9
 7_KBBFmZc1D3MN8fPoK7lt3vio.RG.LU7Ll6boGdTFqSFjhDlQjuL4g5uFEK
 d9eQ1ruVq0VYQjbkmkLBMCAsCkwELYk0PaciYSQxW5Ei.rB5Ee_pSVnkY9lr
 bhsetDM6paCQnhlL94JHc.EdNEcAAdslDclFEDVinO1uSKeebSkvhH2LtoIN
 FyI2TuvurIXW3q0qlVJFCXZZuMoh9C.lFwwgHldWDsgPvMQiiYTzUm9x4U8P
 fY2UZUGJblfz7dAlGEl34ZNWDghrflje5
X-Mailer: YahooMailRC/570 YahooMailWebService/0.8.111.303096
Date: Sun, 5 Jun 2011 01:02:35 +0100 (BST)
From: Scott Ashcroft <scott.ashcroft@talk21.com>
Subject: Oops in i915 intel_init_clock_gating
To: jbarnes@virtuousgeek.org
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks like the following commit:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=6067aaeadb5b3df26f27ac827256b1ef01e674f5


didn't cope with the pineview case so dev_priv->display.init_clock_gating is 
NULL causing an Oops.

The old code didn't seem to do anything for pineview so I wrapped the call with 
a simple NULL check but I'm not sure if that's the correct fix.

Cheers,
Scott

