Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751670Ab2IHHaZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 03:30:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:50295 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751323Ab2IHHaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 03:30:19 -0400
Message-ID: <504AF27C.9090601@gmail.com>
Date: Sat, 08 Sep 2012 09:23:40 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Anton Vorontsov <anton.vorontsov@linaro.org>
CC: Bryan Freed <bfreed@chromium.org>, John Stultz <john.stultz@linaro.org>,
        linux-kernel@vger.kernel.org, keescook@chromium.org,
        sboyd@codeaurora.org, gregkh@linuxfoundation.org,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH v6] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
References: <1347042576-17675-1-git-send-email-bfreed@chromium.org> <20120908052907.GA4724@lizard>
In-Reply-To: <20120908052907.GA4724@lizard>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 08/09/2012 07:29, Anton Vorontsov ha scritto:
> On Fri, Sep 07, 2012 at 11:29:36AM -0700, Bryan Freed wrote:
>> When called with a non-zero of_node, fill out a new ramoops_platform_data
>> with data from the specified Flattened Device Tree node.
>> Update ramoops documentation with the new FDT interface.
>> Update devicetree/binding documentation with pstore/ramoops.txt.
>
> Thanks for your work, Bryan! There were a few issues, I fixed
> them myself but I need your confirmation if you're OK w/ all
> the changes.
>
> First of, the Signed-off-by tag is missing, but I see it in v5.
> I also see that v5 had an Ack from Kees Cook, you did not preserve it,
> but generally it's a good idea to do so (if vX -> v(X+1) changes
> aren't drastic).
>
> [...]
>> +Optional properties:
>> +- record-size: Specifies the size of each record in preserved memory.
>> +- console-size: Specifies the size of the console log.
>> +- ftrace-size: Specifies the size of the ftrace log.
>> +- ecc-size: Specifies the size of each record's ECC buffer.
>> +- dump-oops: Specifies to dump oops in addition to panics.
>
> Personally, I don't see how this fits into device tree. It doesn't
> describe hardware, instead it's more a configuration stuff, which
> usually we try to not put into the device tree.
>
> It would be better to have a sane defaults in ramoops, instead of
> introducing more "virtual" stuff in the device tree. That is, feel
> free to change defaults if they seem to be not enough for most your
> setups.
>
> The only property that I see which is truly hardware-specific is
> ecc-size. E.g. if we're pretty sure that a specific hw does not
> need ecc, it's OK to avoid it. And some hw setups might require
> bigger ECC sizes, so it's OK to have it in the device-tree.
>
>> static struct ramoops_platform_data * __init
>> of_ramoops_platform_data(struct device *dev)
>
> You call this function from __devinit section, so using __init
> is an error.
>
> WARNING: fs/pstore/ramoops.o(.devinit.text+0x37): Section mismatch in reference from the function ramoops_probe() to the function .init.text:of_ramoops_platform_data()
> The function __devinit ramoops_probe() references
>
> I changed this to __devnit.
>
> [...]
>> +	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
>> +	if (pdata == NULL)
>
> I wonder why people prefer to not write !pdata, which is more
> natural when reading the code.. :-)
>

I think it's the same for sizeof, it's much more readable
sizeof(struct ramoops_platform_data).

Marco
