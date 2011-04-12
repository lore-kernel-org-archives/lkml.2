Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab1DLCvy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Apr 2011 22:51:54 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57513 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756143Ab1DLCvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Apr 2011 22:51:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=nkf7fCwjOu0EKOngl27bS46DP35Kx6iFMhuArS+VqjZBKcOMGyY9Kux0O+XWXh9NNU
         6RORVmHL7xSW3QrMmHE0ABSIAXIKdag39FPV4ELUkq1NiaCqigYRfmF7o8ogCcicom/p
         zNxoTPTy/HE0GCG+g3Uzz+aisZz3VxOnG32DE=
Date: Tue, 12 Apr 2011 11:51:45 +0900
From: Tejun Heo <tj@kernel.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Steven Whitehouse <swhiteho@redhat.com>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: Strange block/scsi/workqueue issue
Message-ID: <20110412025145.GJ9673@mtj.dyndns.org>
References: <1302533763.2596.23.camel@dolmen>
 <20110411171803.GG9673@mtj.dyndns.org>
 <1302569276.2558.9.camel@mulgrave.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302569276.2558.9.camel@mulgrave.site>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, James.

On Mon, Apr 11, 2011 at 07:47:56PM -0500, James Bottomley wrote:
> Actually, I don't think it's anything to do with the user process stuff.
> The problem seems to be that the block delay function ends up being the
> last user of the SCSI device, so it does the final put of the sdev when
> it's finished processing.  This will trigger queue destruction
> (blk_cleanup_queue) and so on with your analysis.

Hmm... this I can understand.

> The problem seems to be that with the new workqueue changes, the queue
> itself may no longer be the last holder of a reference on the sdev
> because the queue destruction is in the sdev release function and a
> queue cannot now be destroyed from its own delayed work.  This is a bit
> contrary to the principles SCSI was using, which was that we drive queue
> lifetime from the sdev, not vice versa.

But confused here.  Why does it make any difference whether the
release operation is in the request_fn context or not?  What makes
SCSI refcounting different from others?

Thanks.

-- 
tejun
