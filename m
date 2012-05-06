Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754285Ab2EFRkH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 May 2012 13:40:07 -0400
Received: from plane.gmane.org ([80.91.229.3]:32843 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab2EFRkG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 May 2012 13:40:06 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Uwe Bonnes <bon@elektron.ikp.physik.tu-darmstadt.de>
Subject: Re: [PATCH] drivers:gpu:vga_switcheroo: Work around dramatic power drain in laptops
Date: Sun, 6 May 2012 17:36:43 +0000 (UTC)
Message-ID: <jo6crb$qpl$1@dough.gmane.org>
References: <1335645928-30993-1-git-send-email-alexander.tarasikov@gmail.com> <1335645928-30993-2-git-send-email-alexander.tarasikov@gmail.com> <20120428221003.49fb248d@pyramind.ukuu.org.uk> <CAMChaFwhgrQN864=q6-dKD=b8y9=1HJL+qpdSHFn4ts2rW7omA@mail.gmail.com>
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: elektron.ikp.physik.tu-darmstadt.de
User-Agent: tin/1.8.2-20060425 ("Shillay") (UNIX) (Linux/2.6.13-15.18-default (i686))
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexander Tarasikov <alexander.tarasikov@gmail.com> wrote:
> 2012/4/29 Alan Cox <alan@lxorguk.ukuu.org.uk>:
> > The module parameter is probably the wrong long term option. Do you know
> > if the problem is general or specific to some laptops. If it's the latter
> > then it might also be worth implementing a DMI and/or PCI detection
> > routine to match the laptops you know are afflicted and automatically
> > enabled it.
> > Alan

> I agree that module parameter is not a good idea, but I have seen a
> lot of reports of the problem and no patches were proposed, 
> so I tried to do what I could. It
> could be a good temporary solution until we make sure it does not break
> any configurations. I am unsure how muxless/muxed cards may differ in
> behaviour.

> I suspect that the problem is specific to all laptops with
> intel+radeon combination.

Intel+Nvidia combination seems to be affected too!

> So far I have found these reports of radeon eating battery

> [2010] Acer TravelMate Timeline 8371
> [2012] Hp Envy 14 https://bugs.launchpad.net/ubuntu/+source/linux/+bug/909337
> [2012] Thinkpad T400 https://bbs.archlinux.org/viewtopic.php?id=133329
> [2012] Sony Vaio SE15 (VPCSE1v9E)
> http://blog.ejbca.org/2012/02/ubuntu-gnulinux-1204-precise-on-sony.html

I can confirm the problem with an intel+nvidia combination, on a Thinkpad T520:
> lspci |grep -i VGA
00:02.0 VGA compatible controller: Intel Corporation 2nd Generation Core \
Processor Family Integrated Graphics Controller (rev 09)
01:00.0 VGA compatible controller: nVidia Corporation GF119 [Quadro NVS 4200M] (rev ff)

I suspend with "DIS"cret graphics off. Resuming comes up with about 5 Watt
more power drain compared before suspend. Switching "DIS" needs another 5
Watt. Switching "DIS" off again brings me back to the power drain level
before suspend.

I vote for Alexander proposal!

Bye

-- 
Uwe Bonnes                bon@elektron.ikp.physik.tu-darmstadt.de

Institut fuer Kernphysik  Schlossgartenstrasse 9  64289 Darmstadt
--------- Tel. 06151 162516 -------- Fax. 06151 164321 ----------

