Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab2JJLXT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 07:23:19 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:64739 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550Ab2JJLXS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 07:23:18 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>, <e1000-devel@lists.sf.net>
Cc: <support@Supermicro.com>, <ap@solarrain.com>
References: <003901cda66b$836a5db0$8a3f1910$@lucidpixels.com> <001201cda6cf$d9de5480$8d9afd80$@lucidpixels.com>
In-Reply-To: <001201cda6cf$d9de5480$8d9afd80$@lucidpixels.com>
Subject: RE: X9SCM-F/82574L/e1000e lag / high latency (e1000e/Intel bug)
Date: Wed, 10 Oct 2012 07:23:16 -0400
Message-ID: <001f01cda6d9$a505d7b0$ef118710$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQIdryc2JFTBlaO/4vE9Qu1npX97rgLBELm6lvxL17A=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



-----Original Message-----
From: Justin Piszcz [mailto:jpiszcz@lucidpixels.com] 
Sent: Tuesday, October 09, 2012 6:15 PM
To: linux-kernel@vger.kernel.org; e1000-devel@lists.sf.net
Cc: support@Supermicro.com; ap@solarrain.com
Subject: X9SCM-F/82574L/e1000e lag / high latency (e1000e/Intel bug)

If you have > 16GB do not upgrade to 2.0b, I am writing up a page on this
and will post it shortly, the board will show 32GB with 2.0b but when it
tries to address it, the machine reboots.  Stick with 2.0a for now, I will
call Supermicro later, will post a page on all of these issues in a bit.

--

As promised:
https://sites.google.com/a/lucidpixels.com/web/blog/supermicrox9scm-fissues

Summary:

1. the board does not always address 32GB of ram if you are using an Ivy
Bridge chip on this motherboard
2. e1000e network problems
    a) During heavy network I/O (file copy) on eth0 the network latency
jumps to 300-1000ms+ every 4-5 seconds (it does not do this on a separate
card)
    b) During heavy network I/O (file copy) of over 600GB of files, the
kernel disabled the network IRQ on eth0 and took the server offline from a
network perspective (it has not done this on a separate card..yet)
3. Problems with PCI-e cards
    summary: Don't expect to use all four PCI-e slots if they use a lot of
power
4. clock drift issues:
  summary: expect some strangeness if you use gpsd/a gps to help sync your
time, due to what SM noted below
    http://lists.ntp.org/pipermail/pool/2012-July/006019.html

here is a picture of memtest86 showing "Unexpected Interrupt - Halting" when
2.0b BIOS is used with 32gb of ram:
http://home.comcast.net/~jpiszcz/20121010/x9scm-web-small.jpg

here is the issue with memtest86 (crashes/reboots host when you have 2.0b +
32gb of ram):
https://www.youtube.com/watch?feature=player_embedded&v=M2TWO5kFm9U

Justin.

