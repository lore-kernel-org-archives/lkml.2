Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933671Ab2J3MSa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 08:18:30 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:48639 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932930Ab2J3MS2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 08:18:28 -0400
MIME-Version: 1.0
In-Reply-To: <20121029175228.GD11908@atomide.com>
References: <1351530381-11459-1-git-send-email-omar.luna@linaro.org>
	<1351530381-11459-2-git-send-email-omar.luna@linaro.org>
	<20121029175228.GD11908@atomide.com>
Date: Tue, 30 Oct 2012 07:18:26 -0500
Message-ID: <CALLhW=4ukBuRSVcPm2A37PgBhv33yKqk2G=Dz2XTUyswXw=JMg@mail.gmail.com>
Subject: Re: [PATCH 1/2] ARM: OMAP2+: move mailbox.h out of plat-omap headers
From: Omar Ramirez Luna <omar.luna@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        Ohad Ben-Cohen <ohad@wizery.com>, Suman Anna <s-anna@ti.com>,
        Juan Gutierrez <jgutierrez@ti.com>,
        Felipe Contreras <felipe.contreras@nokia.com>,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tony,

On 29 October 2012 12:52, Tony Lindgren <tony@atomide.com> wrote:
>> --- /dev/null
>> +++ b/include/linux/platform_data/omap_mailbox.h
>> @@ -0,0 +1,105 @@
>
> This file should only contain pure platform data needed
> by the core omap code to pass to the mailbox driver.

Ok, looking at it closely, this header file is related to the API
itself, there is nothing that could be actually considered as pure
platform data, the structures are related with the mailbox framework
and even if I split this file into two, the additional header would
end up including the "platform_data" header unless I move
save/restore_ctx functions and then export them as symbols for the
API.

So, it might be better for the entire file to sit in
linux/include/mailbox/ then.

> The mailbox API header should be somewhere else,
> like include/linux/mailbox/mailbox-omap.h or similar.

Ok.

> But shouldn't this all now be handled by using the
> remoteproc framework?

Remoteproc doesn't handle the mailbox hardware directly, it still
relies in the mailbox framework for the low level communications.
E.g.: Proc1 has a message (virtqueue msg) queued to Proc2, uses
mailbox msg to generate an interrupt to Proc2, Proc2 queries the
message (virtqueue) based on the mailbox message received.

Regards,

Omar
