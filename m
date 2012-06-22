Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760820Ab2FVAsQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 20:48:16 -0400
Received: from mail-yw0-f51.google.com ([209.85.213.51]:63370 "EHLO
	mail-yw0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760795Ab2FVAsP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 20:48:15 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1206211025060.1164-100000@iolanthe.rowland.org>
References: <CAK9wHMS_P+y+NmvVVrH+nNOb=KPi3rEgJOWEcRcKf3mTkxjDPA@mail.gmail.com>
	<Pine.LNX.4.44L0.1206211025060.1164-100000@iolanthe.rowland.org>
Date: Fri, 22 Jun 2012 08:48:13 +0800
Message-ID: <CAK9wHMTYoxVqj3Ls3Y7NEwgL4Y=XnxGFzyxfy4bseMR_Hhzp7Q@mail.gmail.com>
Subject: Re: pm runtime and system suspend resume
From: chao xie <xiechao.linux@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        pavel@ucw.cz, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/21 Alan Stern <stern@rowland.harvard.edu>:
> On Thu, 21 Jun 2012, chao xie wrote:
>
>> I check the code, __device_suspend will invoke dev->pm_domain->ops
>> first if dev->pm_domain is not NULL.
>> Taking "suspend" as esample, i can do the following things in the
>> dev->pm_domain->ops->suspend
>> 1. invoke dev->driver->pm->suspend for suspending the device
>> 2. do what we do in dev->pm_domain->ops->runtime_suspend for
>> suspending the surrounded logic, for example, shutdown the phy or
>> clocks.
>> So is above implementation fine?
>
> Yes, that sounds like it will work.  Watch out for the case where your
> device is already runtime-suspended when a system suspend occurs.
>
> Have you read section 6 in Documentation/power/runtime_pm.txt?  It is
> related to your question.
>
I will read the document. Thanks very much.

> Alan Stern
>
