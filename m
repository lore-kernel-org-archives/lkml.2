Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2FRWJJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 18:09:09 -0400
Received: from mga09.intel.com ([134.134.136.24]:3664 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab2FRWJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 18:09:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="155083944"
Message-ID: <4FDFA760.5040403@intel.com>
Date: Mon, 18 Jun 2012 19:10:40 -0300
From: Eugeni Dodonov <eugeni.dodonov@intel.com>
Organization: Intel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120616 Thunderbird/13.0.1
MIME-Version: 1.0
To: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
CC: Ben Hutchings <ben@decadent.org.uk>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>
Subject: Re: [ 04/69] drm/i915: fix up ivb plane 3 pageflips
References: <20120617175941.281333656@decadent.org.uk> <20120617175941.924141588@decadent.org.uk> <20120618215555.GD3263@herton-Z68MA-D2H-B3>
In-Reply-To: <20120618215555.GD3263@herton-Z68MA-D2H-B3>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 06:55 PM, Herton Ronaldo Krzesinski wrote:
>> +	default:
>> +		WARN_ONCE(1, "unknown plane in flip command\n");
>> +		ret = -ENODEV;
>> +		goto err;
> 
> Shouldn't this have been "goto err_unpin;"?
> 
> It's not a problem in the backport for 3.2, same code is in the original
> patch, just noticed it seems a problem while looking at it; but by what
> changelog says the default case is said to not trigger in "practice"
> (catch programming error), so I think it doesn't pose a real issue in
> practice.

You are right, it should be err_unpin. I sent a patch rectifying this.

In practice, this should not happen, but still, better be safe than
sorry. Thanks for catching that!

Eugeni
