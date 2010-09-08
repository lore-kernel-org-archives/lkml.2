Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755606Ab0IHP1X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 11:27:23 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:36267 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0IHP1V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 11:27:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=u3tyXLSdNgeQBCwJ02A9gQte3TM6wzg2Y6HSvNvbed0U/td9LxK20KhqwKe5cYosUi
         tcaaaoH9MbZecJUO8wEieWaMA202wt7ti8BNrQ6qa+GcGuZGPaQ3l5X4r+Awp+3aMith
         tlAuaz6UPCLuxaKQMjAjWbcLJRCJN9IvhYRfg=
MIME-Version: 1.0
In-Reply-To: <20100907.172434.28821101.davem@davemloft.net>
References: <AANLkTinK4VywsJ86jaC8wQjbXjzvP-z44JD3XbZbMM2a@mail.gmail.com>
	<20100907.163331.260082741.davem@davemloft.net>
	<AANLkTin6RcDPFWpG4YBRF4O-8nrsA6e77K=knBA-uyf9@mail.gmail.com>
	<20100907.172434.28821101.davem@davemloft.net>
Date: Wed, 8 Sep 2010 08:27:19 -0700
Message-ID: <AANLkTi=kbonQ11mLpkd4EnSr3ch8yDssnjaUsgw_tVw9@mail.gmail.com>
Subject: Re: Is via-velocity broken in 2.6.34?
From: Matt Causey <matt.causey@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 7, 2010 at 5:24 PM, David Miller <davem@davemloft.net> wrote:
> From: Matt Causey <matt.causey@gmail.com>
> Date: Tue, 7 Sep 2010 17:13:14 -0700
>
>> So before I posted to the list, I actually dug through looking for
>> recent changes which would be trivial for me to back out.  This was
>> the only one I had found, so I tried it.  :-)  No luck though...same
>> result.
>
> Thanks, please continue reading up on how to bisect this down,
> that will help us figure out what the problem is.
>

Apologies, my troubleshooting was faulty.  In my testing when I was
switching between 2.6.29 / 2.6.34 there was a .config change that I
failed to notice.  In my  2.6.29 config I had all the default
config_pm and acpi options enabled, whereas in the later config I had
them all disabled.

So, the minimum acpi stuff needed for the driver to function is
CONFIG_PM and CONFIG_ACPI.  None of the timer stuff or anything else
appears to be necessary.  If that's the case (others can correct me if
not...) could we patch the Kconfig to look like this:

config VIA_VELOCITY
        tristate "VIA Velocity support"
        depends on PCI && PM && ACPI

since today it's only depending on pci.

If this is the right thing to do I can submit a patch .  Apologies
again for the red herring.  :-)

Cheers,

--
Matt
