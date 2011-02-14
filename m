Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab1BNOJs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 09:09:48 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55561 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754581Ab1BNOJq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 09:09:46 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=eHirT8VUAx0d4DLnvtGRJ4BPgliO4AeMzDCxwFQP9jsv2w263IVEeDslHdoM5tuVDW
         6B+UBUzy14ofMDUENRtyQzlo9UPGuidOCJi1c/Q+OwusF7tW+blM3oeNmxkGMCAzFUQu
         YIoh5yMXE3weBYKDT/vQD6XmQoWe/wAwKXEGQ=
Date: Mon, 14 Feb 2011 15:09:40 +0100
From: Tejun Heo <tj@kernel.org>
To: Milan Broz <mbroz@redhat.com>
Cc: Tao Ma <tm@tao.ma>, linux-kernel@vger.kernel.org,
        Jens Axboe <axboe@kernel.dk>,
        device-mapper development <dm-devel@redhat.com>
Subject: Re: [PATCH][RFC] dm: Do not open log and cow device read-write for
 read-only mappings
Message-ID: <20110214140940.GM18742@htj.dyndns.org>
References: <4D573BBB.6090200@redhat.com>
 <1297594735-5593-1-git-send-email-tm@tao.ma>
 <4D57E67E.1030707@redhat.com>
 <4D57F357.6060708@tao.ma>
 <4D580A8B.5050508@redhat.com>
 <20110214103026.GA18742@htj.dyndns.org>
 <4D591664.6090203@redhat.com>
 <4D592AD1.6020500@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D592AD1.6020500@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Feb 14, 2011 at 02:14:57PM +0100, Milan Broz wrote:
> > But it doesn't fix the read-only snapshot issue and I guess there will be
> > the same problem with read-only MD code too.
> > (so the 2) issue here https://lkml.org/lkml/2011/2/12/209).

So, the problem is caused by dm opening members rw even for ro
devices, right?

> I am not sure if this is complete fix... note that:
> - what happens during mirror resync and read-only log?
> - for COW, it there situation we need to update header in read-oly mode? (invalidated snap?)

But if the underlying device is marked ro, dm shouldn't update it at
all.  The device should be opened ro and ro policy should be enforced.

Thanks.

-- 
tejun
