Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754199Ab1EDO2o (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 10:28:44 -0400
Received: from smtprelay04.ispgateway.de ([80.67.18.16]:35985 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753167Ab1EDO2n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 10:28:43 -0400
Message-ID: <4DC16322.2090607@ladisch.de>
Date: Wed, 04 May 2011 16:30:58 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.24 (Windows/20100228)
MIME-Version: 1.0
To: "Eibach, Dirk" <Eibach@gdsys.de>
CC: Jiri Slaby <jirislaby@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: msleep() an load average
References: <48D3D52125C49B43AE880038E2E5314BB5BE9D@SRV101.gdsys.de> <4DC1568B.2080004@gmail.com> <48D3D52125C49B43AE880038E2E5314BB5BE9E@SRV101.gdsys.de>
In-Reply-To: <48D3D52125C49B43AE880038E2E5314BB5BE9E@SRV101.gdsys.de>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Eibach, Dirk wrote:
> > Uninterruptible sleeps count as I/O load.
> 
> Is there any practical reason behind this or was it just an igenious
> invention to annoy those smug userspace developers?

Historically, uninterruptible sleeps were the best way to detect I/O
load.  Furthermore, a process that is doing I/O is very likely to
continue running soon, while other sleeps are more likely to indicate
that the process is waiting for some event to wake it up to begin doing
something, so this better predicts CPU load.  Finally, a busy device is
likely to prevent other programs from running well, so it makes sense
to count this against the load.

msleep() is commonly used to handle device communication delays, which
is essentially the same case as waiting for disk I/O.  It might be
possible to introduce some new flags or functions to allow long
uninterruptible sleeps that do not affect the load, but this has not
been necessary so far because knowledge of this quirk of the load
heuristic is necessary for every great kernel hacker.  ;-)


Regards,
Clemens
