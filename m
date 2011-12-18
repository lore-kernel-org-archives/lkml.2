Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751955Ab1LRRQs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Dec 2011 12:16:48 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43115 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751831Ab1LRRQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Dec 2011 12:16:46 -0500
MIME-Version: 1.0
Date: Sun, 18 Dec 2011 19:16:44 +0200
Message-ID: <CAKt3ReLqE-s4bCLh_afpyPAPBiWYnzOgSYOD4=wRAYhzV4ZCGA@mail.gmail.com>
Subject: Kernel migration thread cpu usage is crazy in 3.1.5
From: "Darius D." <darius.ski@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


there has already been a report about migration thread CPU usage
craziness in 3.2 ( https://lkml.org/lkml/2011/11/17/375 ), but it is
in 3.1.5 as well.

problem manifests itself like this: after some time top/ps starts
reporting huge time for migration/X threads, adding them 1 at time
with larger and larger values (sometimes already existing entry is
"incremented" ), so after a while it looks like this:

   47 root      RT   0     0    0    0 S    0  0.0   1100:35 [migration/14]
   14 root      RT   0     0    0    0 S    0  0.0   1081:39 [migration/3]
   50 root      RT   0     0    0    0 S    0  0.0 978:44.59 [migration/15]
   53 root      RT   0     0    0    0 S    0  0.0 840:53.83 [migration/16]
   74 root      RT   0     0    0    0 S    0  0.0 779:58.12 [migration/23]
   44 root      RT   0     0    0    0 S    0  0.0 773:43.01 [migration/13]
   41 root      RT   0     0    0    0 S    0  0.0 539:50.44 [migration/12]
   59 root      RT   0     0    0    0 S    0  0.0 380:05.40 [migration/18]
   56 root      RT   0     0    0    0 S    0  0.0 293:07.90 [migration/17]
   68 root      RT   0     0    0    0 S    0  0.0 150:10.87 [migration/21]
   26 root      RT   0     0    0    0 S    0  0.0 145:13.37 [migration/7]
   11 root      RT   0     0    0    0 S    0  0.0 130:11.83 [migration/2]

sar and other tools are not showing any increased cpu activity ( no
misreporting, as box is under very low load and power usage would
shoot sky high if there was some well hidden cpu usage )


System is dual Xeon X5650 NUMA box. Last kernel it was running with
same kernel config was 2.6.39.2.
The only outside visible "change" i have noticed is this:
In munin graphs during low activity periods there were ~1k Local timer
interrupts, after booting 3.1.5 graphs are completely different, now
there are just ~500 Local timer interrupts, but Rescheduling
interrupts are ~400 ( used to be none on low load ). Is this related
to crazy cpu usage problem ?


Darius.
