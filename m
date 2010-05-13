Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759255Ab0EMSk0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:40:26 -0400
Received: from hera.kernel.org ([140.211.167.34]:41116 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756288Ab0EMSkY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:40:24 -0400
Message-ID: <4BEC4782.7010109@kernel.org>
Date: Thu, 13 May 2010 20:40:02 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       ben@decadent.org.uk
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
References: <1273766206-17402-1-git-send-email-tj@kernel.org>	 <1273766778.4353.200.camel@mulgrave.site>  <4BEC272E.10508@kernel.org>	 <1273768687.4353.235.camel@mulgrave.site>  <4BEC2ED7.9080001@kernel.org> <1273771131.4353.300.camel@mulgrave.site>
In-Reply-To: <1273771131.4353.300.camel@mulgrave.site>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 18:40:06 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, James.

On 05/13/2010 07:18 PM, James Bottomley wrote:
> So I think the bit I missed was you're trying to do this programatically
> from boot time partition read to detect if the user previously disabled
> the HPA and partitioned the device?  In which case you still have user
> context, you can call BLKRRPART here too.

Yeah, that's what I'm trying to do but the functionality is already in
the block layer and has been used by IDE layer for a long time.  We
just forgot to implement it for libata.  The only thing I did was
fixing up corner case handling in block layer a bit and adding a
callback to sd so that the block layer call can be passed down to
libata.  So, it doesn't have anything to do with sysfs attributes,
block or libata.

We sure can trigger the rescan by invoking BLKRRPART from inside the
partition scan code but I'm afraid that would be more convoluted than
the currently existing implementation of restarting the scan inside
the scan function.

The only thing is that the existing block method is somewhat overly
generic without any good reason, so simplifying that would be a good
idea.

Thanks.

-- 
tejun
