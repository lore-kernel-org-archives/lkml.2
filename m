Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758028Ab2CFACL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 19:02:11 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:49619 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757961Ab2CFACJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 19:02:09 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of jwboyer@gmail.com designates 10.52.91.82 as permitted sender) smtp.mail=jwboyer@gmail.com; dkim=pass header.i=jwboyer@gmail.com
MIME-Version: 1.0
In-Reply-To: <20120305234133.GA13690@localhost>
References: <20120305234133.GA13690@localhost>
Date: Mon, 5 Mar 2012 19:02:08 -0500
Message-ID: <CA+5PVA4axkm-S5-E1pnkgNpDLy3DHegFL2Cfo2i-8HOsfGMHDw@mail.gmail.com>
Subject: Re: [BUG] scsi_device.device == NULL in sd_revalidate_disk()
From: Josh Boyer <jwboyer@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "linux-fsdevel@vger.kernel.o..." <linux-fsdevel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 6:41 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> Hi,
>
> I ran into a NULL dereference bug on USB key hot remove, which should
> be caused by the below skdp->device reference
>
>        static int sd_revalidate_disk(struct gendisk *disk)
>        {
>                struct scsi_disk *sdkp = scsi_disk(disk);
> ==>             struct scsi_device *sdp = sdkp->device;

This has been reported numerous times.  There are patches to the block layer
that are supposed to fix it, but they haven't hit Linus' tree yet.  I think
we're waiting on Jens to push them.

josh
