Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab0HALm4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 07:42:56 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58103 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab0HALmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 07:42:55 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4C555DA0.6020109@s5r6.in-berlin.de>
Date: Sun, 01 Aug 2010 13:42:24 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100627 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Thomas Meyer <thomas@m3y3r.de>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zou Nan hai <nanhai.zou@intel.com>,
        Xiang Hai hao <haihao.xiang@intel.com>, Eric Anholt <eric@anholt.net>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: Re: 2.6.35-rc6+: i915: Bisected regression
References: <201008011101.01429.thomas@m3y3r.de>
In-Reply-To: <201008011101.01429.thomas@m3y3r.de>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thomas Meyer wrote:
> This commit makes suspend to ram unreliable for me:
> 
> commit d1b851fc0d105caa6b6e3e7c92d2987dfb52cbe0
> Author: Zou Nan hai <nanhai.zou@intel.com>
> Date:   Fri May 21 09:08:57 2010 +0800
> 
>     drm/i915: implement BSD ring buffer V2
>     
>     The BSD (bit stream decoder) ring is used for accessing the BSD engine
>     which decodes video bitstream for H.264 and VC1 on G45+.  It is
>     asynchronous with the render ring and has access to separate parts of
>     the GPU from it, though the render cache is coherent between the two.
>     
>     Signed-off-by: Zou Nan hai <nanhai.zou@intel.com>
>     Signed-off-by: Xiang Hai hao <haihao.xiang@intel.com>
>     Signed-off-by: Eric Anholt <eric@anholt.net>
> 
> git revert didn't work on 2.6.35-rc6 so I just changed the HAS_BSD thing to:
> 
> #define HAS_BSD(dev)            (0)
> 
> with this change applied suspend to ram is back to the reliability of 2.6.34.y
> 
> with kind regards
> thomas

Added CCs.

Thomas, on what hardware did you observe the regression?  Is it suspend
or resume that is unreliable?  What are the particular symptoms --- does
not suspend, crashes during suspend, crashes during resume...?
-- 
Stefan Richter
-=====-==-=- =--- ----=
http://arcgraph.de/sr/
