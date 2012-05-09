Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760678Ab2EIR4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 13:56:19 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:53892 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754027Ab2EIR4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 13:56:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: Big I/O latencies, except when iotop is hooked
Date: Wed, 9 May 2012 17:56:15 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAMP44s2eVtquLoB6Zjbs4nGVKP6e=Dxse4uicL4s8vmrFeJdTQ@mail.gmail.com>
In-Reply-To: <CAMP44s2eVtquLoB6Zjbs4nGVKP6e=Dxse4uicL4s8vmrFeJdTQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205091756.16050.arnd@arndb.de>
X-Provags-ID: V02:K0:D68caDW6HjKkSiedbDgiSAGTEaO4qZhaLeLzko4l9cp
 nEDv0GLkSq4ilLXBQJnu+ryfUeJnURH/VjA0RnKj/wTCVDCkDg
 P0+sinERudyZRdLpWhZZY8SbWUFCcOoUUzwdyQbMh1AHklPuNc
 u/B7/pDqSkAKl3n+re7vQgZRGvsDCtn0tKY2BFg85nD1yoB+du
 RiozI0sZHAXG+UiIRAKfu7/7kFMJmSq1xVPkuzaVBN1vygrt9R
 NJEMTDMDhijokNmHZXVeJoFposf3uhIfgIbOiC9fzmc2I6CVzV
 /wClpg7DmnyLySGkMI21ZlRQQ6tbPDz5ZYrkBmaT/+ufB6D85P
 bHc3FThS/E3IvA5Iy4bk=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, Felipe Contreras wrote:
> I've been noticing big I/O latencies when doing operations with
> notmuch (xapian database), the operations are quite simple and
> probably should not need a lot of I/O, however, they seen to take a
> long time, sometimes even seconds. But when I hook iotop (-p pid), the
> latency goes away, and every operation is reliably instantaneous
> (basically).
> 
> Do you have any ideas what might be causing this delay, and why is
> iotop making it go away?
> 
> BTW. This is an ext4 encrypted partition on a USB stick, I tried
> different mount options without any noticeable change. I tried to copy
> the data to my SSD drive and do the same operations, while it was much
> faster, it still seemed to have some delays triggered randomly. This
> is with v3.3.5.

USB sticks like most other cheap flash media tend to have long latencies
because of the effects I describe on https://lwn.net/Articles/428584/.

I don't know if you have the chance to run flashbench[1] on it (which
will destroy the data for the partition you are testing), but that
should at least tell you if it's a problem with the drive.
You can also use the information from that and combine it with
a blocktrace log and flashsim[2] to see where the actual latencies
are expected to happen.

The first thing you should check is whether the partitions are
properly aligned, using 'fdisk -l -u /dev/sdX'.

Of course none of this will tell you why iotop makes any difference.

	Arnd

[1] http://git.linaro.org/gitweb?p=people/arnd/flashbench.git
[2] http://yxit.co.uk/public/flash-performance/flashsim/
