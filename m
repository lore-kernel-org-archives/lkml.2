Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752799Ab2GPXsM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 19:48:12 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34334 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751759Ab2GPXsK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 19:48:10 -0400
Date: Mon, 16 Jul 2012 16:48:05 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: James.Bottomley@HansenPartnership.com, mdharm-usb@one-eyed-alien.net,
        stern@rowland.harvard.edu, sshtylyov@mvista.com, bvanassche@acm.org,
        akpm@linux-foundation.org, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>
Subject: Re: [PATCH RESEND 0/3] scsi: fix internal write cache issue on usb
 hdd.
Message-ID: <20120716234805.GA9875@kroah.com>
References: <1341716685-6631-1-git-send-email-linkinjeon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341716685-6631-1-git-send-email-linkinjeon@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 11:04:45PM -0400, Namjae Jeon wrote:
> From: Namjae Jeon <namjae.jeon@samsung.com>
> 
> The numbers of USB HDDs(All USB HDD I checked) does not respond
> correctly to scsi mode sense command for retrieving the write cache
> page status. Even though write cache is enabled by default, due to
> scsi driver assume that cache is not enabled which in turn might lead
> to loss of data since data still will be in cache.
> This result that all filesystems is not stable on USB HDD when the
> device is unplugged abruptly, even though these are having journaling
> feature. Our first trying is that scsi driver send ATA command
> (ATA Pass through, #85) to USB HDD after failure from normal routine to
> know write cache enable.
> We have known it is dangerous after testing several USB HDD. some of
> HDD is stalled by this command(A-DATA HDD). So we tried to make the
> patch James Bottomley's suggestion(usb quirk) on version 2 that add
> product ID and verdor ID of USB HDD to USB quirk list after checking
> write cache.
> All filesystem will be stable on USB HDD registered in quirk list.
> And it will be updated continuously.

Now applied to the usb-next branch.

thanks,

greg k-h
