Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756680Ab2BMViI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 16:38:08 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36582 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752648Ab2BMViH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 16:38:07 -0500
MIME-Version: 1.0
In-Reply-To: <20120213090440.GA11414@seagal.ffwll.local>
References: <1328825697-23685-1-git-send-email-miletus@chromium.org>
	<1328896201-20909-1-git-send-email-miletus@chromium.org>
	<20120213090440.GA11414@seagal.ffwll.local>
Date: Mon, 13 Feb 2012 16:38:05 -0500
Message-ID: <CAPDwgkM5=J994Cp3ftkXLshfuPsZOp7q933MnPpeEmUqSjUdPQ@mail.gmail.com>
Subject: Re: [PATCH] [PATCH] drm/i915: Fix race condition in accessing GMBUS
From: Yufeng Shen <miletus@google.com>
To: Yufeng Shen <miletus@chromium.org>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org,
        Eugeni Dodonov <eugeni.dodonov@intel.com>,
        Ben Widawsky <ben@bwidawsk.net>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ben,

So I2C core  does protect multiple access to one adapter, but I2C core
does not protect the case where multiple adapters share the same underlying
device. GMBUS has 7 different pin pairs and each pair is registered as an I2C
adapter. I2C core can serialize the access to one pin pair, say that
the LVDS port
, or the DDC port. But when there are I2C transactions on both LVDS
and DDC ports,
since they share the same GMBUS registers, there will be race condition.
Does this make sense to you ?

--- Yufeng Shen

On Mon, Feb 13, 2012 at 4:04 AM, Ben Widawsky <ben@bwidawsk.net> wrote:
> On Fri, Feb 10, 2012 at 12:50:01PM -0500, Yufeng Shen wrote:
>> GMBUS has several ports and each has it's own corresponding
>> I2C adpater. When multiple I2C adapters call gmbus_xfer() at
>> the same time there is a race condition in using the underlying
>> GMBUS controller. Fixing this by adding a mutex lock when calling
>> gmbus_xfer().
>>
>> Signed-off-by: Yufeng Shen <miletus@chromium.org>
>
> I do not see the race. All the i2c transfers should be protected
> correctly by the i2c core, or else I think we haven't registered our
> device properly. Could you give an example of when/how this can happen?
>
> Ben
