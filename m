Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753920Ab1DDHoW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 03:44:22 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:46378 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751378Ab1DDHoV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 03:44:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=mQsrPYcpIMxGmVahvrsSk9mZfl6qarBJwQPfDMwceUp1fGw/rLGX7TKHnq70Ot25/7
         aZWDFOw0AkGDLYxnxAMC2VCPsnPjn54dovYJm0VNy9a3XXzvyQgPUjciuWYEsYhErJgS
         75lEOPzLBnlxVVp8AdAIINd4K8KQBhvFsVaUU=
Subject: Re: [PATCH] MTD: Retry Read/Write Transfer Buffer Allocations
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Grant Erickson <marathon96@gmail.com>
Cc: linux-mtd@lists.infradead.org, linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1301902050.2760.23.camel@localhost>
References: <1301705049-15593-1-git-send-email-marathon96@gmail.com>
	 <1301902050.2760.23.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 10:41:50 +0300
Message-ID: <1301902910.2760.31.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 10:27 +0300, Artem Bityutskiy wrote:
> An third, as I wrote in my answer to Jarkko, allocating large contiguous
> buffers is bad for performance: if the system memory is fragmented and
> there is no such large contiguous areas, the kernel will start writing
> back dirty FS data, killing FS caches, shrinking caches and buggers,
> probably even swapping out applications. We do not want MTD to cause
> this at all.

s/buggers/buffers/

> Probably we can mitigate this with kmalloc flags. Now, I'm not sure what
> flags are the optimal, but I'd do:
> 
> __GFP_NOWARN | __GFP_WAIT | __GFP_NORETRY

Of course I meant you should use special flags as long as you are
allocating more than 1 contiguous page. But the last PAGE_SIZE
allocation should be done with standard GFP_KERNEL flag.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)

