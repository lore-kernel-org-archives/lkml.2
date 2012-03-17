Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030540Ab2CQPRk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Mar 2012 11:17:40 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33734 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755675Ab2CQPRg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Mar 2012 11:17:36 -0400
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/2] i2c: Don't assume bus nr 0 if none was specified
To: Karol Lewandowski <k.lewandowsk@samsung.com>, w.sang@pengutronix.de
Cc: ben-linux@fluff.org, khali@linux-fr.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, hskinnemoen@gmail.com,
        dirk.brandewie@gmail.com, bigeasy@linutronix.de,
        m.szyprowski@samsung.com, kyungmin.park@samsung.com
In-Reply-To: <4F6331AF.3010007@samsung.com>
References: <1331900343-6743-1-git-send-email-k.lewandowsk@samsung.com> <4F6331AF.3010007@samsung.com>
Date: Sat, 17 Mar 2012 10:50:56 +0000
Message-Id: <20120317105056.BC9EE3E093F@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Mar 2012 13:27:27 +0100, Karol Lewandowski <k.lewandowsk@samsung.com> wrote:
> On 16.03.2012 13:19, Karol Lewandowski wrote:
> 
> > Hi,
> > 
> > i2c controller drivers used to assume bus number 0 when none (-1) was specified.
> > 
> > This worked on non-device tree systems, where one could explicitly specify
> > bus number via platform data.  On DT-enabled systems bus number is always -1.
> > 
> > Some drivers assume bus number 0 when -1 is specified.  This patchset kills
> > this logic and switches to dynamic bus allocation (default when -1 is provided[1]).
> 
> 
> [ I must have lost actual problem description while rewording
>   message itself... ]
> 
> Problem arises when multiple drivers (or multiple instances
> of one driver) try to assume the same fixed bus number (0).
> 
> This causes simply causes i2c_add_numbered_bus() to fail.
> Leaving -1 works perfectly, as registration function switches
> to dynamic id registration.

Patch series looks good to me.  You'll need acks from the affected users.

g.

