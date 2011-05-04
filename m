Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755815Ab1EDUaL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 16:30:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45307 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755228Ab1EDUaG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 16:30:06 -0400
MIME-Version: 1.0
In-Reply-To: <20110504194730.GA2820@local>
References: <1304319115-32745-1-git-send-email-monstr@monstr.eu>
 <20110503203412.GA2119@pengutronix.de> <20110503221440.GB2737@local>
 <4DC152F3.2050500@monstr.eu> <20110504194730.GA2820@local>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 4 May 2011 14:29:46 -0600
X-Google-Sender-Auth: 8i6lullY2x1nH5eVye-B0dIhXjg
Message-ID: <BANLkTing9GPbsur2vpRtpnDcxLUkrDFZmQ@mail.gmail.com>
Subject: Re: [PATCH v4] uio/pdrv_genirq: Add OF support
To: "Hans J. Koch" <hjk@hansjkoch.de>
Cc: Michal Simek <monstr@monstr.eu>, Wolfram Sang <w.sang@pengutronix.de>,
        devicetree-discuss@lists.ozlabs.org, john.williams@petalogix.com,
        linux-kernel@vger.kernel.org, arnd@arndb.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 4, 2011 at 1:47 PM, Hans J. Koch <hjk@hansjkoch.de> wrote:
> On Wed, May 04, 2011 at 03:21:55PM +0200, Michal Simek wrote:
>> Hans J. Koch wrote:
>> >On Tue, May 03, 2011 at 10:34:12PM +0200, Wolfram Sang wrote:
>> >>On Mon, May 02, 2011 at 08:51:55AM +0200, Michal Simek wrote:
>> >>>Adding OF binding to genirq.
>> >>>Version string is setup to the "devicetree".
>> >>>
>> >>>Compatible string is not setup for now but you can add your
>> >>>custom compatible string to uio_of_genirq_match structure.
>> >>>
>> >>>For example with "vendor,device" compatible string:
>> >>>static const struct of_device_id __devinitconst uio_of_genirq_match[] = {
>> >>>   { .compatible = "vendor,device", },
>> >>>   { /* empty for now */ },
>> >>>};
>> >>>
>> >>>Signed-off-by: Michal Simek <monstr@monstr.eu>
>> >>[...]
>> >>
>> >>>+          /* alloc uioinfo for one device */
>> >>>+          uioinfo = kzalloc(sizeof(*uioinfo), GFP_KERNEL);
>> >>kfree in remove?
>> >
>> >Oh yes. Missed that one. It should probably look like the "bad0" case in probe().
>>
>> Yes, freeing uioinfo in uio_pdrv_genirq_remove make sense for CONFIG_OF.
>>
>> Please correct me if I am wrong dev.of_node is not NULL for OF. I
>> think yes that's why I would prefer to use this construct instead of
>> #ifdef CONFIG_OF.
>>
>>       if (pdev->dev.of_node)
>>               kfree(pdev->dev.platform_data);
>
> Huh? You didn't allocate platform_data, so you shouldn't free it.
> It's uioinfo you allocated.

*never* set or modify the pdev->dev.platform_data pointer from a
device driver.  If the data needs to be modified, or a new structure
allocated, then rework the driver to store it in it's private data
structure.  platform_data must be considered immutable by drivers.
Otherwise you'll break unbindng and rebinding device drivers.

g.
