Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751861Ab2KLBpG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 20:45:06 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:64108 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751363Ab2KLBpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 20:45:04 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6893"; a="5906757"
Message-ID: <554191d69bc21a4b133fb876df84ff89.squirrel@www.codeaurora.org>
In-Reply-To: <CACxGe6s3gJ4fmhn9VBd1Fq8bH5S0_ejmE=KqVjYn20bT42wQ_Q@mail.gmail.com>
References: <1352508532-19241-1-git-send-email-stepanm@codeaurora.org>
    <509F0E56.6080806@gmail.com>
    <CACxGe6s3gJ4fmhn9VBd1Fq8bH5S0_ejmE=KqVjYn20bT42wQ_Q@mail.gmail.com>
Date: Sun, 11 Nov 2012 17:45:03 -0800 (PST)
Subject: Re: [RFC] dt/platform: Use cell-index for device naming if 
     available
From: "Stepan Moskovchenko" <stepanm@codeaurora.org>
To: "Grant Likely" <grant.likely@secretlab.ca>
Cc: "Rob Herring" <robherring2@gmail.com>,
        "Stepan Moskovchenko" <stepanm@codeaurora.org>,
        devicetree-discuss@lists.ozlabs.org,
        "David Brown" <davidb@codeaurora.org>,
        "Daniel Walker" <dwalker@fifo99.com>,
        "Bryan Huntsman" <bryanh@codeaurora.org>,
        "Russell King" <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.17
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> On Sun, Nov 11, 2012 at 2:32 AM, Rob Herring <robherring2@gmail.com>
> wrote:
>> On 11/09/2012 06:48 PM, Stepan Moskovchenko wrote:
>>> Use the cell-index property to construct names for platform
>>> devices, falling back on the existing scheme of using the
>>> device register address if cell-index is not specified.
>>>
>>> The cell-index property is a more useful device identifier,
>>> especially in systems containing several numbered instances
>>> of a particular hardware block, since it more easily
>>> illustrates how devices relate to each other.
>>>
>>> Additionally, userspace software may rely on the classic
>>> <name>.<id> naming scheme to access device attributes in
>>> sysfs, without having to know the physical addresses of
>>> that device on every platform the userspace software may
>>> support. Using cell-index for device naming allows the
>>> device addresses to be hidden from userspace and to be
>>> exposed by logical device number without having to rely on
>>> auxdata to perform name overrides. This allows userspace to
>>> make assumptions about which sysfs nodes map to which
>>> logical instance of a specific hardware block.
>>>
>>> Signed-off-by: Stepan Moskovchenko <stepanm@codeaurora.org>
>>> ---
>>> I had also considered using something like the linux,label property to
>>> allow
>>> custom names for platform devices without resorting to auxdata, but the
>>> cell-index approach seems more in line with what cell-index was
>>> intended for
>>> and with what the pre-DT platform device naming scheme used to be.
>>> Please let
>>> me know if you think there is a better way to accomplish this.
>>>
>>> This is just being sent out as an RFC for now. If there are no
>>> objections, I
>>> will send this out as an official patch, along with (or combined with)
>>> a patch
>>> to fix up the device names in things like clock tables of any affected
>>> platforms.
>>
>> cell-index is basically deprecated. This has been discussed multiple
>> times in the past. You can use auxdata if you really need to have the
>> old name.
>
> Actually, I think it would be fine to use an /aliases entry to set the
> device name. That's the place to put global namespace information.
>
> g.
>

Ah, thank you. I would prefer to stay away from auxdata, since it involves
placing more platform-specific data into the kernel, and it is my
understanding that auxdata is intended as a temporary measure. The
/aliases approach looks interesting, and I'll see what I can do with it -
hopefully I can have an RFC / patch soon. It looks like we would want an
"inverse" alias lookup- that is, we would need to know which alias
corresponds to a given node. Is it possible for a node to have multiple
aliases? If so, which shall we use to create the device name? Anyway, I
will further look into how these aliases work.

Steve

