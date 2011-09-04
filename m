Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753128Ab1IDCmy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Sep 2011 22:42:54 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41938 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752828Ab1IDCmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Sep 2011 22:42:53 -0400
Date: Sun, 4 Sep 2011 11:42:44 +0900
From: Tejun Heo <tj@kernel.org>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>, Amit Shah <amit.shah@redhat.com>,
        David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Jean Schurger <jean@schurger.org>,
        Jan =?iso-8859-1?Q?L=FCbbe?= <jluebbe@debian.org>,
        Matthijs Kooijman <matthijs@stdin.nl>,
        Jameson Graef Rollins <jrollins@finestructure.net>,
        Nacho Barrientos Arias <nacho@debian.org>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines (Re:
 [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20110904024244.GB3083@htj.dyndns.org>
References: <20110406121920.GC4142@mtj.dyndns.org>
 <20110903221456.GA2877@elie>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110903221456.GA2877@elie>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Sep 03, 2011 at 05:14:56PM -0500, Jonathan Nieder wrote:
> Various people[1] have been noticing a race (or races?) in which the
> cdrom_id and scsi_id programs from udev can get stuck in the D state
> if udev doesn't sleep a little while before running them.  This
> prevents the machine from suspending.  The problem was discovered with
> Debian kernels
> 
>   2.6.39-1
>   2.6.39-2
>   3.0.0-1
> 
> and was not experienced with kernel
> 
>   2.6.38-5
> 
> (These kernels are closely based on v2.6.39, v2.6.39.1, v3.0, and
> v2.6.38.5, respectively.)  Reverting commit bf2253a6f00e (cdrom:
> always check_disk_change() on open, 2011-04-29) seems to avoid
> trouble.
> 
> One common theme seems to be DVD drives.  Details at [1].
> 
> Known problem?  Any ideas for tracking it down?

Can you please build vanilla kernel with CONFIG_FRAME_POINTER turned
on, reproduce the problem and attach full dmesg output?

Thanks.

-- 
tejun
