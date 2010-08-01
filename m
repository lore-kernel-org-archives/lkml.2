Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551Ab0HAMvV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 08:51:21 -0400
Received: from www17.your-server.de ([213.133.104.17]:44346 "EHLO
	www17.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab0HAMvT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 08:51:19 -0400
References: <201008011101.01429.thomas@m3y3r.de> <4C555DA0.6020109@s5r6.in-berlin.de>
In-Reply-To: <4C555DA0.6020109@s5r6.in-berlin.de>
Mime-Version: 1.0 (iPod Mail 8A293)
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
	charset=us-ascii
Message-Id: <98E20220-BFC9-4231-AEF5-EB59588E6D2F@m3y3r.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zou Nan hai <nanhai.zou@intel.com>,
        Xiang Hai hao <haihao.xiang@intel.com>, Eric Anholt <eric@anholt.net>,
        David Airlie <airlied@linux.ie>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>
X-Mailer: iPod Mail (8A293)
From: Thomas Meyer <thomas@m3y3r.de>
Subject: Re: 2.6.35-rc6+: i915: Bisected regression
Date: Sun, 1 Aug 2010 12:51:36 +0200
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
X-Authenticated-Sender: thomas@m3y3r.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 01.08.2010 um 13:42 schrieb Stefan Richter <stefanr@s5r6.in-berlin.de>:

> Thomas Meyer wrote:
>> This commit makes suspend to ram unreliable for me:
>> 
>> commit d1b851fc0d105caa6b6e3e7c92d2987dfb52cbe0
>> Author: Zou Nan hai <nanhai.zou@intel.com>
>> Date:   Fri May 21 09:08:57 2010 +0800
>> 
>>    drm/i915: implement BSD ring buffer V2
>> 
>>    The BSD (bit stream decoder) ring is used for accessing the BSD engine
>>    which decodes video bitstream for H.264 and VC1 on G45+.  It is
>>    asynchronous with the render ring and has access to separate parts of
>>    the GPU from it, though the render cache is coherent between the two.
>> 
>>    Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
>>    Signed-off-by: Xiang Hai hao <haihao.xiang@intel.com>
>>    Signed-off-by: Eric Anholt <eric@anholt.net>
>> 
>> git revert didn't work on 2.6.35-rc6 so I just changed the HAS_BSD thing to:
>> 
>> #define HAS_BSD(dev)            (0)
>> 
>> with this change applied suspend to ram is back to the reliability of 2.6.34.y
>> 
>> with kind regards
>> thomas
> 
> Added CCs.
> 
> Thomas, on what hardware did you observe the regression?

Is a Intel mobile express gm45 chipset.

>  Is it suspend
> or resume that is unreliable?

suspend never finishes/hangs.

>  What are the particular symptoms --- does
> not suspend, crashes during suspend, crashes during resume...?

Does not suspend, backlight is on.

> -- 
> Stefan Richter
> -=====-==-=- =--- ----=
> http://arcgraph.de/sr/
