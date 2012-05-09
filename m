Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760302Ab2EIQzO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:55:14 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52649 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758412Ab2EIQzE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:55:04 -0400
From: Arnd Bergmann <arnd.bergmann@linaro.org>
Organization: Linaro Limited 
To: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH v2 01/16] FS: Added demand paging markers to filesystem
Date: Wed, 9 May 2012 16:54:30 +0000
User-Agent: KMail/1.12.2 (Linux/3.4.0-rc3; KDE/4.3.2; x86_64; ; )
Cc: Dave Chinner <david@fromorbit.com>, "S, Venkatraman" <svenkatr@ti.com>,
        linux-mmc@vger.kernel.org, cjb@laptop.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.lemberg@sandisk.com,
        ilan.smith@sandisk.com, lporzio@micron.com,
        rmk+kernel@arm.linux.org.uk
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com> <201205091359.40554.arnd.bergmann@linaro.org> <20120509150343.GB14916@infradead.org>
In-Reply-To: <20120509150343.GB14916@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205091654.30277.arnd.bergmann@linaro.org>
X-Provags-ID: V02:K0:cMsnJOwo4hB/FzurWTDiTJCRCZFFdXUPV5JNLlmYEAn
 mIv0bzLvxoQnovb+/9N2vhFgpbwCjwndK+emYFwvlzGUiImk7E
 l2Py02cpp7Ls1AcVF+4b3eJygdVkvuAHPAvzNXKcNd1RQHLzaQ
 msLHEz57MVJZVJmKmdtEcdAtgAvkq0f44PHU0D2Zo8BLzRPvvQ
 B4rcXjYedwWEnODvY31kVheMukUBjXvvGtmvmQtZdj7UbGNtgC
 Q/fYnsnqRZ76EvvlkKDcO9ZoCy71UapU3HEKxV7UX0NHnkekcZ
 7uKnI04IcathzYMuNMqbgilW5gC6JbO3aJOZJ2+A3QXQiNIbtK
 AXvC1tBEIkF3gXDhKPnVYIQwjoDUVDgXr13wxg0EZ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 09 May 2012, Christoph Hellwig wrote:
> On Wed, May 09, 2012 at 01:59:40PM +0000, Arnd Bergmann wrote:
> > My feeling is that we should just treat every (REQ_SYNC | REQ_READ)
> > request the same and let them interrupt long-running writes,
> > independent of whether it's REQ_META or demand paging.
> 
> It's funny that the CFQ scheduler used to boost metadata reads that
> have REQ_META set - in fact it still does for those filesystems using
> the now split out REQ_PRIO.

That certainly sounds more sensible than the opposite.

Of course, this is somewhat unrelated to the question of prioritizing
reads over any writes that are already started. IMHO It would be
pointless to only stop the write in order to do a REQ_PRIO read but
not any other read.

	Arnd
