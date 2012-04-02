Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab2DBRpQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 13:45:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:55729 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752776Ab2DBRpO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 13:45:14 -0400
Message-ID: <4F79E5A5.9000004@lwfinger.net>
Date: Mon, 02 Apr 2012 12:45:09 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Joe Perches <joe@perches.com>
Subject: Re: CONFIG_RTLWIFI_DEBUG default y
References: <20120402164920.GA13264@x1.osrc.amd.com> <1333385618.15422.17.camel@joe2Laptop> <20120402171733.GB13264@x1.osrc.amd.com>
In-Reply-To: <20120402171733.GB13264@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2012 12:17 PM, Borislav Petkov wrote:
> On Mon, Apr 02, 2012 at 09:53:38AM -0700, Joe Perches wrote:
>> To keep all the "printk(KERN_DEBUG" to "pr_debug(" conversion
>> output the same as the it was prior to the patch.
>>
>> Larry can default it to off if he wants.
>
>> From looking at one user of this -
> drivers/net/wireless/rtlwifi/rtl8192ce/hw.c - some of the messages look
> like important ones which you wanna have enabled always, f.e. error
> handling in rtl92ce_hw_init().
>
> It probably needs splitting into debugging messages which are default n
> and always-on messages.

The current situation is fine with me. Any user with an embedded system can save 
a lot of memory by setting CONFIG_RTLWIFI_DEBUG to n. If a normal distro chooses 
to do that, then when some user of that distro reports a problem and is unable 
to run with the module parameter "debug=X", I get to say "Sorry, I cannot help 
you." :)

Of course, if you want to go through the source and convert every instance of 
"RT_TRACE(rtlpriv, COMP_ERR, DBG_EMERG, ...)" to the equivalent "pr_err(...), 
then I would probably sign off on it.

Larry
