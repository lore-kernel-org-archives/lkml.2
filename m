Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754744Ab1GDHpP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 03:45:15 -0400
Received: from 50.23.254.54-static.reverse.softlayer.com ([50.23.254.54]:55349
	"EHLO softlayer.compulab.co.il" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753736Ab1GDHpM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 03:45:12 -0400
Message-ID: <4E116F7F.5010508@compulab.co.il>
Date: Mon, 04 Jul 2011 10:45:03 +0300
From: Igor Grinberg <grinberg@compulab.co.il>
Organization: CompuLab Ltd.
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en; rv:1.9.2.13) Gecko/20101211 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Christian Gmeiner <christian.gmeiner@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: Re: pca953x: support working w/o platform data
References: <BANLkTimSkDEzPvRMmX1O0YjjpoPzQt6_+w@mail.gmail.com> <4E0E0138.8060400@compulab.co.il> <20110704064347.GL15152@ponder.secretlab.ca>
In-Reply-To: <20110704064347.GL15152@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - softlayer.compulab.co.il
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - compulab.co.il
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/11 09:43, Grant Likely wrote:

> On Fri, Jul 01, 2011 at 08:17:44PM +0300, Igor Grinberg wrote:
>> On 07/01/11 14:33, Christian Gmeiner wrote:
>>
>>> Provide defaults for pca953x, so the driver can be used w/o
>>> providing platform data.
>> Wouldn't it be better to provide a default pdata structure inside the driver
>> and use it in case no pdata supplied, so you will not have to patch the
>> driver all around checking each time if pdata is valid?
>
> I would agree.  However, you will need to adjust the structure of the
> driver somewhat to do so.  Once a device is registered, the data
> pointed to by platform_device->dev.platform_data must be treated as
> immutable by the driver, otherwise driver unbind/rebind can become
> horribly broken.

The driver already copies several field from pdata to the chip structure.
Also, chip->dyn_pdata can be used for this purpose, but instead of
allocating it dynamically, it just can be  a part of the chip structure.

> I often solve this by keeping a full copy of the pdata structure in
> the driver's private data structure, and always referencing the 'safe'
> local copy instead of dereferencing dev->platform_data every time.

If this is done and the chip structure will contain all the information
needed (either flat, or in some kind of dyn_pdata), then indeed there
will be no need to access the pdata anymore.
Also, there will be no need to allocate pdata in pca953x_get_alt_pdata()
function.
I think this would be the most clean and safe way.

-- 
Regards,
Igor.

