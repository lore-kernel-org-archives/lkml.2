Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566Ab3ACQLY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jan 2013 11:11:24 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:39620 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328Ab3ACQLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jan 2013 11:11:22 -0500
Message-ID: <50E5ADA6.1070904@wwwdotorg.org>
Date: Thu, 03 Jan 2013 09:11:18 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Prashant Gaikwad <pgaikwad@nvidia.com>
CC: "mturquette@linaro.org" <mturquette@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH v2 05/11] ARM: dt: tegra30: Add device node for APB MISC
References: <1356619644-18565-1-git-send-email-pgaikwad@nvidia.com> <1356619644-18565-6-git-send-email-pgaikwad@nvidia.com> <50E4AE19.1060503@wwwdotorg.org> <50E520FC.4070805@nvidia.com>
In-Reply-To: <50E520FC.4070805@nvidia.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2013 11:11 PM, Prashant Gaikwad wrote:
> On Thursday 03 January 2013 03:30 AM, Stephen Warren wrote:
>> On 12/27/2012 07:47 AM, Prashant Gaikwad wrote:
>>> APB misc contains multiple registers required by different modules
>>> such as CAR.
>> I don't see a DT binding document that describes what
>> nvidia,tegra30-apbmisc means. Also, the register range for this new node
>> overlaps that for the pinmux node, so they can't both "request" their
>> register region. You may need multiple entries in the apbmisc reg
>> property to avoid this.
> 
> apbmisc reg for Tegra30 can be divided into following entries:
> 
> strap registers
> jtag configuration registers
> pull_up/pull_down control registers
> vclk control registers
> tvdac registers
> chip id revision registers
> pad control registers
> 
> This list is not same for Tegra20 and Tegra30.

OK. It sounds like we need a true APB MISC driver then, to abstract the
differences; the clock driver really shouldn't be touching the APB MISC
registers in all likelihood, unless a subset of the sections you mention
above are truly dedicated to clock functionality.

> OR
> 
> another way is to add chip id revision register region to CAR node as
> done for pinmux node and remove apb misc node.

The pinmux controller doesn't have a reg entry for the chip ID register.
I don't understand what you mean here.
