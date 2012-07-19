Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346Ab2GSPmo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 11:42:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:54956 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031Ab2GSPml (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 11:42:41 -0400
MIME-Version: 1.0
Date: Thu, 19 Jul 2012 09:42:40 -0600
X-Google-Sender-Auth: gz3tSZSN6k3hbAY6Ur71lJSzsds
Message-ID: <CAMLZHHR=9J0o43xYFBP34vFst4q1DpzEVtgVpyg4BDbq5=8g0g@mail.gmail.com>
Subject: Loop device partition scanning is unreliable
From: Daniel Drake <dsd@laptop.org>
To: kzak@redhat.com, kay.sievers@vrfy.org
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm having trouble with the loop device partition scanning code.

If I create a blank file, put a partition table on it with fdisk, and
then immediately turn it into a partitioned loop device, the
partitions dont always show up.

Here is a script to test this:
http://dev.laptop.org/~dsd/20120719/loop-partition.sh

I have reproduced this on 5 systems, a mixture of 32 and 64 bit. It
doesn't seem to matter if the underlying filesystem is ext4 or tmpfs.
I've reproduced it on 3.3, 3.4.5 and 3.5-rc7.

On some systems it seems to always fail within 8 loops. On others it
takes more time (100+ loops). I think it crashes more reliable when
the system is under load - I'm testing with stress
(http://weather.ou.edu/~apw/projects/stress/): stress -c 6 -m 6 -d 1

Any thoughts?

Thanks,
Daniel
