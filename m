Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811Ab2EOOg5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 10:36:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27708 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932846Ab2EOOgz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 10:36:55 -0400
Date: Tue, 15 May 2012 17:36:44 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Hannes Reinecke <hare@suse.de>, LKML <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH] EDD: Check for correct EDD 3.0 length
Message-ID: <20120515143644.GD6948@redhat.com>
References: <1337079889-62380-1-git-send-email-hare@suse.de>
 <20120515111255.GJ32036@redhat.com>
 <4FB23C09.7060300@suse.de>
 <20120515115917.GK32036@redhat.com>
 <20120515150015.5bf17aea@pyramind.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515150015.5bf17aea@pyramind.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 03:00:15PM +0100, Alan Cox wrote:
> > T13 EDD4.0 actually supply enough information to link edd entry to actual
> > device (another spec does not), I do not see support for other spec to
> > be important, but you are welcome to write support for it if you need
> > it. The only way I see to check what spec edd info corresponds to is to
> > calculate checksum according to both specs and see which one succeeds.
> 
> I also think you are confused on this: EDD 3.0 provides enough
> information to link most types of hardware to the device. It provides the
> PCI or Legacy path to the interface and the device LUN, or for 1394 etc
> the WWID which can be used to cross match. It doesn't address port
> multipliers.
> 
It is easy to be confused since there are two EDD 3 specs. First is from
Phoenix BIOS (linked at the first mail of the thread) and it does not have
enough info even for ATA. You can't tell primary ATA controller from secondary.
SCSI specify only LUN, not SCSI ID and so on. Second is from T3
(http://www.t13.org/documents/UploadedDocuments/docs2004/d1572r3-EDD3.pdf)
and fixes all that but specify length of device path to be 44 bytes.

So let me correct myself. The code works for EDD3 spec from T13 and that
is what it claims in the file header.

> EDD 1.1 provides sufficient information for old systems too via the FDPT
> as they only have to deal with MFM/IDE/ATA controllers at the legacy
> mappings and these are described by the FDPT.
> 
> Prior to that it gets a bit more interesting and you have to go poking in
> BIOS magic and have the required spellbooks to hand. However right back
> to the original 386 era PCs the data is available.
> 
> Alan

--
			Gleb.
