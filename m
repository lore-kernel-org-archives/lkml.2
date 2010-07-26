Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753484Ab0GZNGN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 09:06:13 -0400
Received: from relay01.mx.bawue.net ([193.7.176.67]:38816 "EHLO
	relay01.mx.bawue.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753337Ab0GZNGM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 09:06:12 -0400
Date: Mon, 26 Jul 2010 15:06:05 +0200
From: Nils Radtke <lkml@Think-Future.de>
To: Milan Broz <mbroz@redhat.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: cryptsetup + lvm on usb disk, unusable /dev/dm-* after
 suspend/resume  cycle
Message-ID: <20100726130605.GL31966@localhost>
Reply-To: Nils Radtke <lkml@Think-Future.de>
References: <20100725160641.GK31966@localhost>
 <4C4CA601.6020201@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4CA601.6020201@redhat.com>
X-Url: http://www.Think-Future.de
X-Editor: Vi it! http://www.vim.org
X-Bkp: p2mi
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

  Thanks for your answer.

On Sun 2010-07-25 @ 11-00-49PM +0200, Milan Broz wrote: 
# On 07/25/2010 06:06 PM, Nils Radtke wrote:
# 
# >   Using an external usb 2 hdd with recent kernels with cryptsetup containers that
# >   contain lvm volumes. 
# > 
# >   After a suspend/resume cycle, with active lvm volumes, the mounted fs is "offline", 
# >   the dm-* devices don't respond to commands issued. No more access possible.
# >   
# >   Have to reboot to free the devices.
# 
# I guess it is not dm/block layer problem but USB related - can you check syslog if
# the device is not attached after resume with another major:minor?
I'm not sure I can map this to what happened here. 

What I can tell is, a plain usb conn survives nowadays (there were kernels in the days
of 200x where x < 8 when usb didn't survive) suspend/resume cycles.

It is as well working with a usb + cryptsetup (w/o lvm): survives suspend/resume.

However usb + cryptsetup + lvm does not survive as of these days.

# If this happens - you can free the mappings using dmsetup:
# - try to force umount fs (if mounted), then run "dmsetup table" and manually remove
# orphaned mappings using "dmsetup remove".
That's what I tried and failed gloriously. I'm trying to revive my memory about the 
situation: fs could be unmounted, however, the cryptsetup luksClose failed (IRC) and 
therefore the dmsetup remove consequently failed also.

These experiences let me to the conclusion that there might be some issue
regarding dmsetup in the ensemble of usb + cryptsetup + lvm.

    Thanks for your opinion,


                  Nils

