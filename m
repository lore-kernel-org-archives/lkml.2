Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754481Ab2KVSiQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:38:16 -0500
Received: from mail-vb0-f51.google.com ([209.85.212.51]:49953 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754426Ab2KVSiL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:38:11 -0500
X-Greylist: delayed 87727 seconds by postgrey-1.27 at vger.kernel.org; Thu, 22 Nov 2012 13:38:11 EST
MIME-Version: 1.0
In-Reply-To: <4275468.QAmZy3xUK6@percival>
References: <1353149747-31871-1-git-send-email-acourbot@nvidia.com>
 <1699753.ZQsWMHINxd@percival> <50AC956D.7020303@ti.com> <4275468.QAmZy3xUK6@percival>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 22 Nov 2012 13:01:47 +0000
X-Google-Sender-Auth: ec9gDmsOWOyl02cDBCDyBcE7Kdc
Message-ID: <CACxGe6tLq7LAb_YwvJVnccJEJNEwKt6heEZER3L7tP1g1WnbXg@mail.gmail.com>
Subject: Re: [PATCHv9 1/3] Runtime Interpreted Power Sequences
To: Alex Courbot <acourbot@nvidia.com>
Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Stephen Warren <swarren@nvidia.com>, Arnd Bergmann <arnd@arndb.de>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        Thierry Reding <thierry.reding@avionic-design.de>,
        Mark Zhang <markz@nvidia.com>, Rob Herring <rob.herring@calxeda.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        David Woodhouse <dwmw2@infradead.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 10:00 AM, Alex Courbot <acourbot@nvidia.com> wrote:
> On Wednesday 21 November 2012 16:48:45 Tomi Valkeinen wrote:
>> If the power-off sequence disables a regulator that was supposed to be
>> enabled by the power-on sequence (but wasn't enabled because of an
>> error), the regulator_disable is still called when the driver runs the
>> power-off sequence, isn't it? Regulator enables and disables are ref
>> counted, and the enables should match the disables.
>
> And there collapses my theory.
>
>> > Failures might be better handled if sequences have some "recovery policy"
>> > about what to do when they fail, as mentioned in the link above. As you
>> > pointed out, the driver might not always know enough about the resources
>> > involved to do the right thing.
>>
>> Yes, I think such recovery policy would be needed.
>
> Indeed, from your last paragraph this makes even more sense now.
>
> Oh, and I noticed I forgot to reply to this:
>
>> This I didn't understand. Doesn't "<&pwm 2 xyz>" point to a single
>> device, no matter where and how many times it's used?
>
> That's true - however when dereferencing the phandle, the underlying framework
> will try to acquire the PWM, which will result in failure if the same resource
> is referenced several times.
>
> One could compare the phandles to avoid this, but in your example you must
> know that for PWMs the "xyz" part is not relevant for comparison.
>
> This makes referencing of resources by name much easier to implement and more
> elegant with respect to frameworks leveraging.

I would rather (at least for how the DT bindings settle out) see the
design separate the resource references from the sequence. ie. Declare
which resources are used by a device's sequences all in one place and
have the commands index into that.

g.
