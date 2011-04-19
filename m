Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753661Ab1DSIX5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 04:23:57 -0400
Received: from e23smtp09.au.ibm.com ([202.81.31.142]:48000 "EHLO
	e23smtp09.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750974Ab1DSIXy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 04:23:54 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Eric Sandeen <sandeen@redhat.com>
Subject: Re: Linux 2.6.39-rc3
In-Reply-To: <BANLkTik68Q2bpgF7GpcOs+YF44B9TL60qQ@mail.gmail.com>
References: <BANLkTimNvX=U6qy2FgvDpWE6HY7cehWvyQ@mail.gmail.com> <20110412190934.GA12082@redhat.com> <20110412192103.GA13278@redhat.com> <87tye1ckhr.fsf@linux.vnet.ibm.com> <BANLkTik68Q2bpgF7GpcOs+YF44B9TL60qQ@mail.gmail.com>
User-Agent: Notmuch/0.5-66-g70c5e2c (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 19 Apr 2011 13:53:37 +0530
Message-ID: <87ipuar6nq.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Apr 2011 00:57:27 +0200, Kay Sievers <kay.sievers@vrfy.org> wrote:
> On Thu, Apr 14, 2011 at 10:20, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
> > On Tue, 12 Apr 2011 15:21:03 -0400, Dave Jones <davej@redhat.com> wrote:
> >> On Tue, Apr 12, 2011 at 03:09:34PM -0400, Dave Jones wrote:
> >>
> >>  > however, the output of mount looks very confused..
> >>  >
> >>  > .38:
> >>  > /dev/mapper/vg_adamo-lv_home on /home type ext4 (rw,relatime,seclabel,barrier=1,data=ordered)
> >>  >
> >>  > .39:
> >>  > - on /home type 79a9-4526-888c-1f86d35a6704 (rw,relatime,ext4)
> >>  >
> >>  > It looks like /proc/self/mountinfo broke abi.
> >>  >
> >>  > .38:
> >>  > 48 45 253:3 / /home rw,relatime - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,barrier=1,data=ordered
> >>  >
> >>  > .39:
> >>  > 46 22 253:3 / /home rw,relatime uuid:f3971858-79a9-4526-888c-1f86d35a6704 - ext4 /dev/mapper/vg_adamo-lv_home rw,seclabel,user_xattr,barrier=1,data=ordered
> >>
> >> looks like this was caused by 93f1c20bc8cdb757be50566eff88d65c3b26881f
> >>
> >> perhaps adding that string to the end of the line would preserve what mount expects ?
> >
> > uuid:<value> is the option field  as per
> > Documentation/filesystem/proc.txt. There was an error in libmount
> > parsing which got fixed upstream recently
> 
> Just a simple question about this approach in general? A filesystem
> UUID can be changed on disk at any time (tune2fs -U ...).
> 
> Your code looks like you copy the bytes to the in-kernel superblock
> structure without noticing any later changes on disk? How is that
> supposed to work?
> 

Isn't that true even for the fsid returned by statfs ?.  IIUC tune2fs
won't change even the ext4_super_block.s_uuid .

-aneesh
