Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752958Ab2EFC6X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 22:58:23 -0400
Received: from mail-pz0-f45.google.com ([209.85.210.45]:35279 "EHLO
	mail-pz0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab2EFC6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 22:58:21 -0400
Date: Sat, 5 May 2012 19:56:23 -0700
From: Anton Vorontsov <cbouatmailru@gmail.com>
To: Chanwoo Choi <cw00.choi@samsung.com>
Cc: David Woodhouse <dwmw2@infradead.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "myungjoo.ham@samsung.com" <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [RESEND PATCH v2 0/2] power_supply: update Charger-Manager
Message-ID: <20120506025623.GA8437@lizard>
References: <4F7E3945.6000800@samsung.com>
 <4F9684BC.2000004@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F9684BC.2000004@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 07:47:24PM +0900, Chanwoo Choi wrote:
[...]
>  Documentation/power/charger-manager.txt |   41 +++-
>  drivers/power/charger-manager.c         |  391
> +++++++++++++++++++++++++++++++
>  include/linux/power/charger-manager.h   |   49 ++++-
>  3 files changed, 471 insertions(+), 10 deletions(-)

Applied, thanks!

Note that the patches were word-wrap damaged, I had to fix them by
hand. The file 'linux/Documentation/email-clients.txt' contains some
useful tips for setting up commonly used mail clients. You might
also try using 'git send-email'.

While looking through the CM code, I noticed that cm uevents
are not friendly wrt several chargers (the code has static variables
in the uevent_notify() func).

Also, what's the rationale behind implementing own uevent handling,
and not using power_supply uevents (see power_supply_sysfs.c
and power_supply_changed() thing)? Also, you don't seem to
report variables in the uevent, but just messages. That's unusual.

Thanks,

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
