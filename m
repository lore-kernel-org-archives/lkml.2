Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753653Ab1DUID2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 04:03:28 -0400
Received: from smtp.ctxuk.citrix.com ([62.200.22.115]:25454 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab1DUIDZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 04:03:25 -0400
X-IronPort-AV: E=Sophos;i="4.64,250,1301875200"; 
   d="scan'208";a="5407737"
Subject: Re: [Xen-devel] Re: [PATCH v3] xen block backend.
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Christoph Hellwig <hch@infradead.org>
CC: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Stefano Stabellini <Stefano.Stabellini@eu.citrix.com>,
        "jaxboe@fusionio.com" <jaxboe@fusionio.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "konrad@kernel.org" <konrad@kernel.org>
In-Reply-To: <1303370925.5997.322.camel@zakaz.uk.xensource.com>
References: <1303333543-5915-1-git-send-email-konrad.wilk@oracle.com>
	 <20110421033735.GA11501@infradead.org>
	 <1303370925.5997.322.camel@zakaz.uk.xensource.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Citrix Systems, Inc.
Date: Thu, 21 Apr 2011 09:03:23 +0100
Message-ID: <1303373003.5997.337.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-04-21 at 08:28 +0100, Ian Campbell wrote:
> By contrast blktap has a userspace component so it's not all that
> surprising that it turns out to be roughly equivalent to qdisk. (bear in
> mind that Stefano's tests were very rough and ready initial tests, not
> that anyone expects a more thorough benchmarking treatment to really
> change the result). Nobody I know of thinks blktap should go upstream
> since as you say there is no reason not to punt the kernel side part
> into userspace too.

BTW about the only nice property blktap has as it currently stands over
this plan is that it exports an actual block device from vhd, qcow etc
files (in some sense blktap is a loopback driver for complex disk image
file formats). It turns out to occasionally be quite useful to be able
to mount such files, even on non-virtualisation systems (in its current
incarnation blktap has no dependency on Xen).

Having removed the kernel component (or switched to qdisk) we will
probably end up running a blkfront to provide such block devices (sadly
Xen dependent) or, more likely, putting something like an NBD server
into the userspace process.

Ian.

