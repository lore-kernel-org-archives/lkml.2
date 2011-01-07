Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755363Ab1AGBeb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:34:31 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:34671 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754975Ab1AGBe3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:34:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=dVP6a51svOHZi+WYsRYs/lto3EbptzeTh46r60K0FoQM1npyGfWf7KdqkKpORZIhZh
         VdsIeKrpv0HIl86Wy/9uXVRoE1NbmcMsuB4718cGMN0aiWYzvF5MhTRmSXynP21Gc3LF
         1z+o0I8P3HvaffvJ30mgCxDAe5O9YqwEiZeFM=
MIME-Version: 1.0
In-Reply-To: <20101025004541.GD21564@trinity.fluff.org>
References: <1287359019-1476-1-git-send-email-vapier@gentoo.org>
 <20101018103610.77b7e605@endymion.delvare> <544AC56F16B56944AEC3BD4E3D5917713094520EDB@LIMKCMBX1.ad.analog.com>
 <20101018140136.2b44d29e@endymion.delvare> <544AC56F16B56944AEC3BD4E3D5917713094520FA6@LIMKCMBX1.ad.analog.com>
 <20101018163357.659efe25@endymion.delvare> <AANLkTi=fAYqxsGre9kOt9Z8nDXZ9JFjZtKUiMrE3Qn9b@mail.gmail.com>
 <20101025004541.GD21564@trinity.fluff.org>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 6 Jan 2011 20:33:55 -0500
X-Google-Sender-Auth: mdcnGx5ErP4ukhBuHiydLVNikhc
Message-ID: <AANLkTinaAQnz2s_F-ORbUE6CUjxNkrJs6-fbc4JS0=df@mail.gmail.com>
Subject: Re: [Device-drivers-devel] [PATCH] i2c: add irq_flags to board info
To: Ben Dooks <ben-i2c@fluff.org>
Cc: Jean Delvare <khali@linux-fr.org>,
        "Hennerich, Michael" <Michael.Hennerich@analog.com>,
        David Brownell <david-b@pacbell.net>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "device-drivers-devel@blackfin.uclinux.org" 
	<device-drivers-devel@blackfin.uclinux.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 24, 2010 at 20:45, Ben Dooks wrote:
> On Mon, Oct 18, 2010 at 03:51:49PM -0400, Mike Frysinger wrote:
>> On Mon, Oct 18, 2010 at 10:33, Jean Delvare wrote:
>> > Why do we have set_irq_type() if we're not supposed to call it? I am
>> > not claiming to be an expert in the area, but it seems totally
>> > reasonable to me that the same piece of code instantiating an I2C
>> > device is also responsible for setting its IRQ type.
>>
>> but we're back to the same issue mentioned earlier -- you cant have a
>> single kernel build with modules supporting multiple drivers
>> simultaneously.  we like to ship development boards with a single
>> kernel build on it with many modules.  then people can pick the addon
>> boards they wish to prototype with at runtime by plugging in the card
>> and loading the module.
>
> I also dislike set_irq_type() as it doesn't check whether there is anyone
> registered with the interrupt, which means that you could set the irq
> type of someone else's irq.
>
> I wonder if we should pass a struct resource instead, in case there
> are multiple interrupt sources, as well as having it registered with
> the right resource systems.

a resource struct would still only have a single interrupt info in it,
so i'm not sure how that would be better
-mike
