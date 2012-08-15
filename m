Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab2HOJS7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 05:18:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751463Ab2HOJS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 05:18:57 -0400
Date: Wed, 15 Aug 2012 11:17:57 +0200 (CEST)
From: =?ISO-8859-15?Q?Luk=E1=A8_Czerner?= <lczerner@redhat.com>
X-X-Sender: lukas@dhcp-1-248.brq.redhat.com
To: "Theodore Ts'o" <tytso@mit.edu>
cc: Lukas Czerner <lczerner@redhat.com>, Paolo Bonzini <pbonzini@redhat.com>,
        "Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List" 
	<linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org
Subject: Re: ext4fs error "ext4_mb_generate_buddy:741:group 16, 8160 clusters
 in bitmap, 4064 in gd" (with repro)
In-Reply-To: <20120809170640.GA6607@thunk.org>
Message-ID: <alpine.LFD.2.00.1208151116530.4904@dhcp-1-248.brq.redhat.com>
References: <50238A29.3060808@redhat.com> <20120809170640.GA6607@thunk.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Aug 2012, Theodore Ts'o wrote:

> Date: Thu, 9 Aug 2012 13:06:40 -0400
> From: Theodore Ts'o <tytso@mit.edu>
> To: Lukas Czerner <lczerner@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>,
>     "Linux Kernel Mailinlinux-ext4@vger.kernel.orgg List"
>     <linux-kernel@vger.kernel.org>, linux-ext4@vger.kernel.org
> Subject: Re: ext4fs error
>     "ext4_mb_generate_buddy:741:group 16, 8160 clusters in bitmap, 4064 in gd"
>      (with repro)
> 
> On Thu, Aug 09, 2012 at 12:00:09PM +0200, Paolo Bonzini wrote:
> > Here is how to reproduce it.  It happens during fstrim.  I found other
> > occurrences of the error in the mailing list, but they were not related
> > to trim so they may be something different.
> > 
> > modprobe scsi_debug dev_size_mb=256 lbpws=1
> > dd if=/dev/zero of=/dev/sdb bs=1M      
> > fdisk /dev/sdb
> >  >> create a new partition accepting all defaults
> > fdisk -lu /dev/sdb|tail -1
> >  >> should show: /dev/sdb1     57      524285      262114+  83  Linux
> > 
> > mkfs.ext4 /dev/sdb1
> > mkdir test
> > mount /dev/sdb1 test
> > fstrim ./test
> 
> I can confirm that this accurately reproduces file system corruption
> using a 3.5 kernel.  It looks like some block allocation bitmap blocks
> is getting trimmed when it shouldn't have been.  Lukas, can you take a
> look at this?
> 
> 					- Ted

Hi Ted,

sorry for the delay, I've just got back from my vacation. I'll take
a look at it.

Thanks!
-Lukas
