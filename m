Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752547Ab2GZNCK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:02:10 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42406 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab2GZNCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:02:07 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Aaron Lu <aaron.lu@amd.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>,
        Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
Subject: Re: [PATCH v3 2/7] scsi: pm: use autosuspend if device supports it
Date: Thu, 26 Jul 2012 15:01:15 +0200
Message-ID: <4732005.Un0exgRK6O@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.5.0-12-desktop+; KDE/4.8.4; x86_64; ; )
In-Reply-To: <20120726124326.GA2022@localhost.localdomain>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com> <1476441.ovA4GKBza3@linux-lqwf.site> <20120726124326.GA2022@localhost.localdomain>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 26 July 2012 20:43:32 Aaron Lu wrote:
> > What is the purpose of this approach?
> 
> The purpose is to let scsi layer driver(sd, sr, etc.) use the same pm
> api(scsi_autopm_put_device) to put the device to runtime suspended
> state.
> When the device is ready to be suspended, if it does not make use of
> autosuspend, call pm_runtime_put_sync for it; if it makes use of
> autosuspend, call the autosuspend runtime pm apis for it.
> 
> > You need a very good reason to have an API do two different things
> > based on this.
> 
> If you see the above reason not good, I'll prepare an updated version
> to create a new api to cover the autosuspend case, something like:
> void scsi_autopm_put_device_autosuspend(struct scsi_device *sdev)
> {
>         pm_runtime_mark_last_busy(&sdev->sdev_gendev);
>         pm_runtime_put_autosuspend(&sdev->sdev_gendev);
> }
> Does this look right?

Much better :-)

	Regards
		Oliver

