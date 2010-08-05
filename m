Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759421Ab0HEB00 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 21:26:26 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:40191 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751855Ab0HEB0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 21:26:23 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <1280890070.2741.11.camel@shrek.rexursive.com>
References: <1280465201.2600.10.camel@shrek.rexursive.com>
	 <1280486667.2608.1.camel@shrek.rexursive.com>
	 <4C534C9D.8000600@tuxonice.net>
	 <1280532174.2583.1.camel@shrek.rexursive.com>
	 <4C5362E7.3000706@tuxonice.net>
	 <1280538184.2583.11.camel@shrek.rexursive.com>
	 <4C537A01.5040808@tuxonice.net>
	 <1280540035.2658.5.camel@shrek.rexursive.com>
	 <1280551286.3097.6.camel@shrek.rexursive.com>
	 <20100802091752.3c9f180d.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280710453.2727.8.camel@shrek.rexursive.com>
	 <20100802101058.d4f1c7b6.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280712068.2671.0.camel@shrek.rexursive.com>
	 <20100802102750.7d414819.kamezawa.hiroyu@jp.fujitsu.com>
	 <1280713381.2673.2.camel@shrek.rexursive.com>
	 <1280800750.3305.4.camel@shrek.rexursive.com>
	 <1280802642.2627.2.camel@shrek.rexursive.com> <4C58D3B0.10602@tuxonice.net>
	 <1280890070.2741.11.camel@shrek.rexursive.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 05 Aug 2010 11:26:21 +1000
Message-ID: <1280971581.2586.5.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 12:47 +1000, Bojan Smojver wrote:
> PS. Right now, I'm seeing segfaults on resume with my
> overlapping/in-place approach. So, I'll have to find out what is going
> on first.

Well, either I'm doing something idiotic when setting up
overlapping/in-place compression/decompression buffers or the routines
do not work as advertised. In any event, the image is subtly corrupt on
resume using this technique (checksum verified), hence the segfaults.
Please do not use this code on your systems - it may corrupt your file
systems.

For now, I will finalize the patch using two buffers, but I'll drop the
number of pages down to 32, so that we use roughly the same amount of
memory as with overlapping/in-place compression/decompression. Slightly
slower than with 64 pages, but still much faster than original code.

-- 
Bojan

