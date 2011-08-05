Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872Ab1HEKGk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 06:06:40 -0400
Received: from queue01.mail.zen.net.uk ([212.23.3.234]:41733 "EHLO
	queue01.mail.zen.net.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753915Ab1HEKGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 06:06:37 -0400
X-Greylist: delayed 1396 seconds by postgrey-1.27 at vger.kernel.org; Fri, 05 Aug 2011 06:06:37 EDT
Message-ID: <4E3BBB00.1050101@cantab.net>
Date: Fri, 05 Aug 2011 10:42:24 +0100
From: David Vrabel <dvrabel@cantab.net>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: Joe Jin <joe.jin@oracle.com>,
        "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
        Jens Axboe <jaxboe@fusionio.com>,
        Greg Marsden <greg.marsden@oracle.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ian Campbell <Ian.Campbell@eu.citrix.com>,
        Annie Li <annie.li@oracle.com>, Kurt C Hackel <KURT.HACKEL@oracle.com>,
        Daniel Stodden <daniel.stodden@citrix.com>
References: <4E3A486D.7060506@oracle.com> <4E3A493C.2070103@oracle.com> <20110804194838.GA12459@dumpdata.com>
In-Reply-To: <20110804194838.GA12459@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.70.146.43
X-SA-Exim-Mail-From: dvrabel@cantab.net
Subject: Re: [Xen-devel] Re: [PATCH -v3 2/3] xen-blkback: repleace check kthread_should_stop()
 to remove_requested in xen_blkif_schedule() loop.
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:26:47 +0000)
X-SA-Exim-Scanned: Yes (on pear)
X-Originating-Smarthost03-IP: [82.70.146.41]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 20:48, Konrad Rzeszutek Wilk wrote:
> <sigh>  I can't believe I didn't catch this earlier, but this a
> big NO NO. Each patch _MUST_ be compile on its own. If I commit
> patch 1 and this patch, the compile (actually linker) process
> stops b/c xen_blkback_close is not defined:

All three patches should be merged together as patch 2 on it's own will 
break the driver as the thread will never exit as 
blkif->remove_requested isn't set until patch 3.

David
