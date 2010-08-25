Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab0HYKLB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 06:11:01 -0400
Received: from smtpauth.tellcom.com.tr ([92.45.6.165]:40217 "EHLO
	smtpout1.superonline.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753035Ab0HYKK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 06:10:58 -0400
Message-ID: <4C74EC1F.2050107@superonline.com>
Date: Wed, 25 Aug 2010 13:10:39 +0300
From: "M. Vefa Bicakci" <bicave@superonline.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.8) Gecko/20100821 Icedove/3.1.2
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Bisected Regression in 2.6.35] A full tmpfs filesystem causeshibernationto hang
References: <4C7214DD.30500@superonline.com> <20100824094152.F3B0.A69D9226@jp.fujitsu.com> <20100825173231.F3E7.A69D9226@jp.fujitsu.com>
In-Reply-To: <20100825173231.F3E7.A69D9226@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-SMTP-Filter: SurGATE SMTP Filter Engine Release 2.1 ($Revision: 184 $) http://www.endersys.com
X-SurGATE-Result: Clean (Content eval: -7.00 points)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(Sorry, I am sending this again as I forgot to include LKML in the CC.)

On 25/08/10 11:39 AM, KOSAKI Motohiro wrote:
> 
> Can you please try to avoid to use /tmp. As I said,
> 
> mount -t tmpfs none /mnt/another_tmpfs
> dd if=/dev/zero of=/mnt/another_tmpfs/tmp bs=1024k count=1600
> shred -vn1 /mnt/another_tmpfs/tmp
> 
> 
> That said, We need to know you issue is lots-anon-pages issue or 
> filesystem-full issue.

Hello,

I have changed my configuration so that I have a 8 gigabyte large
swap partition, and I have also made the changes you suggested
to my hibernation/fill-tmpfs script so that a tmpfs other than
/tmp is used.

Unfortunately, nothing changed. I still get hangs after a few lines
are printed to the console. The last two lines are from your patch.
Here is an observation from an actual test which ended with a hang:

=== 8< ===
PM: Preallocating image memory
shrink_all_memory: start
shrink_all_memory: req: 375019 reclaimed: 48055 free: 326810
=== >8 ===

One thing I should note is that, before your commit, I never had
any problems even though my swap size was not two times the size
of my physical memory and even though I used tmpfs as /tmp.

If there is anything I can do to debug this problem please let me
know.

Regards,

M. Vefa Bicakci


