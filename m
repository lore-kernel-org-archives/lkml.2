Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2JZL0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 07:26:21 -0400
Received: from casper.infradead.org ([85.118.1.10]:41554 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753336Ab2JZL0U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 07:26:20 -0400
Message-ID: <1351250734.16863.26.camel@twins>
Subject: Re: lockdep info message
From: Peter Zijlstra <peterz@infradead.org>
To: Arend van Spriel <arend@broadcom.com>
Cc: Ingo Molnar <mingo@redhat.com>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Fri, 26 Oct 2012 13:25:34 +0200
In-Reply-To: <508A62DC.50805@broadcom.com>
References: <508A62DC.50805@broadcom.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-26 at 12:15 +0200, Arend van Spriel wrote:
> Hi Peter and/or Ingo,
> 
> I am working on a driver (brcmfmac) and when unloading it or unplugging 
> the device I get this info message (see below) upon calling 
> cancel_work_sync(). Just wondering if there is something I need to do in 
> the driver or should it be done in workqueue code.

Your driver, as that's the one allocating the struct work_struct thingy.

You've either failed to use INIT_WORK() or need to use
INIT_WORK_ONSTACK() if that's appropriate. It looks like you could have
used DECLARE*_WORK inside a function or something similar.

Anyway, without the driver code present I can't really say much more.
