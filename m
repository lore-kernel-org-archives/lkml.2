Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab2FMEjT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 00:39:19 -0400
Received: from na3sys009aog121.obsmtp.com ([74.125.149.145]:35512 "EHLO
	na3sys009aog121.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751102Ab2FMEjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 00:39:18 -0400
Message-ID: <4FD8196E.7080009@ti.com>
Date: Wed, 13 Jun 2012 10:09:10 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Mike Turquette <mturquette@ti.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/2] clk: cache parent clocks only for muxes
References: <1338973891-28719-1-git-send-email-rnayak@ti.com> <1338973891-28719-2-git-send-email-rnayak@ti.com> <20120606104759.GN8262@n2100.arm.linux.org.uk> <20120612190449.GH19410@gmail.com>
In-Reply-To: <20120612190449.GH19410@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 13 June 2012 12:34 AM, Mike Turquette wrote:
> On 20120606-11:47, Russell King - ARM Linux wrote:
>> On Wed, Jun 06, 2012 at 02:41:30PM +0530, Rajendra Nayak wrote:
>>> caching parent clocks makes sense only when a clock has more
>>> than one parent (mux clocks).
>>> Avoid doing this for every other clock.
>>>
>>> Signed-off-by: Rajendra Nayak<rnayak@ti.com>
>>> ---
>>>   drivers/clk/clk.c |    2 +-
>>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/clk/clk.c b/drivers/clk/clk.c
>>> index 687b00d..40568e9 100644
>>> --- a/drivers/clk/clk.c
>>> +++ b/drivers/clk/clk.c
>>> @@ -1229,7 +1229,7 @@ int __clk_init(struct device *dev, struct clk *clk)
>>>   	 * If clk->parents is not NULL we skip this entire block.  This allows
>>>   	 * for clock drivers to statically initialize clk->parents.
>>>   	 */
>>> -	if (clk->num_parents&&  !clk->parents) {
>>> +	if ((clk->num_parents>  1)&&  !clk->parents) {
>>
>> You don't need the additional parens here.  Please learn the C precedence
>> rules.  Additional unnecessary parens can make expressions much harder
>> to read.
>
> Rajendra,
>
> I've taken this patch into clk-next for testing.  I've fixed up the
> extra parens locally, so no need for a resend.

Thanks Mike.

>
> Regards,
> Mike

