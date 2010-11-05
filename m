Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754742Ab0KEU1E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 16:27:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:55204 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586Ab0KEU1B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 16:27:01 -0400
Date: Fri, 5 Nov 2010 13:02:45 -0700
From: Greg KH <gregkh@suse.de>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: cbouatmailru@gmail.com, kay.sievers@vrfy.org, ak@linux.intel.com,
        axboe@kernel.dk, shemminger@vyatta.com, ebiederm@xmission.com,
        stern@rowland.harvard.edu, James.Bottomley@suse.de,
        akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
        randy.dunlap@oracle.com, tj@kernel.org, davem@davemloft.net,
        perex@perex.cz, tiwai@suse.de, mingo@elte.hu, a.p.zijlstra@chello.nl,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: Re: [2.6.37-rc1] wait_for_sysfs prints errors.
Message-ID: <20101105200245.GA1645@suse.de>
References: <201011060307.GIG13040.OFFJOVHMSFLOtQ@I-love.SAKURA.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201011060307.GIG13040.OFFJOVHMSFLOtQ@I-love.SAKURA.ne.jp>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 03:07:55AM +0900, Tetsuo Handa wrote:
> Hello.
> 
> I noticed that udevd-event started to print error messages.
> 
>   Starting udev: udevd-event[1682]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:10.0/host0/ioerr_cnt' failed
>   udevd-event[2103]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:10.0/host0/target0:0:1/ioerr_cnt' failed
>   udevd-event[2102]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:10.0/host0/target0:0:0/ioerr_cnt' failed

That's wierd, what version of udev is this?

> These error messages are caused by one or more of below commits.
> (Sorry, I can't find exact one because I can't boot as of below commits.)
> 
> 5cfc64ce "base/platform: Safe handling for NULL platform data and resources"
> 807508c8 "base/platform: Simplifications for NULL platform data/resources handling"
> 39aba963 "driver core: remove CONFIG_SYSFS_DEPRECATED_V2 but keep it for block devices"
> 
> Is this a regression? (Is this an intended change?)

Do you still have CONFIG_SYSFS_DEPRECATED enabled?

Other than that, everything works ok, right?

thanks,

greg k-h
