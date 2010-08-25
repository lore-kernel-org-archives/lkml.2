Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab0HYIjX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:39:23 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:36606 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751684Ab0HYIjV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:39:21 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: "M. Vefa Bicakci" <bicave@superonline.com>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernation to hang
Cc: kosaki.motohiro@jp.fujitsu.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <20100824094152.F3B0.A69D9226@jp.fujitsu.com>
References: <4C7214DD.30500@superonline.com> <20100824094152.F3B0.A69D9226@jp.fujitsu.com>
Message-Id: <20100825173231.F3E7.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Wed, 25 Aug 2010 17:39:17 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > #!/bin/bash
> > 
> > rm -vf /tmp/tmp
> > dd if=/dev/zero of=/tmp/tmp bs=1024k count=1600
> > shred -vn1 /tmp/tmp
> > 
> > exit 0 ### removed when testing hibernation
> > 
> > read -p "Press enter to hibernate..."
> > 
> > echo -n reboot > /sys/power/disk
> > echo -n disk > /sys/power/state
> > 
> > echo "Exit code: $?"
> > 
> > rm -vf /tmp/tmp
> 
> Almostly same with my test program ;)

Can you please try to avoid to use /tmp. As I said,

mount -t tmpfs none /mnt/another_tmpfs
dd if=/dev/zero of=/mnt/another_tmpfs/tmp bs=1024k count=1600
shred -vn1 /mnt/another_tmpfs/tmp


That said, We need to know you issue is lots-anon-pages issue or 
filesystem-full issue.


