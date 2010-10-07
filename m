Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759932Ab0JGHgf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 03:36:35 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58415 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753219Ab0JGHge (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 03:36:34 -0400
Date: Thu, 7 Oct 2010 09:36:33 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        fengguang.wu@intel.com, linux-mm@kvack.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 2/4] HWPOISON: Copy si_addr_lsb to user
Message-ID: <20101007073633.GF5010@basil.fritz.box>
References: <1286398141-13749-1-git-send-email-andi@firstfloor.org>
 <1286398141-13749-3-git-send-email-andi@firstfloor.org>
 <4CAD6943.2020805@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CAD6943.2020805@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 07, 2010 at 03:31:31PM +0900, Hidetoshi Seto wrote:
> (2010/10/07 5:48), Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > The original hwpoison code added a new siginfo field si_addr_lsb to
> > pass the granuality of the fault address to user space. Unfortunately
> > this field was never copied to user space. Fix this here.
> > 
> > I added explicit checks for the MCEERR codes to avoid having
> > to patch all potential callers to initialize the field.
> 
> Now QEMU uses signalfd to catch the SIGBUS delivered to the
> main thread, so I think similar fix to copy lsb to user is
> required for signalfd too. 

Good catch. I don't think qemu uses this today, but it should
be fixed there too for .37 at least.

-Andi

