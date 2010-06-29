Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755242Ab0F2U0x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 16:26:53 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:48380 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab0F2U0v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 16:26:51 -0400
Date: Tue, 29 Jun 2010 16:26:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Larry Woodman <lwoodman@redhat.com>
Cc: hch@infradead.org, linux-kernel@vger.kernel.org, riel@redhat.com
Subject: Re: Race in wb_do_writeback() ???
Message-ID: <20100629202650.GA28992@infradead.org>
References: <1277843296.3223.98.camel@dhcp-100-19-198.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277843296.3223.98.camel@dhcp-100-19-198.bos.redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 04:28:16PM -0400, Larry Woodman wrote:
> Can you have one unconditional call to wb_clear_pending() after the
> calling wb_writeback()???

In fact we should only have a conditional call after wb_writeback.
I've done that already and it's in Jens' tree for 2.6.36:

	http://git.kernel.dk/?p=linux-2.6-block.git;a=commitdiff;h=79338d2a78ab78efdc1698f1309766a039addf9d

