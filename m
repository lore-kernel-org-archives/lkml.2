Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab2EOMyB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 08:54:01 -0400
Received: from mx1.redhat.com ([209.132.183.28]:12773 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932620Ab2EOMyA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 08:54:00 -0400
Date: Tue, 15 May 2012 15:53:56 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Hannes Reinecke <hare@suse.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515125356.GM32036@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
 <20120515111255.GJ32036@redhat.com>
 <4FB23C09.7060300@suse.de>
 <20120515115917.GK32036@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515115917.GK32036@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 02:59:17PM +0300, Gleb Natapov wrote:
> > So why do you claim we can't display it anymore?
> > 
> Before commit 0c61227094b3ddaca2f847ee287c4a2e3762b5a2 the code didn't
> calculate checksum correctly. The check always succeed, so when bios
> provided information according to T13 EDD4.0 spec interface_type contained
Correction. If BIOS provided information _not_ according to T13 EDD4.0 spec
interface_type contained garbage since the reset of the code assumes the
EDD4.0 information.

Looked like that:
# cat /sys/firmware/edd/int13_dev80/interface 
SCSI            id: 0  lun: 1224979098644774912

> garbage. After the commit checksum is calculated correctly, but according
> to T13 EDD4.0 spec, so for BIOSes that supply info according to another
> spec check fails. Since T13 EDD4.0 spec support modern interfaces (RAID,
> SATA, SAS) which another spec omits, and for interfaces they both support
> T13 EDD4.0 actually supply enough information to link edd entry to actual
> device (another spec does not), I do not see support for other spec to
> be important, but you are welcome to write support for it if you need
> it. The only way I see to check what spec edd info corresponds to is to
> calculate checksum according to both specs and see which one succeeds.
> 
> --
> 			Gleb.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

--
			Gleb.
