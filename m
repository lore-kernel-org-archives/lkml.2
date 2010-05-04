Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932256Ab0EDRFX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 13:05:23 -0400
Received: from mga05.intel.com ([192.55.52.89]:4525 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932198Ab0EDRFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 13:05:20 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.52,328,1270450800"; 
   d="scan'208";a="795357875"
Date: Tue, 4 May 2010 17:27:04 +0100
From: Alan Cox <alan@linux.intel.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Staging: RAR support - bring ready to move from staging
Message-ID: <20100504172704.77cdbeb8@linux.intel.com>
In-Reply-To: <20100504155112.GA26143@kroah.com>
References: <20100504105032.3de58e68@linux.intel.com>
	<20100504155112.GA26143@kroah.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 4 May 2010 08:51:12 -0700
Greg KH <greg@kroah.com> wrote:

> On Tue, May 04, 2010 at 10:50:32AM +0100, Alan Cox wrote:
> > 
> > rar: perform a clean up pass
> > 
> > - Move to a registration model where each RAR is claimed/unclaimed
> > - Use that to fix the client stuff (one client per RAR so no need
> > to queue stuff)
> > - Support unregister so drivers can rmmod themselves safely
> > - Fix locking hang on calling rar lock from rar callback
> > - Clean up
> > - Kerneldoc
> 
> I get the following build errors with this patch:
> 	  CC [M]  drivers/staging/memrar/memrar_handler.o
> 	drivers/staging/memrar/memrar_handler.c: In function
> ‘memrar_init’: drivers/staging/memrar/memrar_handler.c:910: warning:
> passing argument 1 of ‘register_rar’ makes integer from pointer
> without a cast

Expected - its a staging driver so I thought a patch that broke the API
of another staging driver was fine (the second patch will fix it up)
