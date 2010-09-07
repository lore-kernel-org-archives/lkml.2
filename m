Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932411Ab0IGRic (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 13:38:32 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:50897 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932402Ab0IGRib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 13:38:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [patch 00/30] semaphore cleanup
Date: Tue, 7 Sep 2010 19:38:17 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc3; KDE/4.5.1; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Christoph Hellwig <hch@infradead.org>
References: <20100907124636.880953480@linutronix.de> <201009071727.55023.arnd@arndb.de> <alpine.LFD.2.00.1009071736100.2477@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1009071736100.2477@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201009071938.17681.arnd@arndb.de>
X-Provags-ID: V02:K0:admBBEyK69ah278tzKCymSzhUy+GQdTapYkfYY3NvT3
 FWBIslPhVXegDPH7Ss9mkcUHtEZSzabHyRoQlmy9hyjfXcBNEM
 F3yKEJ1by0PQUru+HJ2hTmIMhfj74NALpJFs6BbYYF+AP1I//l
 jgWBzuhUM+Jys+FavVHEVAFlTJDrIn3cvIByLaDsZRg1C1ZskT
 wyCTNimTjpcfxIg/FFE/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 07 September 2010 17:38:33 Thomas Gleixner wrote:
> Some of those can be converted to completions, but most of them have
> utterly borked semantics. I'm not sure if its worth the trouble to
> actually change all this as most of that stuff is ancient. Real
> semaphores are not going away (at least not the counting type ones).

Ok. I thought I had seen a series from Ingo some time ago that actually
converted all of them to something else, but maybe I was mistaken.

Not sure if there is anything to be gained (other than more work) from
merging semaphore and rw_semaphore into a single implementation that
is both counting and read-write.

One problem I see (not with your series, just with semaphores in
general) is that they keep creeping in through drivers/staging: About
half the users we currently have are in staging. Obviously they get
removed from there in order for drivers to graduate from staging, but
not exposing the interface to device drivers would reduce the number
of bad choices for authors to make.

	Arnd
