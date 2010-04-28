Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab0D1QRO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 12:17:14 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:40628 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755568Ab0D1QRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 12:17:12 -0400
Message-Id: <20100428161636.272097923@szeredi.hu>
User-Agent: quilt/0.46-1
Date: Wed, 28 Apr 2010 18:16:36 +0200
From: Miklos Szeredi <miklos@szeredi.hu>
To: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org,
       torvalds@linux-foundation.org
Subject: [RFC PATCH 0/6] fuse: implement zero copy read
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series implements splice(2) to the fuse device.  With this it's
possible to move pages directly into the page cache of the fuse
filesystem without ever having to copy the contents.

The next series will implement splicing from the fuse device for zero
copy write operations.

Testing shows improved bandwidth and reduced system time (as
expected).  However there's still some overhead in shuffling pages
between caches.  Further improvements could be achieved by

 - implementing replace_page_cache_page() which atomically removes an
   old page and replaces it with a new one

 - implementing splice a-la O_DIRECT which, instead of populating the
   page cache, would just send/receive data directly in pipe buffers.

Comments?

Thanks,
Miklos
--
