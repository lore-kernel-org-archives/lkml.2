Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758148Ab0HDCOW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 22:14:22 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:44788 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757933Ab0HDCOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 22:14:21 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Nigel Cunningham <nigel@tuxonice.net>, linux-kernel@vger.kernel.org
In-Reply-To: <20100804110248.13a2452b.kamezawa.hiroyu@jp.fujitsu.com>
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
	 <4C58C771.6040505@tuxonice.net>
	 <20100804110248.13a2452b.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 12:14:19 +1000
Message-ID: <1280888059.2741.8.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 11:02 +0900, KAMEZAWA Hiroyuki wrote:
> Then, after resume, all vmalloc() area is resumed as "allocated".
> 
> Wrong ? 

I actually tried remembering vmalloc() returned pointers into a global
variable as you suggested. On resume, they were always set to NULL,
which would suggest that what has gotten into the image was the state
before vmalloc() was called in save_image(). See:
http://lkml.org/lkml/2010/8/2/537.

Anyone else wants to comment here?

-- 
Bojan

