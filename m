Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111Ab1HVKKr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:10:47 -0400
Received: from rrzmta1.uni-regensburg.de ([194.94.155.51]:54383 "EHLO
	rrzmta1.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753084Ab1HVKKn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:10:43 -0400
Message-Id: <4E52473A020000A1000070BC@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 22 Aug 2011 12:10:34 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Cc: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
Subject: Q: /sys/block and I/O Schedulers
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I have a question: Reading the docs on I/O Schedulers, I had the impression the docs wanted to tell me that only the low-level devices (i.e. disks) use I/O Schedulers, while higher-level devices (like multipaths, RAIDs, LVs, etc.) don't.

Using the SLES11 SP1 kernel (2.6.32.43-0.4-xen), I found out that LVs seem to use the I/O Scheduler, while RAID1 don't seem to do so. Also a disk in a Xen DomU also uses an I/O Scheduler (in addition to those being used in Dom0 for the same device already)

Is that correct, and if so, why is that? Is there a change to be seen in the future?

My test was as simple as this:
/sys/block # for d in *
> do
> echo $d: $(<$d/queue/scheduler)
> done
cciss!c0d0: noop anticipatory deadline [cfq]
dm-0: noop anticipatory deadline [cfq]
[...]
loop0: none
[...]
md4: none
sda: noop anticipatory deadline [cfq]
[...]

As I'm not subscribed to the list, I'd appreciate any CC: to my address. Thanks!

Regards,
Ulrich


