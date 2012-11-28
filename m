Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753312Ab2K1Iim (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 03:38:42 -0500
Received: from www.linutronix.de ([62.245.132.108]:39119 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab2K1Iil (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 03:38:41 -0500
Message-ID: <50B5CD8C.9060902@linutronix.de>
Date: Wed, 28 Nov 2012 09:38:36 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.10) Gecko/20121027 Icedove/10.0.10
MIME-Version: 1.0
To: Andrzej Pietrasiewicz <andrzej.p@samsung.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Felipe Balbi'" <balbi@ti.com>,
        "'Greg Kroah-Hartman'" <gregkh@linuxfoundation.org>,
        "'Joel Becker'" <jlbec@evilplan.org>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        "'Michal Nazarewicz'" <mina86@mina86.com>
Subject: Re: [RFC][PATCH] fs: configfs: programmatically create config groups
References: <1353918910-12381-1-git-send-email-andrzej.p@samsung.com> <50B39921.6090308@linutronix.de> <008101cdcc7d$2d499df0$87dcd9d0$%p@samsung.com> <50B4E364.8030704@linutronix.de> <002901cdcd3f$e7288ac0$b579a040$%p@samsung.com>
In-Reply-To: <002901cdcd3f$e7288ac0$b579a040$%p@samsung.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 8bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 09:10 AM, Andrzej Pietrasiewicz wrote:
>> Here I understand it. This is to some point a limitation of the gadget
>> framework. We do know the number of interface that will be available
>> before we bind. We simply don't know the endpoint number. There are two
>> exceptions to what I just wrote:
>> - g_zero drops the ISO endpoints if the UDC has no UDC support for it.
>>     This should not happen on-the-fly.
>> - UAC2 may want to make the number interfaces (and therefore configure
>>     able) and function (play / record) configurable.
>>
>
> So do we know everything before bind or we don't?

After some sleep I think we do.

>> That was wrong. Pushing it into configs is better but I am not sure we
>> need it. I understand the need for things that pop later like interfaceXX
>> but couldn't the user manually create them if he needs them?
>>
>
> What name shall the user use? How to know which user-created directory
> should correspond to which actual interface? If there are, say,
> 3 interfaces, what would:
>
> $ mkdir interface873246
>
> mean?
>
> And in general, what would
>
> $ mkdir rykcq1234
>
> mean?
>
> Let's go one directory deeper in the hierarchy and suppose there is
> no programmatic directories creation. So we
>
> $ cd interface<something>
>
> so that we can create the endpoint directories.
> And now what? What names shall the user use for the endpoint
> directories? Oh, that's simple: just see what the endpoint
> directories' names are. But wait, aren't we just creating them?
>
> Please also see Micha³'s point about user interface.

Yeah I did. Now I'm okay with creating new directories but we should
keep this to a minimum and encode as much information possible in
directory's name.

>
> Andrzej

Sebastian
