Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759151Ab0EMS0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 14:26:09 -0400
Received: from hera.kernel.org ([140.211.167.34]:44734 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755419Ab0EMS0F (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 14:26:05 -0400
Message-ID: <4BEC4423.3030507@kernel.org>
Date: Thu, 13 May 2010 20:25:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jens Axboe <jens.axboe@oracle.com>
CC: James Bottomley <James.Bottomley@suse.de>, jeff@garzik.org,
       linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
       linux-kernel@vger.kernel.org, ben@decadent.org.uk
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
References: <1273766206-17402-1-git-send-email-tj@kernel.org> <1273766778.4353.200.camel@mulgrave.site> <4BEC272E.10508@kernel.org> <20100513174047.GX25951@kernel.dk>
In-Reply-To: <20100513174047.GX25951@kernel.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 18:25:43 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/13/2010 07:40 PM, Jens Axboe wrote:
> Is there a valid case for setting the capacity less than the unlocked
> capacity? I would think the unlock/lock bool api is saner.

IDE currently is the only user (and probably has been that way the
whole time), so it is a binary thing.  I have no idea why the original
interface was designed that way.  Looks like it tried to be too
generic.  Anyways, for the task at hand, the following should be
enough.

	void (*unlock_native_capacity)(void);

This simple signalling is how the current interface is being used
anyway.  If nobody objects, I'll replace ->set_capacity() with the
above.

Thanks.

-- 
tejun
