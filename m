Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab0L0MEG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Dec 2010 07:04:06 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:62684 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753331Ab0L0MEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Dec 2010 07:04:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=xJDDOcm0T+aEWZBI93hkWs3SyU85D/BNoLNYlel4xYkqxVYLIdg4VrUuR5d8u9uSP7
         gM02SWQ3nngm1i105koyGJCYwqa5SRPjWYuW8rq7c7dDqnJfcYaduXwbF1ITKhe1+ZZu
         2p72A+Gh4F3imMX/Mku2Ohbx+ju0dSoW3qp0M=
Date: Mon, 27 Dec 2010 13:03:58 +0100
From: Tejun Heo <htejun@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-ide@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Probably regression] Possible circular locking dependency
 from ATA in current mainline
Message-ID: <20101227120358.GA488@htj.dyndns.org>
References: <201012262316.26638.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201012262316.26638.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Rafael.

On Sun, Dec 26, 2010 at 11:16:26PM +0100, Rafael J. Wysocki wrote:
> [  319.281892] =======================================================
> [  319.281893] [ INFO: possible circular locking dependency detected ]
> [  319.281894] 2.6.37-rc7+ #16
> [  319.281895] -------------------------------------------------------
> [  319.281896] kworker/1:0/13333 is trying to acquire lock:
> [  319.281897]  (&bdev->bd_mutex){+.+.+.}, at: [<ffffffff811271a6>] revalidate_disk+0x56/0x90
> [  319.281902] 
> [  319.281903] but task is already holding lock:
> [  319.281903]  (&ap->scsi_scan_mutex){+.+...}, at: [<ffffffff81360420>] ata_scsi_dev_rescan+0x30/0x120

This dependency is true.

> [  319.281910] -> #3 (&ap->scsi_scan_mutex){+.+...}:
> [  319.281927] -> #2 ((&ap->scsi_rescan_task)){+.+...}:
> [  319.281937] -> #1 (events){+.+.+.}:
> [  319.281970] -> #0 (&bdev->bd_mutex){+.+.+.}:

But the above is bogus.  It's only linked through the system_wq.  The
current lockdep notation assumes single execution resource and
triggers spuriously in certain cases.  I'll think about how to relax
it.

Thank you.

-- 
tejun
