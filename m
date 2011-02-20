Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751686Ab1BTTgm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 14:36:42 -0500
Received: from smtp.nokia.com ([147.243.128.26]:21420 "EHLO mgw-da02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750832Ab1BTTgl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 14:36:41 -0500
From: <aaro.koskinen@nokia.com>
To: <martinez.javier@gmail.com>, <gregkh@suse.de>
CC: <wfp5p@virginia.edu>, <apatard@mandriva.com>, <randy.dunlap@oracle.com>,
        <devel@driverdev.osuosl.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
Subject: RE: [PATCH 0/2] Staging: xgifb: Remove CRIT[FLAGS | BEGIN | END]
 defines nd conditional spinlock compilation logic
Thread-Topic: [PATCH 0/2] Staging: xgifb: Remove CRIT[FLAGS | BEGIN | END]
 defines nd conditional spinlock compilation logic
Thread-Index: AQHL0R7otzIi1wi9YE6LqcZzLUL84pQKxjUi
Date: Sun, 20 Feb 2011 19:36:18 +0000
Message-ID: <CA1B555B4D79E3448D96A7C9847C7D98027F2A@008-AM1MPN1-032.mgdnok.nokia.com>
References: <1298220798-2942-1-git-send-email-martinez.javier@gmail.com>
In-Reply-To: <1298220798-2942-1-git-send-email-martinez.javier@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [109.108.20.25]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 20 Feb 2011 19:36:20.0801 (UTC) FILETIME=[734BCB10:01CBD135]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

From: Javier Martinez Canillas [martinez.javier@gmail.com]:
> xgifb staging driver uses a set of defines that hides the synchronization
> mechanism used to access critical sections. Also, the use of spinlocks
> can be disabled in compile time.
>
> Since the spinlocks ABI only are used in contexts were critical section exists
> (UP with preemption enabled and SMP machines), I think we should always have
> the spinlocks enabled and let the spinlock ABI choose to include the spinlocks
> or not. In the other hand if the driver doesn't need locking at all, then
> maybe we should just delete the spinlock logic.

I think these should be just deleted. The acceleration functions are used by the framebuffer
layer which should take care of concurrent access. Or can you point out some real scenario
where the spinlocks are needed?

A.
