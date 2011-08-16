Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751986Ab1HPT3Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 15:29:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61596 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751592Ab1HPT3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 15:29:23 -0400
Date: Tue, 16 Aug 2011 21:29:18 +0200
From: Tejun Heo <tj@kernel.org>
To: Linas Vepstas <linasvepstas@gmail.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>,
        Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] powerpc/eeh: remove eeh_event_handler()->daemonize()
Message-ID: <20110816192918.GC2803@mtj.dyndns.org>
References: <20110816190858.GA4890@redhat.com>
 <CAHrUA357c2eCq=VkZwL97-nK7Kopzfj84gSESxebhL_P7rCurw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHrUA357c2eCq=VkZwL97-nK7Kopzfj84gSESxebhL_P7rCurw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Aug 16, 2011 at 02:24:12PM -0500, Linas Vepstas wrote:
> BTW, if someone wants to tackle a big, difficult project, one would be
> to untangle the mess that happens when the hardware underneath an
> active block device dies.  Currently, the kernel will deadlock in
> umpteen zillion places waiting for blocks and files that will never
> arrive.

Umm... that has been working fine for SCSI and ATA for years now.
Just aborting pending commands and freeing the device should do it.
Drivers need to take care of driver specific resources (per-req and
per-dev) but that's not different from aborting timed out commands.
What's missing for your use case?

Thanks.

-- 
tejun
