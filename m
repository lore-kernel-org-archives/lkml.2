Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932297Ab0HDB6p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 21:58:45 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:48477 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0HDB6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 21:58:44 -0400
Subject: Re: [PATCH]: Compress hibernation image with LZO (in-kernel)
From: Bojan Smojver <bojan@rexursive.com>
To: Nigel Cunningham <nigel@tuxonice.net>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <4C58C771.6040505@tuxonice.net>
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
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 11:58:41 +1000
Message-ID: <1280887121.2741.5.camel@shrek.rexursive.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 (2.30.2-4.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-08-04 at 11:50 +1000, Nigel Cunningham wrote:
> I don't see what all the fuss was about. save_image is called after
> the  snapshot is made (hibernate called hibernation_snapshot to create
> the  image, then swsusp_write which in turn calls save_image), so
> there's no  possibility of the memory allocated by it being included
> in the image or  of a memory leak ocuring as a result. 

OK, thanks for your input.

I think what was in question was whether the snapshot can change after
it was made. I was under the impression that it cannot (hence it is
called snapshot - but don't believe me - I have no idea what I'm talking
about). Kame seems to think that it can, so all routines that are
allocating memory after that point should make sure that pages are
marked to be freed upon resume or explicitly freed on resume by
remembering pointers into global variables (if I understood correctly).

But, if you say that snapshot is just that (i.e. static after beeing
made), that's that then.

PS. I'm polishing the patch a bit in terms of overlapping/in-place
compression/decompression (saves memory). Hopefully I'll have a final
version to post today.

-- 
Bojan

