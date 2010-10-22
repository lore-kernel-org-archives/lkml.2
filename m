Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756274Ab0JVMkh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 08:40:37 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:48837 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753690Ab0JVMkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 08:40:36 -0400
Message-ID: <4CC18605.80007@ti.com>
Date: Fri, 22 Oct 2010 08:39:33 -0400
From: Cyril Chemparathy <cyril@ti.com>
Reply-To: cyril@ti.com
Organization: Texas Instruments
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.14) Gecko/20101006 Lightning/1.0b1 Thunderbird/3.0.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "lrg@slimlogic.co.uk" <lrg@slimlogic.co.uk>,
        "dbrownell@users.sourceforge.net" <dbrownell@users.sourceforge.net>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rpurdie@rpsys.net" <rpurdie@rpsys.net>
Subject: Re: [PATCH v3 01/12] misc: add driver for sequencer serial port
References: <1287694873-12904-1-git-send-email-cyril@ti.com>	<1287694873-12904-2-git-send-email-cyril@ti.com> <20101021161224.b4c0b623.akpm@linux-foundation.org>
In-Reply-To: <20101021161224.b4c0b623.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/21/2010 07:12 PM, Andrew Morton wrote:
>
> ...
>
>> +/* Register Access Helpers */
>> +static inline u32 ssp_read(struct ti_ssp *ssp, int reg)
>> +{
>> +	return __raw_readl(ssp->regs + reg);
>> +}
>> +
>> +static inline void ssp_write(struct ti_ssp *ssp, int reg, u32 val)
>> +{
>> +	__raw_writel(val, ssp->regs + reg);
>> +}
> 
> Why are the __raw functions used here?
> 

These registers are to be accessed native endian at all times, and
therefore the le32 conversion done otherwise is inappropriate.

Thanks for the feedback.  I will post an updated series with these changes.

Regards
Cyril.
