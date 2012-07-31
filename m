Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527Ab2GaHBg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 03:01:36 -0400
Received: from smtprelay04.ispgateway.de ([80.67.31.38]:45985 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754037Ab2GaHBf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 03:01:35 -0400
Message-ID: <50178249.7090306@ladisch.de>
Date: Tue, 31 Jul 2012 08:59:21 +0200
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Karl Beldan <karl.beldan@gmail.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: About dma_sync_single_for_{cpu,device}
References: <20120730202401.GA4947@gobelin> <20120731064557.GA4676@gobelin>
In-Reply-To: <20120731064557.GA4676@gobelin>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: bGludXgta2VybmVsQGNsLmRvbWFpbmZhY3Rvcnkta3VuZGUuZGU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Karl Beldan wrote:
> To tx a chunk of data from the SoC => network device, we :
> - prepare a buffer with a leading header embedding a pattern,
> - trigger the xfer and wait for an irq
> // The device updates the pattern and then triggers an irq
> - upon irq we check the pattern for the xfer completion
>
> I was expecting the following to work:
> 	addr = dma_map_single(dev, buffer, size, DMA_TO_DEVICE);

Of both the CPU and the device write to the buffer, you must use
DMA_BIDIRECTIONAL.


Regards,
Clemens
