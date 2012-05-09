Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757568Ab2EIIZb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:25:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:37157
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751030Ab2EIIZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:25:29 -0400
Date: Wed, 9 May 2012 04:25:27 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Robert Hancock <hancockrwd@gmail.com>, linux-kernel@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jeff Garzik <jeff@garzik.org>, Zheng Liu <wenqing.lz@taobao.com>
Subject: Re: [RFC][PATCH] libata: enable SATA disk fua detection on default
Message-ID: <20120509082527.GA10674@infradead.org>
References: <1336447443-4685-1-git-send-email-wenqing.lz@taobao.com>
 <4FAA02DA.3000201@gmail.com>
 <20120509061956.GA12329@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120509061956.GA12329@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 02:19:56PM +0800, Zheng Liu wrote:
> disable FUA detection for SATA disk.  If FUA feature can be used, we
> could disable io_barrier to improve the performance.  Now one solution

You can't run with -o nobarrier just because the driver/hardware support
FUA.  However the implementation of -o barrier (aka REQ_FUA) is a lot
more efficient if it is implemented.  If your workload has a high
percentage of REQ_FUA requests it might be better to switch the disks to
write through mode entirely.

