Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752055Ab1CUITi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 04:19:38 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:33271 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826Ab1CUITf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 04:19:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=r88/kwIfArnuW9pG4dH1lQaYLp3yyIMD2tma1ctTOAjuvcmTBaKgghKAWF3V/dKKxl
         54HBfJov1Oz3UTJt2HjaY/lrqAf6zH9CM4vZ3luJ+OPb+9byHqY2Hn3ZuiM23q7s87UC
         +qoVaggEg1EgiBlAJ7vyc6dPnx54TiCKUtrGM=
Subject: Re: [PATCH v2] net: add Faraday FTGMAC100 Gigabit Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        ratbert@faraday-tech.com
In-Reply-To: <AANLkTinibrF_bJBbYwCSnGv1iD_9Dn7uBn2cqgcTrKHi@mail.gmail.com>
References: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com>
	 <1300355238-1619-1-git-send-email-ratbert.chuang@gmail.com>
	 <1300357457.3133.92.camel@edumazet-laptop>
	 <AANLkTino6LzGTZF4fNSkV9pbAfnmAc8wJjk0L8HfHDiJ@mail.gmail.com>
	 <1300361405.3133.175.camel@edumazet-laptop>
	 <AANLkTinibrF_bJBbYwCSnGv1iD_9Dn7uBn2cqgcTrKHi@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Mar 2011 09:19:29 +0100
Message-ID: <1300695569.2831.535.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le lundi 21 mars 2011 à 15:54 +0800, Po-Yu Chuang a écrit :
> It seems to work fine so far at least the driver is not broken, but I did not
> see much difference in performance though. How do I know if GRO is
> working indeed?

maybe you receive one interrupt per incoming frame, and your cpu is fast
enough to handle the load.

tcpdump should show big incoming TCP frames (multi segment)

(GRO only helps TCP receivers)

Example here :


09:16:32.372949 IP 192.168.20.110.55446 > 192.168.20.108.ssh: .
2372863:2374311(1448) ack 3136 win 73 <nop,nop,timestamp 317934201
257881345>

09:16:32.372975 IP 192.168.20.110.55446 > 192.168.20.108.ssh: .
2374311:2377207(2896) ack 3136 win 73 <nop,nop,timestamp 317934201
257881345>


Here, you can see GRO work, since 2nd "frame" is the result of two MTU
sized frames. 



