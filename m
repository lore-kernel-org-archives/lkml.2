Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933007Ab2GENUx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 09:20:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63189 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932339Ab2GENUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 09:20:51 -0400
Date: Thu, 5 Jul 2012 09:20:36 -0400
From: Don Zickus <dzickus@redhat.com>
To: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Luck, Tony (tony.luck@intel.com)" <tony.luck@intel.com>,
        "mikew@google.com" <mikew@google.com>,
        "Matthew Garrett (mjg@redhat.com)" <mjg@redhat.com>,
        "dle-develop@lists.sourceforge.net" 
	<dle-develop@lists.sourceforge.net>,
        Satoru Moriya <satoru.moriya@hds.com>
Subject: Re: [RFC][PATCH 0/2]efi_pstore: Avoid missing panic message in NVRAM
Message-ID: <20120705132036.GF5637@redhat.com>
References: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAC3@USINDEM103.corp.hds.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A5ED84D3BB3A384992CBB9C77DEDA4D401AAC3@USINDEM103.corp.hds.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 03, 2012 at 11:33:57PM +0000, Seiji Aguchi wrote:
> [Problem]
> Current efi_pstore simply overwrites existing entries in NVRAM.
> So, if 2nd panic happens before a user checks 1st panic message, 1st panic message will be lost.

I thought the rule was entries do not get overwritten until they are
deleted first.  Perhaps that is just an APEI thing, but it seems like that
should be a good rule for EFI too.

Mainly because there is very little userspace apps that actually clear the
old error records.  So this could become a common problem.

Unless we are implementing a flight recorder option which explicitly
states overwrite older entries?

Cheers,
Don

> 
> [Solution]
> To avoid missing 1st panic message, this patch introduce a rule checking if existing entries in NRAM are erasable to efi_pstore.
>  
> [Patch Descriptions]
>  
>  [PATCH 1/2] Duplicate a shared code between write and erase callbacks  
>  
>   Currently, efi_pstore driver shares a code erasing existing entries in NVRAM with write and erase callbacks.
>   But there some cases we should avoid erasing existing entries in write callback. (Please see PATCH 2/2).
>   This patch duplicates the code so that write and erase callbacks work independently. 
>  
>  
>  [PATCH 2/2] write callback: Check if existing entry is erasable
>  
>   this patch introduce a rule checking if existing entries in NRAM are erasable to efi_pstore.
>   With this patch, if previous event is panic, efi_pstore never overwrite it.
> 
>  
>   drivers/firmware/efivars.c |   94 +++++++++++++++++++++++++++++++++++++++++++-
>   fs/pstore/platform.c       |    4 +-
>   include/linux/pstore.h     |    5 ++
>   3 files changed, 99 insertions(+), 4 deletions(-)
>  
>  Seiji
