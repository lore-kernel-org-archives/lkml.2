Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755127Ab2IXHDk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:03:40 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:56850 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753647Ab2IXHDj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:03:39 -0400
Message-ID: <1348470210.2475.47.camel@ThinkPad-T420>
Subject: Re: [PATCH scsi] Add NULL checking of return value from
 scsi_cmd_to_driver()
From: Li Zhong <zhong@linux.vnet.ibm.com>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon, 24 Sep 2012 15:03:30 +0800
In-Reply-To: <1348465493.2467.3.camel@dabdike>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	 <1348465493.2467.3.camel@dabdike>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
x-cbid: 12092407-0260-0000-0000-000001E35A84
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 09:44 +0400, James Bottomley wrote:
> On Mon, 2012-09-24 at 13:30 +0800, Li Zhong wrote:
> > Just noticed that after commit 919f797, it is possible that 
> > scsi_cmd_to_driver() returns NULL. This patch adds the NULL checking for drv 
> > returned from the above function. 
> > 
> > Maybe it is not possible at run time, but from the code itself, we'd better
> > have this check?  
> 
> There's not much point having a check that never trips, unless it's an
> assert, in which case a NULL deref does that.  All it does is add
> pointless instructions to the critical path.  only REQ_TYPE_BLOCK_PC
> commands can be submitted without a driver, so the check above would
> seem to preclude that.

Hi James, 

Thank you, it sounds reasonable to me. Let's drop it. 

Thanks, Zhong

> James
> 
> 


