Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab2BMJ0T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:26:19 -0500
Received: from smtp-out003.kontent.com ([81.88.40.217]:33404 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036Ab2BMJ0S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:26:18 -0500
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [RFC 0/5] scsi, sd, pm, request based runtime PM for scsi disk
Date: Mon, 13 Feb 2012 10:28:45 +0100
User-Agent: KMail/1.13.5 (Linux/3.3.0-rc1-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Huang Ying <ying.huang@intel.com>, ming.m.lin@intel.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-pm@vger.kernel.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        James Bottomley <JBottomley@parallels.com>
References: <Pine.LNX.4.44L0.1202122013300.24811-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1202122013300.24811-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201202131028.45806.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 13. Februar 2012, 02:42:24 schrieb Alan Stern:
> On Sun, 12 Feb 2012, Oliver Neukum wrote:
> 
> > Yes, we can use the same heuristics as everywhere.
> > command queued -> autopm_get
> > command finished -> autopm_put
> > 
> > but for the USB host adapter, not the sr device
> 
> I still don't fully understand.  Are you suggesting that we use the 
> normal autosuspend timeout mechanism for the disk drive (for example, 
> spin down the disk if it hasn't been used for five minutes), and then

Yes. The key here is to realize that from a view point of functionality
they are not suspended. But they will be ready to be suspended.

> autosuspend a USB mass-storage device whenever its children are 
> suspended and no commands are in progress?  (In fact, there can't be 
> any commands in progress if all the children are suspended.)

Really? It is currently true because the device must be opened to issue
commands.
In fact now that you put it this way, it seems to me that this is the
preconception we must shed.


> The SCSI drivers don't know much about the request queue -- the block
> layer manages it.  That's another reason for handling this at the block
> layer.

That was refering to SCSI requests.
 
> Is there some special reason you're talking about sr (the SCSI CD/DVD
> driver) instead of sd (the SCSI disk driver)?

My stupidity.

	Regards
		Oliver
