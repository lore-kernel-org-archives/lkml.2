Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753890Ab2FSLnr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 07:43:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:48636 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751930Ab2FSLnq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 07:43:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167477041"
Message-ID: <4FE06659.8060809@intel.com>
Date: Tue, 19 Jun 2012 08:45:29 -0300
From: Eugeni Dodonov <eugeni.dodonov@intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [ 04/69] drm/i915: fix up ivb plane 3 pageflips
References: <20120617175941.281333656@decadent.org.uk>  <20120617175941.924141588@decadent.org.uk>  <20120618215555.GD3263@herton-Z68MA-D2H-B3> <4FDFA760.5040403@intel.com> <1340078392.6871.6.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1340078392.6871.6.camel@deadeye.wl.decadent.org.uk>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA256

On 06/19/2012 12:59 AM, Ben Hutchings wrote:
> On Mon, 2012-06-18 at 19:10 -0300, Eugeni Dodonov wrote:
>> On 06/18/2012 06:55 PM, Herton Ronaldo Krzesinski wrote:
>>>> +	default: +		WARN_ONCE(1, "unknown plane in flip 
>>>> command\n"); +		ret = -ENODEV; +		goto err;
>>> 
>>> Shouldn't this have been "goto err_unpin;"?
>>> 
>>> It's not a problem in the backport for 3.2, same code is in the
>>> original patch, just noticed it seems a problem while looking
>>> at it; but by what changelog says the default case is said to
>>> not trigger in "practice" (catch programming error), so I think
>>> it doesn't pose a real issue in practice.
>> 
>> You are right, it should be err_unpin. I sent a patch rectifying
>>  this.
>> 
>> In practice, this should not happen, but still, better be safe 
>> than sorry. Thanks for catching that!
> 
> So should I drop this until the second patch is upstream?

I don't think there is a need. It is nearly impossible to hit this
situation, and if it happens the machine will be quite broken in a way
this patch won't help recovering it anyway.

So you could merge the original patch as is - it fixes some real
issues on Ivy Bridge which are much more likely to happen.

Eugeni
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iQEcBAEBCAAGBQJP4GZZAAoJEPE+raS4SlCBBncH/08HYA+d304lNiEKSq7i/0i7
V399aS9KtimsXNKsf7wal017hmxevujc5fElY5lFYM0RTw3nEUGmnOlWZ0FdRt/S
BuIz6BQ5RcZBexdYxwss/J/grLo5Wv/v6oBf+0zb2nJVSt6fmbU8vWixnbmsiQF/
uMZJ5o1wD/Dj4gIF8g91altkLMDE5HBrUC6HqF/pPSd+h+Xp6+VHXlre5+YZ85ZK
HefD9kjWSMLzWZfvbySua7hqoEb2Z5/bSzyvtOFtf3teg/uLICvX6wiNhUjahGCQ
6gHTZz+FtzQ7iqqtO3+6loQrcx/u7cbNi8HoJkwyIKO8bxth1Rv1DWUPsHoCb/8=
=UozC
-----END PGP SIGNATURE-----
