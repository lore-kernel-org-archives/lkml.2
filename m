Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755001Ab2IXHfL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 03:35:11 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:35625 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752146Ab2IXHfJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 03:35:09 -0400
Message-ID: <1348472104.2467.8.camel@dabdike>
Subject: Re: [PATCH scsi] Add NULL checking of return value from
 scsi_cmd_to_driver()
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "Martin K. Petersen" <mkp@mkp.net>
Date: Mon, 24 Sep 2012 11:35:04 +0400
In-Reply-To: <1348470210.2475.47.camel@ThinkPad-T420>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	 <1348465493.2467.3.camel@dabdike> <1348470210.2475.47.camel@ThinkPad-T420>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 15:03 +0800, Li Zhong wrote:
> On Mon, 2012-09-24 at 09:44 +0400, James Bottomley wrote:
> > On Mon, 2012-09-24 at 13:30 +0800, Li Zhong wrote:
> > > Just noticed that after commit 919f797, it is possible that 
> > > scsi_cmd_to_driver() returns NULL. This patch adds the NULL checking for drv 
> > > returned from the above function. 
> > > 
> > > Maybe it is not possible at run time, but from the code itself, we'd better
> > > have this check?  
> > 
> > There's not much point having a check that never trips, unless it's an
> > assert, in which case a NULL deref does that.  All it does is add
> > pointless instructions to the critical path.  only REQ_TYPE_BLOCK_PC
> > commands can be submitted without a driver, so the check above would
> > seem to preclude that.
> 
> Hi James, 
> 
> Thank you, it sounds reasonable to me. Let's drop it. 

Well, there is another thing you might do: The path length of
scsi_cmd_to_driver() increased a lot thanks to 18a4d0a22ed6 it might be
worth getting it back to what it was (this looks to be doable with the
same != REQ_TYPE_BLOCK_PC test in the error handler.  Plus, I think it
fixes a bug where you get different behaviours from REQ_TYPE_BLOCK_PC
commands when a driver is and isn't attached (I've cc'd Martin to see
what he thinks).

James


