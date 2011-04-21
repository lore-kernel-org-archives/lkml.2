Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1DUH2s (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 03:28:48 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:36979 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753006Ab1DUH2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 03:28:47 -0400
X-IronPort-AV: E=Sophos;i="4.64,250,1301875200"; 
   d="scan'208";a="5406961"
Subject: Re: [Xen-devel] Re: [PATCH v3] xen block backend.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Christoph Hellwig <hch@infradead.org>
CC: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "konrad@kernel.org" <konrad@kernel.org>
In-Reply-To: <20110421033735.GA11501@infradead.org>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
	 <20110421033735.GA11501@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 21 Apr 2011 08:28:45 +0100
Message-ID: <1303370925.5997.322.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 04:37 +0100, Christoph Hellwig wrote:
> This should sit in userspace.  And last time was discussed the issue
> Stefano said the qemu Xen disk backend is just as fast as this kernel
> code.  And that's with an not even very optimized codebase yet.

Stefano was comparing qdisk to blktap. This patch is blkback which is a
completely in-kernel driver which exports raw block devices to guests,
e.g. it's very useful in conjunction with LVM, iSCSI, etc. The last
measurements I heard was that qdisk was around 15% down compared to
blkback.

By contrast blktap has a userspace component so it's not all that
surprising that it turns out to be roughly equivalent to qdisk. (bear in
mind that Stefano's tests were very rough and ready initial tests, not
that anyone expects a more thorough benchmarking treatment to really
change the result). Nobody I know of thinks blktap should go upstream
since as you say there is no reason not to punt the kernel side part
into userspace too.

Ian.

> So clear NAK for adding all this mess to the kernel.


