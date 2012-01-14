Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753539Ab2ANXnZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jan 2012 18:43:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:60945 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab2ANXnX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jan 2012 18:43:23 -0500
MIME-Version: 1.0
In-Reply-To: <1326380489-9044-3-git-send-email-pbonzini@redhat.com>
References: <1326380489-9044-1-git-send-email-pbonzini@redhat.com> <1326380489-9044-3-git-send-email-pbonzini@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 14 Jan 2012 15:43:01 -0800
X-Google-Sender-Auth: F20sEHVAfeRxltPtfAgkZC21TAI
Message-ID: <CA+55aFxuEzfAOL=pH1m7KQxdO1yzz=nGb2fU80AbysFd3J4Dvg@mail.gmail.com>
Subject: Re: [PATCH v2 2/3] block: fail SCSI passthrough ioctls on partition devices
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, Petr Matousek <pmatouse@redhat.com>,
        linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        James Bottomley <JBottomley@parallels.com>, stable@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 7:01 AM, Paolo Bonzini <pbonzini@redhat.com> wrote:
> +       case CDROM_GET_CAPABILITY:
> +               /* Keep this until we remove the printk below.  udev sends it
> +                * and we do not want to spam dmesg about it.   CD-ROMs do
> +                * not have partitions, so we get here only for disks.
> +                */
> +               return -ENOIOCTLCMD;

Looks like CDROMMULTISESSION is another of these.

I get two of these:

   mount: sending ioctl 5310 to a partition!

with Fedora 14 whenever a USB stick is inserted (I changed your patch
to also print the name of the program). Let's see if anything else
pops up.

Anyway, with the changes to print out warnings and still allow it for
root, this all looked safe and nice, so they are in my tree now. I
only noticed after applying them that you hadn't marked them with 'cc:
stable@kernel.org', so we should probably point Greg at them. They are
commits

  577ebb374c78 block: add and use scsi_blk_cmd_ioctl
  0bfc96cb7722 block: fail SCSI passthrough ioctls on partition devices
  ec8013beddd7 dm: do not forward ioctls from logical volumes to the
underlying device

in my tree now.

                      Linus
