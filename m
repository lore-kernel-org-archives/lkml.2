Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757646Ab0EFTx5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 15:53:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:40540 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757182Ab0EFTx4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 15:53:56 -0400
Date: Thu, 6 May 2010 15:53:54 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Anton Vorontsov <avorontsov@mvista.com>
cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Sebastian Siewior <bigeasy@linutronix.de>,
       Catalin Marinas <catalin.marinas@arm.com>,
       Bryan Wu <cooloney@kernel.org>, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: isp1760: Soften DW3 X/transaction error bit handling
In-Reply-To: <20100506191532.GA11365@oksana.dev.rtsoft.ru>
Message-ID: <Pine.LNX.4.44L0.1005061543421.1708-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 6 May 2010, Anton Vorontsov wrote:

> It appears that the 'pehcd' driver checks the X bit only if the
> transaction is halted, otherwise the error is so far
> insignificant.
> 
> I didn't find where exactly ISP1760 spec mandates 'H && X'
> handling (maybe it's in the EHCI spec?),

Yes, it is described implicitly in the EHCI spec, section 4.10.3.
Transaction errors cause the status field to be updated to reflect the
type of error, but the transaction continues to be retried until the
Active bit is set to 0.  When the error counter reaches 0, the Halt bit
is set and the Active bit is cleared.

Alan Stern

