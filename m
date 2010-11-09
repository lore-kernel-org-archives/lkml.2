Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755528Ab0KIVuu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 16:50:50 -0500
Received: from e8.ny.us.ibm.com ([32.97.182.138]:50353 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab0KIVuq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 16:50:46 -0500
Date: Tue, 9 Nov 2010 13:50:44 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Daniel J Blueman <daniel.blueman@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [2.6.37-rc1] sys_ioprio_set and RCU locking...
Message-ID: <20101109215044.GB4032@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <AANLkTi=xj6xW5SnrdQos4P-MtJP8+fwfaa3r7LPfdLh4@mail.gmail.com>
 <20101107185433.GD15561@linux.vnet.ibm.com>
 <4CD7FAFD.1060802@fusionio.com>
 <20101108135204.GE2580@linux.vnet.ibm.com>
 <4CD80162.9000607@fusionio.com>
 <4CD9B07E.70502@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD9B07E.70502@fusionio.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 09:35:10PM +0100, Jens Axboe wrote:
> On 2010-11-08 14:55, Jens Axboe wrote:
> >>>>> Take the RCU lock for read across acquiring the pointer to the task
> >>>>> credentials and dereferencing it.
> >>>>
> >>>> Jens, does this look sane?
> >>>
> >>> Yes, looks clean enough to me.
> >>
> >> Very good!  Are you willing to take the patch in your tree?
> > 
> > Certainly, I'm in the middle of patch monkeying now anyway. Will queue
> > it up.
> 
> The patch was buggy, I discovered that it does not do the proper
> RCU unlock if we fail the uid match. Merged version here:
> 
> http://git.kernel.dk/?p=linux-2.6-block.git;a=commit;h=1a882abdbf9579ad0e5655f928e4ede30db301e6

Ouch!!!  I missed that one entirely, good catch!!!

							Thanx, Paul
