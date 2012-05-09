Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759406Ab2EINXW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 09:23:22 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:38305
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757560Ab2EINXU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 09:23:20 -0400
Date: Wed, 9 May 2012 09:23:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Christoph Hellwig <hch@infradead.org>,
        Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Message-ID: <20120509132317.GA24014@infradead.org>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <4FAA02DA.3000201@gmail.com>
 <20120509061956.GA12329@gmail.com>
 <20120509082527.GA10674@infradead.org>
 <20120509093016.GA12754@gmail.com>
 <20120509111243.GB29593@infradead.org>
 <20120509124804.GA13329@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509124804.GA13329@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 08:48:04PM +0800, Zheng Liu wrote:
> Thanks for your explanation.  It seems that there still has a problem.
> If I set the disk to write through mode, I need to modify my application
> to remove all of flush/sync operations.  It is unacceptable for us.

You don't have to - the kernel will not send a SYNCHRONIZE CACHE command
unless the disk advertises a write back cache.

