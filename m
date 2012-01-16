Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755196Ab2APPdx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 10:33:53 -0500
Received: from mx1.redhat.com ([209.132.183.28]:50862 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754637Ab2APPdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 10:33:51 -0500
Message-ID: <4F1442C5.70500@redhat.com>
Date: Mon, 16 Jan 2012 16:31:17 +0100
From: Jerome Marchand <jmarchan@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: David Rientjes <rientjes@google.com>
CC: Andrew Jones <drjones@redhat.com>, Arnd Bergmann <arnd@arndb.de>,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
        david.woodhouse@intel.com, gregkh@suse.de, davem@davemloft.net,
        axboe@kernel.dk, holt@sgi.com, linux-arch@vger.kernel.org,
        linux@arm.linux.org.uk, hskinnemoen@gmail.com, egtvedt@samfundet.no,
        msalter@redhat.com, a-jacquiot@ti.com, starvik@axis.com,
        jesper.nilsson@axis.com, dhowells@redhat.com, takata@linux-m32r.org,
        geert@linux-m68k.org, yasutake.koichi@jp.panasonic.com,
        jonas@southpole.se, kyle@mcmartin.ca, deller@gmx.de,
        jejb@parisc-linux.org, chris@zankel.net, greg@kroah.com,
        davej@redhat.com, airlied@linux.ie, jkosina@suse.cz,
        mchehab@infradead.org, johannes@sipsolutions.net,
        linville@tuxdriver.com
Subject: Re: [PATCH] kconfig: untangle EXPERT and EMBEDDED
References: <1326295008-29795-1-git-send-email-drjones@redhat.com> <alpine.DEB.2.00.1201111353330.21755@chino.kir.corp.google.com> <201201120918.53026.arnd@arndb.de> <20120112101805.GA2375@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201121259270.17287@chino.kir.corp.google.com> <20120113085125.GA2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201130230320.15417@chino.kir.corp.google.com> <20120113122202.GB2452@turtle.usersys.redhat.com> <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
In-Reply-To: <alpine.DEB.2.00.1201131318340.24089@chino.kir.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/13/2012 10:27 PM, David Rientjes wrote:
> CONFIG_EXPERT does work, there haven't been problems reported with it in 
> the year that it has been in the kernel, and CONFIG_EMBEDDED is available 
> to be extended to have its logical semantics.  Right now, CONFIG_EMBEDDED 
> is pretty useless other than setting CONFIG_EXPERT but that could easily 
> be extended if someone wants to spend the time to separate options out 
> from CONFIG_EXPERT that don't make any sense for embedded devices.  I'm 
> not from the embedded world, so I don't know the problems they face when 
> configuring the kernel.

I don't see what your objections to this patch are. It actually does not
change anything to CONFIG_EMBEDDED and 6a108a14fa35 didn't either.
CONFIG_EMBEDDED still exposes the same options and set the same default
values as it did before or after 6a108a14fa35 was applied.

This patch just makes EXPERT exposes config option as advertised by its
description without changing any default value.
For instance, Why would CONFIG_EXPERT disable by default some HID devices?
I could understand why it is done for CONFIG_EMBEDDED, but certainly not
for an general EXPERT option.

> 
>> This patch is actually attempting to make progress in the separation of
>> the semantics for EXPERT and the old, insane EMBEDDED, which had the very
>> loose semantics. That's why it's called "untangle EXPERT and EMBEDDED".
>>

If EMBEDDED was insane before 6a108a14fa35, then it still was after, since
nothing changed. EMBEDDED was just renamed EXPERT, and the "new" EMBEDDED
option just selects EXPERT.

> 
> Breaking backwards compatibility for users who aren't defconfigs is a 
> non-starter, as I've said.  Admitting that your patch does it is almost 
> like nacking your own patch.

If people use CONFIG_EXPERT while expecting it to change some default value
useful for embedded device, while at all time there was a CONFIG_EMBEDDED
available that is according to its description made for this purpose, then
the shame on them...
If CONFIG_EMBEDDED is broken, it has to be fixed. As Andrew already said,
this is out of the scope of this patch.

Jerome

