Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761201Ab2EIUnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:43:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:59393 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761092Ab2EIUnO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:43:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Felipe Contreras <felipe.contreras@gmail.com>
Subject: Re: Big I/O latencies, except when iotop is hooked
Date: Wed, 9 May 2012 20:43:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <CAMP44s2eVtquLoB6Zjbs4nGVKP6e=Dxse4uicL4s8vmrFeJdTQ@mail.gmail.com> <201205091756.16050.arnd@arndb.de> <CAMP44s2eKgTzn9q1CN1X-8P+m0bcTw+UCz7FGQ1ekjzRe8j0SQ@mail.gmail.com>
In-Reply-To: <CAMP44s2eKgTzn9q1CN1X-8P+m0bcTw+UCz7FGQ1ekjzRe8j0SQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201205092043.11544.arnd@arndb.de>
X-Provags-ID: V02:K0:OwxTQdwRWJOpV30nH8caxv0lg2rml4CQ7qsLJhwQQym
 7iNvHH6ANVLMJigDhJd4gv6Ll5Hp0qxE/fU3jejRAmimAWButl
 dRjvUVQ3C015/tvJEZ+27TGLA+AYvvqwgwkLAOU/FCDK5YKkJ4
 3wDcXEFk6AD7PDwSOjaecKGEb9DizCW543+/xU5L8zndCeAj+G
 no+rOt3ro7MnhzeBc1vH0g5ZFKgZRTCqVBOqcZ1YcMuui1EOIG
 gaM2kPuBlkdnOwup5oZCjGkupCH7cFeTk3fXMlNMKFp/5QhKAv
 5SHhcV2CIDS4TmzkfPO14/OAUI88dDQBMgyFCmTWnrMN3vV0Da
 TY+dxi5KSV9C3+zPwuuc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, Felipe Contreras wrote:
> And it doesn't tell me why I see the issue on my SSD as well; albeit
> with much less delay.
> 
> I'll try what you suggest, maybe I will get better performance by
> aligning the partitions, but the real issue seems to lie elsewhere,
> right?

For anything but the absolute worst devices, misaligning the partition
should cause a linear increase in latency (maybe factor 2 in the worst
case), so it doesn't explain the entire thing. However, you can use
flashbench to find out the erase block size. If it's larger than 4MB,
you definitely have a problem even with ext4 or btrfs. The latencies
you get from garbage collection for a single write are roughly the time
it takes to write one erase block, and that can be up to a second in the
worst case (slow media with large erase blocks).

	Arnd
