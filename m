Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932355Ab1IHIWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Sep 2011 04:22:41 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58411
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932322Ab1IHIWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Sep 2011 04:22:39 -0400
Date: Thu, 8 Sep 2011 04:22:29 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>, jbeulich@novell.com,
        linux-kernel@vger.kernel.org, JBeulich@suse.com
Subject: Re: Help with implementing some form of barriers in 3.0 kernels.
Message-ID: <20110908082229.GB14549@infradead.org>
References: <20110907174832.GN32190@dumpdata.com>
 <20110907181740.GG31726@redhat.com>
 <20110907201620.GB26548@infradead.org>
 <20110907213137.GJ31726@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110907213137.GJ31726@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 07, 2011 at 05:31:37PM -0400, Vivek Goyal wrote:
> I have a basic question. In old guest why BARRIER handling on request
> queue is not sufficient for sequencing and ordering of requests and why
> xen-blkfront and qemu have to do something about it.
> 
> I am also wondering if virtio-blk have similar issues?

Mainline xen-blkfront was using ORDERED_TAG before, which meant
bypassing the sequencer entirely, as well as not beeing able to
implement plain cache flushes as used by ->fsync.

