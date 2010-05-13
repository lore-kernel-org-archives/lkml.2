Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab0EMQWb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 12:22:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:50592 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759312Ab0EMQW0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 12:22:26 -0400
Message-ID: <4BEC272E.10508@kernel.org>
Date: Thu, 13 May 2010 18:22:06 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: jeff@garzik.org, linux-ide@vger.kernel.org, jens.axboe@oracle.com,
       linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
       ben@decadent.org.uk
Subject: Re: [PATCHSET] libata: implement ->set_capacity()
References: <1273766206-17402-1-git-send-email-tj@kernel.org> <1273766778.4353.200.camel@mulgrave.site>
In-Reply-To: <1273766778.4353.200.camel@mulgrave.site>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 13 May 2010 16:22:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 05/13/2010 06:06 PM, James Bottomley wrote:
> I'm not sure this is such a good interface ... it sounds very error
> prone for what is effectively a binary lock/unlock.

Well, the original block interface was like that.  It has been used as
binary switch tho.  The requested capacity is always ~0ULL and return
value smaller than the current capacity is ignored.  I'm all for
dropping the capacity parameter and the return value from
->set_capacity() so that it just unlocks native capacity and directly
sets the new capacity.  Jens?

> Instead of just saying unlock the HPA and show me the new capacity
> (with a rescan), you have to echo the right number of sectors to the
> set_capacity variable.  Isn't a hpa_unlock libata specific attribute
> better (you could even call BLKRRPART from the user context of the
> write)?

Hmmm... I lost you.  What are you talking about?

Thanks.

-- 
tejun
