Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757220Ab1JCSjb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 14:39:31 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:40033 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab1JCSjY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 14:39:24 -0400
MIME-Version: 1.0
Date: Mon, 3 Oct 2011 20:39:23 +0200
Message-ID: <CAJ1PRSnQgaCr4s+JwmB3r_J9de5MHJKVwrxGnderYGqyVVMG3Q@mail.gmail.com>
Subject: cgroup blkio bug/feedback
From: "krzf83@gmail.com " <krzf83@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've been testing cgroup blkio controller in production eviroment for
many days now especialy blkio.throttle.write_iops_device and
blkio.throttle.read_iops_device. I'm using software raid so I have to
limit on devices like /dev/md2 which is 9:2 in my system. Limiting
works fine but every some time whole system overloads and only thing
to do is hard reboot. For two times this happened with cgroup that was
used to limit rsync-ing about 30GB of data. Somewhere in the middle
loadavg starts to rise quicly, shell hangs at every kill command and
soft reboot does not work. When I do echo "9:2 0" >
blkio.throttle.read_iops_device and echo "9:2 0" >
blkio.throttle.write_iops_device problem was immeadetly gone.
Unfortunetly I don't know how to get more information about this
durring such overload time, especialy since many commands does not
work (disk access however works fine during that time). So its more of
a feedback than a bug report unfortunately.
