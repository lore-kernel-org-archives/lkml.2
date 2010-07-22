Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755840Ab0GVUQ5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 16:16:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59922 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752499Ab0GVUQy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 16:16:54 -0400
Message-ID: <4C48A667.2000702@petalogix.com>
Date: Thu, 22 Jul 2010 22:13:27 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Sachin Sant <sachinp@in.ibm.com>, linux-s390@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH wq#for-next] workqueue: fix how cpu number is stored in
 work->data
References: <4C46CEA3.7040503@in.ibm.com>	<4C4718D5.1080902@kernel.org> <20100722112557.14b65077@mschwide.boeblingen.de.ibm.com> <4C4838B8.1080400@kernel.org>
In-Reply-To: <4C4838B8.1080400@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
> Once a work starts execution, its data contains the cpu number it was
> on instead of pointing to cwq.  This is added by commit 7a22ad75
> (workqueue: carry cpu number in work data once execution starts) to
> reliably determine the work was last on even if the workqueue itself
> was destroyed inbetween.
> 
> Whether data points to a cwq or contains a cpu number was
> distinguished by comparing the value against PAGE_OFFSET.  The
> assumption was that a cpu number should be below PAGE_OFFSET while a
> pointer to cwq should be above it.  However, on architectures which
> use separate address spaces for user and kernel spaces, this doesn't
> hold as PAGE_OFFSET is zero.
> 
> Fix it by using an explicit flag, WORK_STRUCT_CWQ, to mark what the
> data field contains.  If the flag is set, it's pointing to a cwq;
> otherwise, it contains a cpu number.
> 
> Reported on s390 and microblaze during linux-next testing.
> 
> Signed-off-by: Tejun Heo <tj@kernel.org>
> Reported-by: Sachin Sant <sachinp@in.ibm.com>
> Reported-by: Michal Simek <michal.simek@petalogix.com>
> Reported-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
> ---
> Yeah, that was a stupid assumption by me.  Can you guys please test
> whether this fixes the problem?
> 
> Thanks.

Microblaze is OK.

Tested-by: Michal Simek <monstr@monstr.eu>

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
