Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757700Ab0IGPzF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 11:55:05 -0400
Received: from mailservice.tudelft.nl ([130.161.131.5]:33950 "EHLO
	mailservice.tudelft.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177Ab0IGPzD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 11:55:03 -0400
X-Spam-Flag: NO
X-Spam-Score: -24.389
Message-ID: <4C866052.5020206@tremplin-utc.net>
Date: Tue, 07 Sep 2010 17:54:58 +0200
From: =?UTF-8?B?w4lyaWMgUGllbA==?= <eric.piel@tremplin-utc.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100809 Mandriva/3.1.2-3mdv2011.0 (2011.0) Thunderbird/3.1.2
MIME-Version: 1.0
To: Takashi Iwai <tiwai@suse.de>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Jean Delvare <khali@linux-fr.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lis3: Add axes module parameter for custom axis-mapping
References: <s5htymla56q.wl%tiwai@suse.de>	<s5haanuvypc.wl%tiwai@suse.de>	<4C864B3E.5060603@tremplin-utc.net> <s5heid58vfv.wl%tiwai@suse.de>
In-Reply-To: <s5heid58vfv.wl%tiwai@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 07-09-10 16:44, Takashi Iwai schreef:
:
>> Wouldn't it be much cleaner if lis3_dev.ac was an array instead of a
>> struct? I don't mind that it involves changing more line if it makes
>> things more understandable.
> 
> OK, then it makes things easier.  The revised patch is below.
Yes, I like it much better...

>  
> +module_param_array_named(axes, lis3_dev.axis_map, int, NULL, 0644);
> +MODULE_PARM_DESC(axes, "Axis-mapping for x,y,z directions");
But now there is no check at all about the value being between 1 and 3,
is there?

I think it's still necessary to have a small function which checks for
correct values, otherwise the user could read a bit anywhere in the memory.

Eric
