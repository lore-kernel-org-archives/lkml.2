Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab0JHJck (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 05:32:40 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:44391 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754731Ab0JHJci convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 05:32:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=aA7Mg2pAHlSAtbUoeWrrQ0glZna6TNAIMeB0cKRWeVP5hAuPCGESPuqep0uOkop56P
         hqNi6lOnnW4vmgYK5O95D14EOJLNOSdl1e0r8jmFCIQxsuJFVwFXLvpPPN9XA08LLOQ+
         VHQVwItXjcQUpN7jFcHGQGk/QYPNYx5/aBXHQ=
MIME-Version: 1.0
In-Reply-To: <20101007192245.GC26435@n2100.arm.linux.org.uk>
References: <1286444662-16843-1-git-send-email-felipe.contreras@gmail.com>
	<20101007192245.GC26435@n2100.arm.linux.org.uk>
Date: Fri, 8 Oct 2010 12:32:35 +0300
Message-ID: <AANLkTikQKY7pOobD+==uT5Cy0poT=O5wDMKtbVyJVNbO@mail.gmail.com>
Subject: Re: [PATCH] ARM: allow, but warn, when issuing ioremap() on RAM
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Greg KH <greg@kroah.com>
Cc: linux-main <linux-kernel@vger.kernel.org>,
        linux-arm <linux-arm-kernel@lists.infradead.org>,
        Arnd Hannemann <arnd@arndnet.de>,
        Han Jonghun <jonghun79.han@gmail.com>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Hemant Pedanekar <hemantp@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 7, 2010 at 10:22 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Thu, Oct 07, 2010 at 12:44:22PM +0300, Felipe Contreras wrote:
>> Many drivers are broken, and there's no alternative in sight. Such a big
>> change should stay as a warning for now, and only later should it
>> actually fail.
>>
>> The drivers are not doing something correct, we get it, but for now it's
>> better to allow them to work (they do 99% of the time anyway) rather
>> than to force everyone to revert this patch in their internal trees
>> until there's a solution. A slightly broken functionality is better than
>> no functionality at all.
>>
>> A warning lets people know that what they are doing is not right, and
>> they should fix it.
>
> So what are _you_ going to do to fix these drivers?  Continue reverting
> this patch?  Or are you just going to ignore the issue entirely?

_I_ don't maintain any of these drivers.

I think when _you_ remove functionality from the architecture, you
should provide a mechanism that drivers can migrate to. Since there's
nothing like that, not even a guideline, you are breaking the drivers
willingly, and expecting other people to fix a difficult problem that
you yourself have no idea how to fix properly. At least for 2.6.36,
and probably 2.6.37, I think it's clear what people will do; revert
that patch in their trees, and think twice before switching to a newer
version.

> Unless people can come up with a plan to fix their drivers using ioremap
> on system RAM thereby violating the architecture specification, I'm
> _not_ going to apply this patch.

And then people wonder why companies don't try to work in upstream as
often as they should. If you, the ARM maintainer doesn't care about
breaking drivers with no warning whatsoever, I wonder why would driver
writers would feel compelled to fix the ARM architecture ASAP (if they
are even capable of doing that), specially if they already missed the
deadline, which had a grace period of between .36-rc1 and .36.

Other projects remove functionality only when there's an alternative
in place, and provide a grace period for the migration. I thought that
was sensible.

-- 
Felipe Contreras
