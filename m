Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753176Ab2IJH7e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 03:59:34 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:43570 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab2IJH7c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 03:59:32 -0400
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Sep 2012 03:59:32 EDT
Message-ID: <504D9C70.5000102@ladisch.de>
Date: Mon, 10 Sep 2012 09:53:20 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:15.0) Gecko/20120824 Thunderbird/15.0
MIME-Version: 1.0
To: shuah.khan@hp.com
CC: LKML <linux-kernel@vger.kernel.org>, shuahkhan@gmail.com,
        linux1394-devel@lists.sf.net
Subject: Re: [RFC] DMA mapping error check analysis
References: <1346595257.4377.5.camel@lorien2> <1347033200.2603.19.camel@lorien2>
In-Reply-To: <1347033200.2603.19.camel@lorien2>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Shuah Khan wrote:
> I analyzed all calls to dma_map_single() and dma_map_page() in the
> kernel, to see if callers check for mapping errors, before using the
> returned address.
>
> The goal of this analysis is to find drivers that currently do not
> check dma mapping errors, and fix them.
>
> I documented the results of this analysis:
>
> http://linuxdriverproject.org/mediawiki/index.php/DMA_Mapping_Error_Analysis

> File Name                  # of calls  Status 	
> drivers/firewire/core-iso.c   1        Unmap Broken
> drivers/firewire/ohci.c       1        Unmap Broken

In ohci.c, ar_context_release() takes care of cleanup.

In core-iso.c, on failure, the callers are responsible to call
fw_iso_buffer_destroy() eventually.  (ioctl_create_iso_context()
doesn't do this correctly if it's called multiple times.)


Regards,
Clemens
