Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755703Ab2AQUGc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 15:06:32 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:42346 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752073Ab2AQUGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 15:06:30 -0500
X-Sasl-enc: 2S0XXp3NcbnEmF0IXMMlGlW+xwI0KfBcMh6uztXt42lL 1326830789
Date: Tue, 17 Jan 2012 12:03:17 -0800
From: Greg KH <greg@kroah.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>, linux-kernel@vger.kernel.org,
        Petr Matousek <pmatouse@redhat.com>, linux-scsi@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] block: fail SCSI passthrough ioctls on partition
 devices
Message-ID: <20120117200317.GA14237@kroah.com>
References: <1326380489-9044-1-git-send-email-pbonzini@redhat.com>
 <1326380489-9044-3-git-send-email-pbonzini@redhat.com>
 <CA+55aFxuEzfAOL=pH1m7KQxdO1yzz=nGb2fU80AbysFd3J4Dvg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxuEzfAOL=pH1m7KQxdO1yzz=nGb2fU80AbysFd3J4Dvg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 14, 2012 at 03:43:01PM -0800, Linus Torvalds wrote:
> On Thu, Jan 12, 2012 at 7:01 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> > +       case CDROM_GET_CAPABILITY:
> > +               /* Keep this until we remove the printk below.  udev sends it
> > +                * and we do not want to spam dmesg about it.   CD-ROMs do
> > +                * not have partitions, so we get here only for disks.
> > +                */
> > +               return -ENOIOCTLCMD;
> 
> Looks like CDROMMULTISESSION is another of these.
> 
> I get two of these:
> 
>    mount: sending ioctl 5310 to a partition!
> 
> with Fedora 14 whenever a USB stick is inserted (I changed your patch
> to also print the name of the program). Let's see if anything else
> pops up.
> 
> Anyway, with the changes to print out warnings and still allow it for
> root, this all looked safe and nice, so they are in my tree now. I
> only noticed after applying them that you hadn't marked them with 'cc:
> stable@kernel.org', so we should probably point Greg at them. They are
> commits
> 
>   577ebb374c78 block: add and use scsi_blk_cmd_ioctl
>   0bfc96cb7722 block: fail SCSI passthrough ioctls on partition devices
>   ec8013beddd7 dm: do not forward ioctls from logical volumes to the
> underlying device
> 
> in my tree now.

Thanks, I've queued them all up for the 3.2 and 3.0-stable trees.

greg k-h
