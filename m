Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750888Ab1IKEIh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Sep 2011 00:08:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:44678 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750733Ab1IKEIg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Sep 2011 00:08:36 -0400
Date: Sun, 11 Sep 2011 13:08:26 +0900
From: Tejun Heo <tj@kernel.org>
To: Matthijs Kooijman <matthijs@stdin.nl>
Cc: Jameson Graef Rollins <jrollins@finestructure.net>,
        Jonathan Nieder <jrnieder@gmail.com>, Jens Axboe <axboe@kernel.dk>,
        Amit Shah <amit.shah@redhat.com>, David Zeuthen <zeuthen@gmail.com>,
        Martin Pitt <martin.pitt@ubuntu.com>,
        Kay Sievers <kay.sievers@vrfy.org>, linux-kernel@vger.kernel.org,
        Jean Schurger <jean@schurger.org>,
        Jan =?iso-8859-1?Q?L=FCbbe?= <jluebbe@debian.org>,
        Nacho Barrientos Arias <nacho@debian.org>
Subject: Re: [regression] CD-ROM polling blocks suspend on some machines (Re:
 [PATCH 1/2] cdrom: always check_disk_change() on open)
Message-ID: <20110911040826.GP29319@htj.dyndns.org>
References: <20110406121920.GC4142@mtj.dyndns.org>
 <20110903221456.GA2877@elie>
 <20110904024244.GB3083@htj.dyndns.org>
 <87y5y37o7h.fsf@servo.factory.finestructure.net>
 <20110906174524.GN18425@mtj.dyndns.org>
 <20110907085037.GX10237@login.drsnuggles.stderr.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907085037.GX10237@login.drsnuggles.stderr.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 10:50:37AM +0200, Matthijs Kooijman wrote:
> Hi Tejun,
> 
> > Also, can you please explain the steps needed to trigger this problem?
> I'm not the one that supplied the backtraces, but I'm having the same
> problem. I did a fairly extensive writeup on the Debian bug report,
> perhaps this could (help to) answer your question:
> 
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=628600#23
> 
> I'll leave the other questions to Jameson for now.

Hmm... so, hibernation, disk event or udev isn't the cause.  Device
removal somehow ends up with stalled request queue hanging event check
which eventually propagates as failed freeze during hibernation
attempt.

Can someone please attach dmesg output cdrom_id is hung after dock
removal and also the output of sysrq-t?

Thanks.

-- 
tejun
