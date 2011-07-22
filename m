Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755189Ab1GVTwi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 15:52:38 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:59857 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754948Ab1GVTwh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 15:52:37 -0400
Subject: Re: Linux 3.0 STILL dies on USB device hotplug - please merge fix
 ASAP
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: stern@rowland.harvard.edu, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, torvalds@linux-foundation.org,
        stable@kernel.org, Dan Williams <dan.j.williams@intel.com>
In-Reply-To: <20110722170214.GR8006@one.firstfloor.org>
References: <20110722170214.GR8006@one.firstfloor.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 15:52:28 -0400
Message-ID: <1311364348.7153.3.camel@mulgrave>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-07-22 at 19:02 +0200, Andi Kleen wrote:
> Hi,
> 
> 3.0 still oopses and dies immediately on USB device hot unplug.
> The same problem also triggered with SAS device according to Dan.
> 
> There was a lot of debugging on this a few weeks back and Alan Stern
> posted a SCSI layer patch that fixed the problem (for both USB
> and SAS):
> 
> http://68.183.106.108/lists/linux-usb/msg49001.html
> 
> But for some reason that patch didn't make it into 3.0 and 3.0 still
> happily oopses as the RC*s.
> 
> Can you please merge this patch ASAP?  This should also go to stable.
> 
> At least for me it makes pure 3.0 very risky to use, because these USB 
> hotunplug events are not uncommon and I end up with a dead machine.

Like I said at the time, the patch is wrong because of the relocation of
the queue teardown.  I posted a corrected version, but did anyone test?
Anyway, I merged it on the grounds that it worked for me, but if you
could confirm with linux-next, that would be great (I'll send the pull
request shortly, since it now needs to go via the merge window and I'm
currently in mid journey to Russia.

James


