Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756913Ab2GEQi6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 12:38:58 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:56043 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab2GEQi5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 12:38:57 -0400
MIME-Version: 1.0
In-Reply-To: <20469.7733.613739.886141@gargle.gargle.HOWL>
References: <20469.7733.613739.886141@gargle.gargle.HOWL>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Thu, 5 Jul 2012 09:38:35 -0700
X-Google-Sender-Auth: U5FKQV0d0dZvRXqydw2_UZjCBlo
Message-ID: <CAB=NE6XP0cVhPL2FqVhsSeaQ7BV4QndhmZNbto9P3=9ko6YGFg@mail.gmail.com>
Subject: Re: Stable compat-wireless updates
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alex Mendoza <wargod@suneco.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 4, 2012 at 9:55 PM, Sujith Manoharan
<c_manoha@qca.qualcomm.com> wrote:
> Hi,
>
> A pull request for the 3.5.y branch.
>
> Sujith
>
> The following changes since commit a1959d00333104cd58bd07741ef0c40766836a77:
>
>   compat-wireless: skip forcing refresh on gen-stable-release.sh (2012-06-19 15:24:07 -0700)
>
> are available in the git repository at:
>
>   https://github.com/sujith/compat-wireless.git linux-3.5.y
>
> for you to fetch changes up to 73df80f65d3ab2a83275e2ffcb54b64484cf3821:
>
>   compat-wireless: Update offsets of the new patches (2012-07-04 23:06:29 +0530)
>
> ----------------------------------------------------------------
> Sujith Manoharan (6):
>       compat-wireless: Remove patches from linux-next-pending
>       compat-wireless: Add pending stable patches (v3.5-rc5)
>       compat-wireless: Remove a patch
>       compat-wireless: Update patch offsets
>       compat-wireless: Add cherry picked patches
>       compat-wireless: Update offsets of the new patches

Thanks! Just a reminder to other vendors that if they wish to include
their own set of deltas for stable compat-wireless releases but still
prioritize and respect the upstream process the additional patches to
compat-wireless allows for this, and this is exactly what Sujith is
using here.

Kicked out 3 new releases, all test compiled across 21 kernels:

http://wireless.kernel.org/en/users/Download/stable/
http://wireless.kernel.org/en/users/Download/stable/#Additional_patches_to_stable_releases

http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/ChangeLog-3.5-rc5

http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5-rc5-1.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5-rc5-1-sn.tar.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/compat-wireless-3.5-rc5-1-snpc.tar.bz2

http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/ckmake-3.5-rc5-1.log.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/ckmake-3.5-rc3-1-sn.log.bz2
http://www.orbit-lab.org/kernel/compat-wireless-3-stable/v3.5/ckmake-3.5-rc5-1-snpc.log.bz2

If someone has access to a fast box I can use or set of boxes it would
really help with speeding up releases. Test compiling each releases
takes 120 minutes right now as it cross compiles across 21 kernels.
Just this test compilation for all 3 releases took 6 hours. If we
could test compile one kernel per server that would shave down
compilation time considerably.

mcgrof@flash ~/tmp $ for i in compat-wireless-3.5-rc5-1
compat-wireless-3.5-rc5-1-sn compat-wireless-3.5-rc5-1-snpc ; do cd
$i; ckmake ; cd .. ; done
Trying kernel                  3.4.0-030400rc4-generic  [OK]
Trying kernel                     3.3.3-030303-generic  [OK]
Trying kernel                     3.2.2-030202-generic  [OK]
Trying kernel                    3.1.10-030110-generic  [OK]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [OK]
Trying kernel                    2.6.24-020624-generic  [OK]
Trying kernel                  3.4.0-030400rc4-generic  [OK]
Trying kernel                     3.3.3-030303-generic  [OK]
Trying kernel                     3.2.2-030202-generic  [OK]
Trying kernel                    3.1.10-030110-generic  [OK]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [OK]
Trying kernel                    2.6.24-020624-generic  [OK]
Trying kernel                  3.4.0-030400rc4-generic  [OK]
Trying kernel                     3.3.3-030303-generic  [OK]
Trying kernel                     3.2.2-030202-generic  [OK]
Trying kernel                    3.1.10-030110-generic  [OK]
Trying kernel                    3.0.18-030018-generic  [OK]
Trying kernel                  2.6.39-02063904-generic  [OK]
Trying kernel                  2.6.38-02063808-generic  [OK]
Trying kernel                  2.6.37-02063706-generic  [OK]
Trying kernel                  2.6.36-02063604-generic  [OK]
Trying kernel                  2.6.35-02063512-generic  [OK]
Trying kernel                  2.6.34-02063410-generic  [OK]
Trying kernel                  2.6.33-02063305-generic  [OK]
Trying kernel                  2.6.32-02063255-generic  [OK]
Trying kernel                  2.6.31-02063113-generic  [OK]
Trying kernel                  2.6.30-02063010-generic  [OK]
Trying kernel                  2.6.29-02062906-generic  [OK]
Trying kernel                  2.6.28-02062810-generic  [OK]
Trying kernel                    2.6.27-020627-generic  [OK]
Trying kernel                    2.6.26-020626-generic  [OK]
Trying kernel                    2.6.25-020625-generic  [OK]
Trying kernel                    2.6.24-020624-generic  [OK]

  Luis
