Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab1ICWPf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 18:15:35 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60806 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab1ICWPe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 18:15:34 -0400
Date: Sat, 3 Sep 2011 17:14:56 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Amit Shah <amit.shah@redhat.com>,
        David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Jean Schurger <jean@schurger.org>,
        Jan =?utf-8?B?TMO8YmJl?= <jluebbe@debian.org>,
        Matthijs Kooijman <matthijs@stdin.nl>,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Nacho Barrientos Arias <nacho@debian.org>
Subject: [regression] CD-ROM polling blocks suspend on some machines (Re:
 [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20110903221456.GA2877@elie>
References: <20110406121920.GC4142@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110406121920.GC4142@mtj.dyndns.org>
User-Agent: Mutt/1.5.21+46 (b01d63af6fea) (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Various people[1] have been noticing a race (or races?) in which the
cdrom_id and scsi_id programs from udev can get stuck in the D state
if udev doesn't sleep a little while before running them.  This
prevents the machine from suspending.  The problem was discovered with
Debian kernels

  2.6.39-1
  2.6.39-2
  3.0.0-1

and was not experienced with kernel

  2.6.38-5

(These kernels are closely based on v2.6.39, v2.6.39.1, v3.0, and
v2.6.38.5, respectively.)  Reverting commit bf2253a6f00e (cdrom:
always check_disk_change() on open, 2011-04-29) seems to avoid
trouble.

One common theme seems to be DVD drives.  Details at [1].

Known problem?  Any ideas for tracking it down?

Looking forward to your thoughts,
Jonathan

[1] <http://bugs.debian.org/628600>.  Submitters cc-ed.
