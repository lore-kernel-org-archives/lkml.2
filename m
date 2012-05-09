Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757817Ab2EIPDy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 11:03:54 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38655
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753457Ab2EIPDw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 11:03:52 -0400
Date: Wed, 9 May 2012 11:03:43 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Arnd Bergmann <arnd.bergmann@linaro.org>
Cc: Dave Chinner <david@fromorbit.com>, "S, Venkatraman" <svenkatr@ti.com>,
        linux-mmc@vger.kernel.org, cjb@laptop.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, alex.lemberg@sandisk.com,
        ilan.smith@sandisk.com, lporzio@micron.com,
        rmk+kernel@arm.linux.org.uk
Subject: Re: [PATCH v2 01/16] FS: Added demand paging markers to filesystem
Message-ID: <20120509150343.GB14916@infradead.org>
References: <1336054995-22988-1-git-send-email-svenkatr@ti.com>
 <CANfBPZ_2JeWUu7ti97CVc=ODeEi65ke9EKV6Uje0JHcCM8gYqQ@mail.gmail.com>
 <20120509003348.GM5091@dastard>
 <201205091359.40554.arnd.bergmann@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201205091359.40554.arnd.bergmann@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 01:59:40PM +0000, Arnd Bergmann wrote:
> My feeling is that we should just treat every (REQ_SYNC | REQ_READ)
> request the same and let them interrupt long-running writes,
> independent of whether it's REQ_META or demand paging.

It's funny that the CFQ scheduler used to boost metadata reads that
have REQ_META set - in fact it still does for those filesystems using
the now split out REQ_PRIO.

