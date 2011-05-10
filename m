Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754545Ab1EJNH7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 09:07:59 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57909 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169Ab1EJNH6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 09:07:58 -0400
Date: Tue, 10 May 2011 09:07:54 -0400
From: Christoph Hellwig <hch@infradead.org>
To: KY Srinivasan <kys@microsoft.com>
Cc: Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>
Subject: Re: various vmbus review comments
Message-ID: <20110510130754.GA6667@infradead.org>
References: <20110503204641.GA11132@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481DFCFA@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110504163228.GA19754@kroah.com>
 <6E21E5352C11B742B20C142EB499E0481E0694@TK5EX14MBXC124.redmond.corp.microsoft.com>
 <20110509143352.GB29635@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481E95C6@TK5EX14MBXC128.redmond.corp.microsoft.com>
 <20110510052425.GA31087@infradead.org>
 <6E21E5352C11B742B20C142EB499E0481EEFF1@TK5EX14MBXC128.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481EEFF1@TK5EX14MBXC128.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I must be missing something here. As I look at the block driver (and
> this is indicative of other drivers as well); the exit routine -
> blkvsc_drv_exit, first iterates through all the devices it manages
> and invokes device_unregister() on each of the devices and then 
> invokes vmbus_child_driver_unregister() which is just a wrapper on
> driver_unregister(). So, if I understand you correctly, you want the devices to
> persist even if there is no driver bound to them. So, if I eliminated the code
> that iterates over the devices and unregisters them, that should fix the problem
> and I can do this without changing the vmbus core interfaces.

If that actually works go for it.  But there's no way to know that
without actually implementing and testing it.

