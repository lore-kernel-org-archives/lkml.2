Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039Ab0LUUCa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 15:02:30 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:60716 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752858Ab0LUUC1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 15:02:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Dqw2s+yKH+zhgTJq9eA5NeRGJAtX9oCLIb9nUvMFSiJBl7/q0bOyWlczPjX0QzndkS
         gXFjyzC4luLxytCO5hjEhJiIs1KAeHi3wZbIQXtfH2XYMuElSrx8CCelo5jnV6zix3U6
         5igJFEu1lUa+2IFDSUZFwQ6IKP1wJQvKPLveg=
MIME-Version: 1.0
In-Reply-To: <AANLkTik94Go7W4AMquncm-novWkHtLOBRn7BfpepoEZz@mail.gmail.com>
References: <1292866298-8585-1-git-send-email-per.forlin@stericsson.com>
	<AANLkTi=7E7rAc=46p5d6YSpLeut5yehmBtLa4TVofefp@mail.gmail.com>
	<AANLkTin=U6j4XTmCq4H4sKivD+jecxor3Q-7mYFDfD=N@mail.gmail.com>
	<AANLkTik94Go7W4AMquncm-novWkHtLOBRn7BfpepoEZz@mail.gmail.com>
Date: Tue, 21 Dec 2010 12:02:26 -0800
X-Google-Sender-Auth: WDvSwmU220M14C_vvhqdz6DsN8Q
Message-ID: <AANLkTi=b45nmd+-yMKB_+AEyS6=9-aa+aBACUkZJLo_v@mail.gmail.com>
Subject: Re: [PATCH] dmaengine: dma40: Add support to split up large elements
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.ml.walleij@gmail.com>
Cc: Per Forlin <per.forlin@stericsson.com>, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>,
        Rabin VINCENT <rabin.vincent@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 11:28 AM, Linus Walleij
<linus.ml.walleij@gmail.com> wrote:
> 2010/12/21 Dan Williams <dan.j.williams@intel.com>:
>
>> If that is the case then the temporary fix for 2.6.37 is along the
>> lines of fixing up the clients to not submit such large requests.
>
> They don't, currently. We actually had some debate about this
> internally, because the only driver submitting something >64K-1
> was the MMCI driver (which is yet not in mainline) and yes, indeed
> the suggested solution was to amend the MMCI driver
> for the time being.
>
> I insisted on doing this fix anyway because I was under the
> impression that memcpy() is supposed to handle *any* size of
> request, is this the intention?

Yes, the api does not enforce a limit if a driver cannot handle a
given transaction size it can fail the prep.  To be useful the driver
at least needs to support PAGE_SIZE requests.

> Since its semantics are not documented as far as I can see I
> was maybe misguided in assuming that any size of buffer should
> be possible to pass in... :-(

No, you made the right call.  This is just a large change that I would
have a hard time justifying at this stage of the release process,
especially because mainline can't trigger it, even dmatest by default
cannot trigger it.  So I'll queue it up for the merge window.

If you want to send a patch that catches and reports this byte count
in case some out of tree user submits a large request that would be an
acceptable workaround for 37.  >64K support is a new feature for 38.

--
Dan
