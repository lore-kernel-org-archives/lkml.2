Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932170Ab1KOT4L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:56:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:41854 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932077Ab1KOT4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:56:10 -0500
MIME-Version: 1.0
From: Andy Lutomirski <luto@amacapital.net>
Date: Tue, 15 Nov 2011 11:55:48 -0800
Message-ID: <CALCETrXXT09XPHkX8iRwDLgG2pOkmmqG4H6k7RBW3RMWvfeKJQ@mail.gmail.com>
Subject: sysrq-w and sysrq-t useless with cgroups and systemd enabled?
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

For several kernel and Fedora versions now, I've gotten only garbage
out of sysrq-w and sysrq-t.  The output looks like this:

[432904.642680] rt_rq[0]:/system/home.mount
[432904.642681]   .rt_nr_running                 : 0
[432904.642682]   .rt_throttled                  : 0
[432904.642682]   .rt_time                       : 0.000000
[432904.642683]   .rt_runtime                    : 0.000000
[432904.642685]
[432904.642685] rt_rq[0]:/system/boot-efi.mount
[432904.642686]   .rt_nr_running                 : 0
[432904.642687]   .rt_throttled                  : 0
[432904.642688]   .rt_time                       : 0.000000
[432904.642689]   .rt_runtime                    : 0.000000
[432904.642690]
[432904.642690] rt_rq[0]:/system/boot.mount
[432904.642691]   .rt_nr_running                 : 0
[432904.642692]   .rt_throttled                  : 0
[432904.642693]   .rt_time                       : 0.000000
[432904.642694]   .rt_runtime                    : 0.000000
[432904.642695]
[432904.642695] rt_rq[0]:/system/fsck@.service
[432904.642696]   .rt_nr_running                 : 0
[432904.642697]   .rt_throttled                  : 0
[432904.642698]   .rt_time                       : 0.000000
[432904.642699]   .rt_runtime                    : 0.000000
[432904.642700]
[432904.642700] rt_rq[0]:/system/cryptsetup@.service
[432904.642701]   .rt_nr_running                 : 0
[432904.642702]   .rt_throttled                  : 0
[432904.642703]   .rt_time                       : 0.000000
[432904.642704]   .rt_runtime                    : 0.000000
[432904.642705]
[432904.642706] rt_rq[0]:/system/dev-mapper-vg_midnight_ssd\x2dswap.swap
[432904.642707]   .rt_nr_running                 : 0
[432904.642708]   .rt_throttled                  : 0
[432904.642708]   .rt_time                       : 0.000000
[432904.642709]   .rt_runtime                    : 0.000000

except that it goes on for pages and pages.  I can't find any
information about actual hung tasks in the mess (even by searching the
log -- I think the interesting information is either not there or is
so swamped by log spew that it's actually getting lost by my syslog
daemon).

Is this some kind of bad interaction between scheduling groups and the
task dumper that's getting exacerbated by the huge number of cgroups
that systemd creates?

--Andy
