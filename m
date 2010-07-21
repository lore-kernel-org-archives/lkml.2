Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752774Ab0GULI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jul 2010 07:08:26 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:57674 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751657Ab0GULIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jul 2010 07:08:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding;
        b=LSadkwOuPlvz+2UuujcqIG2CHLinqFyuB61CzhGvy6r/zOwdyBpRnxkX6kzjBlXgfH
         pmfj9Yt4L2OZtLWO2IlTMyA/4eXiyyLYPAaRJpo5RfrQ3VvNIoq6jiIoCyH+tPAOYSiT
         FlojwX5RmC+RCTvMwlJEafe6d6JOFNWis7oKs=
Date: Wed, 21 Jul 2010 14:07:58 +0300
From: =?UTF-8?B?VMO2csO2aw==?= Edwin <edwintorok@gmail.com>
To: Dave Chinner <david@fromorbit.com>
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: 2.6.35-r5 ext3 corruptions
Message-ID: <20100721140758.68ca16ab@debian>
In-Reply-To: <20100721063222.GW32635@dastard>
References: <20100715105745.GI30737@dastard>
	<20100719224512.GD32635@dastard>
	<20100721063222.GW32635@dastard>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Jul 2010 16:32:22 +1000
Dave Chinner <david@fromorbit.com> wrote:

> On Tue, Jul 20, 2010 at 08:45:12AM +1000, Dave Chinner wrote:
> > On Thu, Jul 15, 2010 at 08:57:45PM +1000, Dave Chinner wrote:
> > > Upgrading my test vms from 2.6.35-rc3 to 2.6.35-rc5 is resulting
> > > in repeated errors on the root drive of a test VM:
> > > 
> > > { 1532.368808] EXT3-fs error (device sda1): ext3_lookup: deleted
> > > inode referenced: 211043 [ 1532.370859] Aborting journal on
> > > device sda1. [ 1532.376957] EXT3-fs (sda1): 
> > > [ 1532.376976] EXT3-fs (sda1): error: ext3_journal_start_sb:
> > > Detected aborted journal [ 1532.376980] EXT3-fs (sda1): error:
> > > remounting filesystem read-only [ 1532.420361] error: remounting
> > > filesystem read-only [ 1532.621209] EXT3-fs error (device sda1):
> > > ext3_lookup: deleted inode referenced: 211043
> > > 
> > > The filesysetm is a mess when checked on reboot - lots of illegal
> > > references to blocks, multiply linked blocks, etc, but repairs.
> > > Files are lots, truncated, etc, so there is visible filesystem
> > > damage.
> > > 
> > > I did lots of testing on 2.6.35-rc3 and came across no problems;
> > > problems only seemed to start with 2.6.35-rc5, and I've reproduced
> > > the problem on a vanilla 2.6.35-rc4.
> > > 
> > > The problem seems to occur randomly - sometimes during boot or
> > > when idle after boot, sometimes a while after boot. I haven't
> > > done any digging at all for the cause - all I've done so far is
> > > confirm that it is reproducable and it's not my code causing the
> > > problem.
> > 
> > Looks like this problem was isolated to a single VM and root
> > filesystem. I could not reproduce it on anything other than the
> > one filesystem that was failing.
> 
> Ok, so now I know *why* that one filesystem got busted - I built a
> kernel without CONFIG_EXT3_DEFAULTS_TO_ORDERED set and it got a
> forced reboot (echo b > proc/sysrq-trigger). That'll teach me for
> trying to reproduce bugs Andrew is tripping over with his config
> files.
> 
> Quite frankly, data=writeback mode for ext3 is a dangerous,
> dangerous configuration to run by default. IMO, it shouldn't be the
> default. Patch below.

Hi,

I don't see CONFIG_EXT3_DEFAULTS_TO_ORDERED in my .config at all.
What I have in my .config is:
CONFIG_EXT4_FS=y
CONFIG_EXT4_USE_FOR_EXT23=y
CONFIG_EXT4_FS_XATTR=y

So what is the equivalent of that config option for ext4 used as ext3
driver?

Best regards,
--Edwin
