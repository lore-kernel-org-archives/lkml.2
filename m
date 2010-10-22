Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab0JVOdY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 10:33:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:54816 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755136Ab0JVOdX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 10:33:23 -0400
Date: Fri, 22 Oct 2010 10:33:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Luben Tuikov <ltuikov@yahoo.com>
cc: Greg KH <greg@kroah.com>, <linux-usb@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] [USB] Use normalized sense when emulating autosense
In-Reply-To: <407253.45995.qm@web31802.mail.mud.yahoo.com>
Message-ID: <Pine.LNX.4.44L0.1010221029430.1529-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Oct 2010, Luben Tuikov wrote:

> This patch solves two things:
> 1) Enables autosense emulation code to correctly
> interpret descriptor format sense data, and
> 2) Fixes a bug whereby the autosense emulation
> code would overwrite descriptor format sense data
> with SENSE KEY HARDWARE ERROR in fixed format, to
> incorrectly look like this:

...

> @@ -794,12 +793,7 @@ Retry_Sense:
>  		 * everything worked or that there was an unspecified
>  		 * problem.  We have to decide which.
>  		 */
> -		if (	/* Filemark 0, ignore EOM, ILI 0, no sense */
> -				(srb->sense_buffer[2] & 0xaf) == 0 &&
> -			/* No ASC or ASCQ */
> -				srb->sense_buffer[12] == 0 &&
> -				srb->sense_buffer[13] == 0) {
> -
> +		if (sshdr.sense_key == 0 && sshdr.asc == 0 && sshdr.ascq == 0) {
>  			/* If things are really okay, then let's show that.
>  			 * Zero out the sense buffer so the higher layers
>  			 * won't realize we did an unsolicited auto-sense.

What about the Filemark and ILI tests?  You mustn't get rid of them; 
they are needed for tape drives.

Alan Stern

