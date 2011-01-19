Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754609Ab1ASPBy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 10:01:54 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:49774 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754099Ab1ASPBx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 10:01:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Oj61lDOtUheEnnZgGJ+uiDs8H2QnEkUTG4yC6CCMzBRWEAN09RdHPGptX+oS0yg8fl
         MzYD0QH1DILUBWVW6evbAJAKKtQrFAIXFPPhF6pDl2nU6URljim8Sl0/dzd+Yll13DpK
         3w8lhhZ7J7kYkGLiNJCN1LE4b7f03RaTK61+o=
Date: Wed, 19 Jan 2011 16:01:48 +0100
From: Tejun Heo <tj@kernel.org>
To: Dmitry <dmonakhov@openvz.org>
Cc: John Tyree <johntyree@gmail.com>, "Theodore Ts'o" <tytso@mit.edu>,
        Eric Sandeen <sandeen@redhat.com>, Jiaying Zhang <jiayingz@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org
Subject: Re: PROBLEM: Disk continually remounts and hardlocks the entire
 system if running on battery.
Message-ID: <20110119150148.GA22366@htj.dyndns.org>
References: <AANLkTi=_GSgFpsidp35-RDT3i6zhimXtyR=d6UtFmfMe@mail.gmail.com>
 <87ipxlj1vd.fsf@dmon-lp.sw.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ipxlj1vd.fsf@dmon-lp.sw.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 19, 2011 at 01:14:30AM +0300, Dmitry wrote:
> On Tue, 18 Jan 2011 22:46:34 +0100, John Tyree <johntyree@gmail.com> wrote:
> > [1.] Disk continually remounts and hardlocks the entire system if running on
> > battery.
> > 
> > [2.] When I unplug the power cord from laptop, the harddrive immediately
> > stops spinning and nothing happens for up to ten seconds or more. During
> > this
> > time, absolutely nothing works except the mouse moving around in X.
> > Applications do not redraw their guis, Can't launch anything or close
> > anything. Just have to wait until it remounts and I hear the drive spin up.
> > At that time, everything snaps back to life as if nothing has happened.
> > 
> > dmesg shows the following:
> oh, just look at ata errors, definitely this is not fs's problem,
> it's looks like your disk is dieing, Your options:
> 1) plug/unplug sata cable :), in my experience this is the root of cause
>    in 50% of cases.
> 2) smart ctl logs
> > 
> > [28687.441335] ata1.00: configured for UDMA/33
> > [28687.441345] ata1: EH complete
> > [28687.443153] sd 0:0:0:0: [sda] Write cache: disabled, read cache: enabled,
> > doesn't support DPO or FUA
> > [28688.563053] EXT4-fs (sda5): re-mounted. Opts: commit=600
> > [28688.570501] EXT4-fs (dm-0): re-mounted. Opts: commit=600
> > [28727.760100] ata1.00: exception Emask 0x0 SAct 0x0 SErr 0x110000 action
> > 0x6 frozen
> > [28727.760115] ata1: SError: { PHYRdyChg Dispar }
> > [28727.760126] ata1.00: failed command: WRITE DMA EXT
> > [28727.760144] ata1.00: cmd 35/00:08:5d:8b:e1/00:00:17:00:00/e0 tag 0 dma
> > 4096 out
> > [28727.760148]          res 40/00:f4:00:00:00/00:00:00:00:00/40 Emask 0x4
> > (timeout)
> > [28727.760156] ata1.00: status: { DRDY }
> > [28727.760170] ata1: hard resetting link
> > [28728.066096] ata1: SATA link up 1.5 Gbps (SStatus 113 SControl 310)
> > [28728.067819] ata1.00: configured for UDMA/33
> > [28728.068309] ata1.00: device reported invalid CHS sector 0
> > [28728.068337] ata1: EH complete
> > [28730.395512] ata1.00: configured for UDMA/33
> > [28730.395520] ata1: EH complete
> > [28730.430938] sd 0:0:0:0: [sda] Write cache: enabled, read cache: enabled,
> > doesn't support DPO or FUA
> > [28730.953631] EXT4-fs (sda5): re-mounted. Opts: commit=0
> > [28730.958914] EXT4-fs (dm-0): re-mounted. Opts: commit=0
> > 
> > This happens everytime the power is unplugged and continutes to happen, with
> > the harddrive spinning up and working for about 10 seconds before it happens
> > again. When the power is plugged back in, everything goes right back to
> > normal. This started with vanilla 2.6.37 from linus's git. I thought it
> > might
> > have something to do with laptop-mode, but disabling it did not change
> > anything.

Please attach full kernel log after such event including the boog
messages.

Thanks.

-- 
tejun
