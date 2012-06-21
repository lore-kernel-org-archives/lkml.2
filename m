Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756392Ab2FUO1t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 10:27:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42132 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753939Ab2FUO1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 10:27:47 -0400
Date: Thu, 21 Jun 2012 10:27:46 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: chao xie <xiechao.linux@gmail.com>
cc: linux-pm@vger.kernel.org, <linux-kernel@vger.kernel.org>, <rjw@sisk.pl>,
        <pavel@ucw.cz>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: pm runtime and system suspend resume
In-Reply-To: <CAK9wHMS_P+y+NmvVVrH+nNOb=KPi3rEgJOWEcRcKf3mTkxjDPA@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1206211025060.1164-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 21 Jun 2012, chao xie wrote:

> I check the code, __device_suspend will invoke dev->pm_domain->ops
> first if dev->pm_domain is not NULL.
> Taking "suspend" as esample, i can do the following things in the
> dev->pm_domain->ops->suspend
> 1. invoke dev->driver->pm->suspend for suspending the device
> 2. do what we do in dev->pm_domain->ops->runtime_suspend for
> suspending the surrounded logic, for example, shutdown the phy or
> clocks.
> So is above implementation fine?

Yes, that sounds like it will work.  Watch out for the case where your 
device is already runtime-suspended when a system suspend occurs.

Have you read section 6 in Documentation/power/runtime_pm.txt?  It is 
related to your question.

Alan Stern

