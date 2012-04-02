Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab2DBUrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 16:47:00 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38063 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751333Ab2DBUq6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 16:46:58 -0400
Message-ID: <4F7A103E.90007@lwfinger.net>
Date: Mon, 02 Apr 2012 15:46:54 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: CONFIG_RTLWIFI_DEBUG default y
References: <20120402164920.GA13264@x1.osrc.amd.com> <1333385618.15422.17.camel@joe2Laptop> <20120402171733.GB13264@x1.osrc.amd.com> <4F79E5A5.9000004@lwfinger.net> <20120402203211.GA27889@liondog.tnic>
In-Reply-To: <20120402203211.GA27889@liondog.tnic>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 03:32 PM, Borislav Petkov wrote:
> On Mon, Apr 02, 2012 at 12:45:09PM -0500, Larry Finger wrote:
>> The current situation is fine with me. Any user with an embedded
>> system can save a lot of memory by setting CONFIG_RTLWIFI_DEBUG to
>> n. If a normal distro chooses to do that, then when some user of
>> that distro reports a problem and is unable to run with the module
>> parameter "debug=X", I get to say "Sorry, I cannot help you." :)
>>
>> Of course, if you want to go through the source and convert every
>> instance of "RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ...)" to the
>> equivalent "pr_err(...), then I would probably sign off on it.
>
> I see. Well, I suppose when the driver matures, you're probably going
> to remove most of the debugging code yourself because you won't need it
> anymore and turn important printk statements into pr_err or pr_info or
> whatever.
>
> However, the way it is default y now, people who do 'yes "" | make
> oldconfig' will be surprised to see a whole lot of debugging output
> spewed from the wireless driver upon next reboot, and I don't think you
> want that.
>
> I dunno, maybe CONFIG_DYNAMIC_DEBUG could be of help. There's also a
> howto:<Documentation/dynamic-debug-howto.txt>

Users will see nothing more than before!

Before CONFIG_RTLWIFI_DEBUG was allowed to be set, the driver always compiled in 
the debug code, but only those messages with the DBG_EMERG code were actually 
output. With the parameter set to Y, nothing changed. If the module is loaded 
with the "debug=X" option, where X is greater than 0, then other messages will 
be seen. That dynamic setting of the level is enough.

The only change when the configuration parameter is set to N is that the entire 
debug setup compiles away. The driver is a lot smaller, but there is no debugging.

Larry
