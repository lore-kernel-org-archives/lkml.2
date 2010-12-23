Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753241Ab0LWPwq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 10:52:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:37495 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752760Ab0LWPwo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 10:52:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QxF8F0PWRpGoU7t436ohNF1pf+c6CAT/+vqcFBdP262kwL37dSxVudz6TCp70pP9Ii
         wSFh/twbXSbYiBFau6q7/goKHG12tYnTXxl3B/paFS2K+Gvoo8Ld4xPrk7pK6rT2Y/bM
         Hmo8/Iv78hWro1GGBQ0T5ZomG0b4/S69Yq/uI=
Date: Thu, 23 Dec 2010 16:52:39 +0100
From: Tejun Heo <htejun@gmail.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: Jens Axboe <axboe@kernel.dk>, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Boot failure with block/for-next
Message-ID: <20101223155239.GB18482@htj.dyndns.org>
References: <1293038823.3019.89.camel@mulgrave.site>
 <1293078673.3019.765.camel@mulgrave.site>
 <20101223100956.GA15625@htj.dyndns.org>
 <1293118041.3029.3.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293118041.3029.3.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hey,

On Thu, Dec 23, 2010 at 09:27:21AM -0600, James Bottomley wrote:
> > Subject: sd: don't clear media presence unless it's removable
> 
> No, still the same failure.  Here's an excised log of an unsuccessful
> and successful disk probe:

Hmmm... That's unfortunate.

> /bin/sh: can't access tty; job control turned off
> (initramfs) dmesg|grep sda
> sd 2:0:1:0: [sda] 71132960 512-byte logical blocks: (36.4 GB/33.9 GiB)
> sd 2:0:1:0: [sda] Write Protect is off
> sd 2:0:1:0: [sda] Mode Sense: d3 00 10 08
> sd 2:0:1:0: [sda] Write cache: disabled, read cache: enabled, supports DPO and FUA
> device: 'sda': device_add
> PM: Adding info for No Bus:sda
>  sda: unable to read partition table
> sd 2:0:1:0: [sda] Attached SCSI disk
> (initramfs) dmesg|grep sdb
> sd 2:0:2:0: [sdb] 17942584 512-byte logical blocks: (9.18 GB/8.55 GiB)
> sd 2:0:2:0: [sdb] Write Protect is off
> sd 2:0:2:0: [sdb] Mode Sense: e3 00 10 08
> sd 2:0:2:0: [sdb] Write cache: disabled, read cache: enabled, supports DPO and FUA
> device: 'sdb': device_add
> PM: Adding info for No Bus:sdb
>  sdb: sdb1 sdb2
> device: 'sdb1': device_add
> PM: Adding info for No Bus:sdb1
> device: 'sdb2': device_add
> PM: Adding info for No Bus:sdb2
> sd 2:0:2:0: [sdb] Attached SCSI disk

Can you please apply the debug patch I posted in the other message and
post the boot log?  Let's see how the partition read is failing.

Thanks.

-- 
tejun
