Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab2FNRO6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 13:14:58 -0400
Received: from hera.cwi.nl ([192.16.191.8]:58604 "EHLO hera.cwi.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752975Ab2FNRO5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 13:14:57 -0400
Message-ID: <4FDA1C03.3020404@cwi.nl>
Date: Thu, 14 Jun 2012 18:14:43 +0100
From: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120510 Icedove/10.0.4
MIME-Version: 1.0
To: "Wouter M. Koolen" <W.M.Koolen-Wijkstra@cwi.nl>
CC: Daniel Vetter <daniel.vetter@ffwll.ch>, Dave Airlie <airlied@gmail.com>,
        intergalactic.anonymous@gmail.com, len.brown@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        "Barnes, Jesse" <jbarnes@virtuousgeek.org>,
        "Wilson, Chris" <chris.wilson@intel.com>
Subject: Re: [3.4 regression] [bisected] DisplayPort fails to come on
References: <4FD9E69A.4090708@cwi.nl> <CAPM=9tzL-TyDLKWdmCdi5d6PzQTs3sTLnqnLG_s7K2h9WNOEvQ@mail.gmail.com> <CAKMK7uGokt5cW0R+LKXRmE_kecqmnv4Zgy-WiSZA-GPP8htE-A@mail.gmail.com> <4FD9F9B0.9030204@cwi.nl>
In-Reply-To: <4FD9F9B0.9030204@cwi.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2012 03:48 PM, Wouter M. Koolen wrote:
> In the mean while I will redo the bisect. 
Hi guys,

I did a bisect on the actual problem (and not on the maybe-related 
second error message). It results in 
092945e11c5b84f66dd08f0b87fb729715d377bc:

Author: Adam Jackson <ajax@redhat.com>  2011-07-26 20:39:45
Committer: Daniel Vetter <daniel.vetter@ffwll.ch>  2012-01-17 15:46:56
Parent: 6919132e7a307b1f181d7655b3ef64cc7581a5ef (drm/i915/dp: Tweak 
auxch clock divider for PCH)
Branches: linux-3.4.y, remotes/origin/linux-3.4.y, remotes/origin/master
Follows: v3.2-rc6
Precedes: v3.4-rc1

     drm/i915/dp: Use auxch precharge value of 5 everywhere

     The default in the Sandybridge docs is 5, as on Ironlake, and I have no
     reason to believe 3 would work any better.

     Signed-off-by: Adam Jackson <ajax@redhat.com>
     Acked-by: Jesse Barnes <jbarnes@virtuousgeek.org>
     Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>

I guess there is your reason for 3 :)

Any advice on how to proceed would be very helpful.

Cheers,

Wouter
