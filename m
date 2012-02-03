Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502Ab2BCTLq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 14:11:46 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43907 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066Ab2BCTLp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 14:11:45 -0500
Message-ID: <4F2C3161.5020807@canonical.com>
Date: Fri, 03 Feb 2012 12:11:29 -0700
From: Tim Gardner <rtg.canonical@gmail.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0) Gecko/20120130 Thunderbird/10.0
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Subject: Re: Linux 3.2.3
References: <20120203174758.GA18584@kroah.com> <4F2C2A40.1080601@canonical.com> <20120203185157.GA2865@kroah.com> <20120203185319.GA1710@kroah.com> <20120203185459.GA7321@kroah.com>
In-Reply-To: <20120203185459.GA7321@kroah.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/2012 11:54 AM, Greg KH wrote:
> On Fri, Feb 03, 2012 at 10:53:19AM -0800, Greg KH wrote:
>> On Fri, Feb 03, 2012 at 10:51:57AM -0800, Greg KH wrote:
>>> On Fri, Feb 03, 2012 at 11:41:04AM -0700, Tim Gardner wrote:
>>>> On 02/03/2012 10:47 AM, Greg KH wrote:
>>>>> I'm announcing the release of the 3.2.3 kernel.
>>>>>
>>>>> All users of the 3.2 kernel series must upgrade.
>>>>>
>>>>> The updated 3.2.y git tree can be found at:
>>>>>          git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git linux-3.2.y
>>>>> and can be browsed at the normal kernel.org git web browser:
>>>>>          http://git.kernel.org/?p=linux/kernel/git/stable/linux-stable.git;a=summary
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>>
>>>>
>>>> Build failure in vanilla Linux 3.2.3:
>>>>
>>>>    CC [M]  sound/soc/codecs/wm5100.o
>>>> sound/soc/codecs/wm5100.c: In function ‘wm5100_set_bias_level’:
>>>> sound/soc/codecs/wm5100.c:1382:33: error: ‘struct wm5100_priv’ has
>>>> no member named ‘regmap’
>>>> sound/soc/codecs/wm5100.c:1398:33: error: ‘struct wm5100_priv’ has
>>>> no member named ‘regmap’
>>>> sound/soc/codecs/wm5100.c:1409:29: error: ‘struct wm5100_priv’ has
>>>> no member named ‘regmap’
>>>> make[5]: *** [sound/soc/codecs/wm5100.o] Error 1
>>>>
>>>> Looks like it depends on bd132ec585c498ee27d7eedf8569703606743928
>>>> "ASoC: Convert wm5100 to direct regmap API usage", but I haven't
>>>> re-built with it yet.
>>>>
>>>> See attached config.
>>>
>>> Ugh, I didn't have CONFIG_SND_SOC=m in my test config files, I'll go fix
>>> that now and see what needs to be done here, thanks for letting me know.
>>>
>>> Mark any hints?
>>
>> Yes, the above commit fixes the build for me, thanks, I'll go release
>> 3.2.4 with this build fix in it, thanks Tim for letting me know.
>
> Hm, no, I don't think I'll really trust that patch for a -stable
> release, it looks like:
>   sound/soc/codecs/wm5100-tables.c | 1488 +++++++++++++++++++--------------------
>   sound/soc/codecs/wm5100.c        |   51 +
>   sound/soc/codecs/wm5100.h        |    7
>   3 files changed, 787 insertions(+), 759 deletions(-)
>
> Which is a bit big.
>
> Mark, any objection to me just reverting the SOC patch that causes this build
> failure instead?
>
> thanks,
>
> greg k-h

I think you'll have to revert both WM5100 patches that came in with v3.2.3:

78fd75340768980ce6ca646106762a6928289e0c ASoC: Don't go through cache 
when applying WM5100 rev A updates
11a17e56ac9c607c6eaecf64b618cd17c828ade0 ASoC: Mark WM5100 register map 
cache only when going into BIAS_OFF

Adding the dependent patch bd132ec585c498ee27d7eedf8569703606743928 does 
allow the compile to succeed. But, as you pointed out, its a huge patch 
and doesn't really qualify for stable.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
