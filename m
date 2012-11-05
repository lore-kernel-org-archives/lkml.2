Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932868Ab2KERfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 12:35:17 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:42261 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753768Ab2KERfO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 12:35:14 -0500
Message-ID: <5097F8CF.5090100@wwwdotorg.org>
Date: Mon, 05 Nov 2012 10:35:11 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120912 Thunderbird/15.0.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Alex Courbot <acourbot@nvidia.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: How about a gpio_get(device *, char *) function?
References: <38620644.IyR5R8rjKP@percival> <CACRpkdZc3cEGfSKW-b=G31yuw_E-GOXid3jkxZ0tuKYGYRE5Nw@mail.gmail.com>
In-Reply-To: <CACRpkdZc3cEGfSKW-b=G31yuw_E-GOXid3jkxZ0tuKYGYRE5Nw@mail.gmail.com>
X-Enigmail-Version: 1.4.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2012 11:04 AM, Linus Walleij wrote:
> On Wed, Oct 31, 2012 at 10:04 AM, Alex Courbot <acourbot@nvidia.com> wrote:
> 
>> Would anyone be opposed to having a gpio_get() function that works similarly
>> to e.g. regulator_get() and clk_get()?
> 
> I understand the concept and why you want to do this.
> 
> However I think the global GPIO numberspace defeats the
> purpose.
> 
> gpio_get() should get an abstract handle just like clk_get() or
> regulator_get(), not a fixed numeral.

I don't really see why the return type of gpio_get() influences whether
it can be implemented or not.

If gpio_get() were implemented today, it could return an integer with
the same value as any other GPIO functions use already.

With board files, some "gpio map" table would simply contain the same
int GPIO ID value the table as is used anywhere else already. With DT,
the same xlate function would translate from DT GPIO-chip-relative
IDs/specifiers into the global number space in the same way that we do
today via other APIs.

If the GPIO subsystem were reworked as you propose, this API could be
reworked in exactly the same way, or if implemented after the rework, it
would return whatever handle type was in use at the time.
