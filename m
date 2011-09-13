Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753501Ab1IMMtQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 08:49:16 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60082
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753321Ab1IMMtO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 08:49:14 -0400
Date: Tue, 13 Sep 2011 08:49:06 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Sam Bradshaw (sbradshaw)" <sbradshaw@micron.com>
Cc: jaxboe@fusionio.com, alan@lxorguk.ukuu.org.uk, hch@infradead.org,
        linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Garzik <jgarzik@pobox.com>, jmoyer@redhat.com,
        "Asai Thambi Samymuthu Pattrayasamy (asamymuthupa) [CONTRACTOR]" 
	<asamymuthupa@micron.com>
Subject: Re: [PATCH v4] drivers/block/mtip32xx: Adding new driver mtip32xx
Message-ID: <20110913124906.GA17855@infradead.org>
References: <22A973199D2C2F46933448F6E7990A3002C80026@ntxboimbx31.micron.com>
 <4E44E782.7090309@fusionio.com>
 <2A9BE4FF6209B644B6F8EB62DE6AEA1E07663ED4@ntxfrembx01.micron.com>
 <20110909085433.GA9593@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110909085433.GA9593@infradead.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Btw, there is another _huge_ issue with the driver, and that is the
lack of any internal queueing.  Remember the make_request interface is
an extremly thin layer (or rather the lack of it) below the filesystem.

So for example if eh_active is non-zero you return -EBUSY to the
filesystems.  That's an error code it a) doesn't recognize and b)
couldn't handle even if it did.  Similarly mtip_hw_get_scatterlist
simply blocks if no tag is currently available instead of queueing
it up.
