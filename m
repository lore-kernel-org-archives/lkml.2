Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269Ab1GLLYu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 07:24:50 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:59737 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752348Ab1GLLYt convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 07:24:49 -0400
MIME-Version: 1.0
In-Reply-To: <4E1B93CF.60700@linux.intel.com>
References: <1310325719-2151-1-git-send-email-per.forlin@linaro.org>
	<4E1B93CF.60700@linux.intel.com>
Date: Tue, 12 Jul 2011 13:24:48 +0200
Message-ID: <CAJ0pr1_Tru1d4Crp3_sXxrTN+PTGN+hMkMWrLKgNPVJOvdanmw@mail.gmail.com>
Subject: Re: [PATCH v6] mmc: documentation of mmc non-blocking request usage
 and design.
From: Per Forlin <per.forlin@linaro.org>
To: J Freyensee <james_p_freyensee@linux.intel.com>
Cc: linaro-dev@lists.linaro.org, Nicolas Pitre <nicolas.pitre@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-doc@vger.kernel.org,
        Venkatraman S <svenkatr@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Arnd Bergmann <arnd@arndb.de>, Sourav Poddar <sourav.poddar@ti.com>,
        Chris Ball <cjb@laptop.org>, Randy Dunlap <rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12 July 2011 02:22, J Freyensee <james_p_freyensee@linux.intel.com> wrote:
> On 07/10/2011 12:21 PM, Per Forlin wrote:
>> +MMC host extensions
>> +===================
>> +
>> +There are two optional members in the
>> +mmc_host_ops -- pre_req() and post_req() -- that the host
>> +driver may implement in order to move work to before and after the actual
>> +mmc_host_ops.request() function is called. In the DMA case pre_req() may
>> do
>> +dma_map_sg() and prepare the DMA descriptor, and post_req() runs
>> +the dma_unmap_sg().
>> +
>
> One question: Is the 'Optimize for the first request' below an example of
> how to use the 'MMC host extensions' above?
Yes.

>  So just using 'mmc_start_req()'
> in an MMC client driver would not be beneficial if the MMC host was not also
> using the MMC host extensions, right?
>
Yes. There may be some exceptions where there is gain without any host
driver change. For instance when using dma_bounce, the bounce_copy
would be done in parallel with an active transfer.
Future work on eMMC HPI support (Venkatraman is working on this) can
use the new extensions to interrupt ongoing write to make way for
higher prio read.

> Thanks,
> Jay

You're welcome,
Per
