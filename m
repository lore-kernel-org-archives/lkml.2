Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab1GZMfF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:35:05 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58560
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751208Ab1GZMe6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:34:58 -0400
Date: Tue, 26 Jul 2011 08:34:53 -0400
From: Christoph Hellwig <hch@infradead.org>
To: David Wagner <david.wagner@free-electrons.com>
Cc: linux-mtd@lists.infradead.org, dedekind1@gmail.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        tim.bird@am.sony.com
Subject: Re: [PATCH] UBI: new module ubiblk: block layer on top of UBI
Message-ID: <20110726123453.GA18513@infradead.org>
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>
 <1311683250-7921-1-git-send-email-david.wagner@free-electrons.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1311683250-7921-1-git-send-email-david.wagner@free-electrons.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> TODO:
>  * the modules keeps a table of the devices which length is the maximum number
>    of UBI volumes.  It should make use of a linked list.

A linked list isn't very nice either.  Try using idr, which gives you
both an allocator for the minor number space, and a way to look up
the structure by that index.

> Advantages of ubiblk over gluebi+mtdblock_ro:

This section should be in the main commit log, and not that part with
the changelog which gets dropped.

> +int major;

Please don't use global variables with generic names.  In this case you
should neither make it global nor give it a generic name.

