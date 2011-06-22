Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757593Ab1FVLmC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 07:42:02 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59260 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757320Ab1FVLl7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 07:41:59 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.119.47]
In-Reply-To: <201106211620.02065.arnd@arndb.de>
References: <1308640714-17961-1-git-send-email-ohad@wizery.com> <201106211620.02065.arnd@arndb.de>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 22 Jun 2011 14:41:38 +0300
Message-ID: <BANLkTim1kN2f41Cfz70=g4a_+gPPrWDacA@mail.gmail.com>
Subject: Re: [RFC 0/8] Introducing a generic AMP/IPC framework
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, akpm@linux-foundation.org,
        Brian Swetland <swetland@google.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        davinci-linux-open-source 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Tue, Jun 21, 2011 at 5:20 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> This looks really nice overall, but I don't currently have time for a
> more in-depth review. My feeling is that you are definitely on the right
> track here, and the plans you list as TODO to continue are all good.

Thanks !

> One point I noticed is the use of debugfs, which you should probably
> replace at some point with a stable API, e.g. your own debugfs-like
> file system, but there is no hurry to do that now.

debugfs is only being used to expose debugging info (namely the power
state of the remote processor and its trace log messages), which is
mostly useful for developers trying to understand what went wrong.

It seems like debugfs fits quite nicely here (e.g. it's perfectly fine
if this is completely compiled out on production systems), but sure,
we can always revisit this later too.

> Regarding the firmware, I think it would be nice to have the option
> to stick the firmware blob into the flattened device tree as a bininclude,
> so you can build systems using the external processors without special
> user space support.

That's interesting. we'll definitely explore this - thanks !

I was also hoping that DT will simplify remote resource allocations as
well (just like any other device, remote processors usually needs some
hw resources) and planned to try it out soon to see how it all works
out together. It might completely eliminate the preliminary "resource
section" thingy we have in the firmware structure currently.

> The binary format looks reasonable, but if you need anything more complex,
> you should probably go straight for ELF files ;-)

Hopefully we won't need to :)

> +struct fw_section {
> +       u32 type;
> +       u64 da;
> +       u32 len;
> +       char content[0];
> +} __packed;
>
> Unfortunately require __packed. It would be better to sort the members
> differently so that each member is naturally aligned in order to
> avoid the need for padding or __packed attributes

Definitely. __packed is being used just to be on the safe side; we
didn't intend to introduce unnatural alignment intentionally. will be
fixed.

Thanks!
Ohad.
