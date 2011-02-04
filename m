Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752404Ab1BDHch (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 02:32:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61469 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713Ab1BDHcc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 02:32:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=VVAWVs0tPZ4D4xdT2hPFZbhcsfsHlTPXIUx1BUJ/2oNu/mFGvzhXhDYsMEYMRsIqOq
         PCIFyQJ+z95namNg1+yLps9jXWZNQnbBPq23+Od+OM2UZ/zR/Gkh3ZOnD1espr4ura23
         YjSxMu0eoMm3WN18UoMvjbEWkzmaaMjnE6C3Y=
MIME-Version: 1.0
In-Reply-To: <4D4B1AF4.2050000@hauke-m.de>
References: <380B2771CDD78E46856E6B788D9F1997D2468080@orsmsx503.amr.corp.intel.com>
 <BD672EAEE3AD2C47A7120B0973C3FB3A50F0AC156A@SC1EXMB-MBCL.global.atheros.com>
 <380B2771CDD78E46856E6B788D9F1997D27D86D2@orsmsx503.amr.corp.intel.com>
 <20110202220926.GB3035@tux> <20110202222645.GE3035@tux> <4D4B1AF4.2050000@hauke-m.de>
From: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Date: Thu, 3 Feb 2011 23:32:10 -0800
X-Google-Sender-Auth: oUsV4g-ooJxdWsn_Nb4HiaLa_4c
Message-ID: <AANLkTimE4qGK2-kP1p+PG56ti41TR5kTf88HHJjADoZO@mail.gmail.com>
Subject: Re: Backporting other subsystems on Linux
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: Luis Rodriguez <Luis.Rodriguez@atheros.com>,
        "Zhao, Shanyu" <shanyu.zhao@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Lance Zimmerman <lance.zimmerman@atheros.com>,
        Prem Kumar <Prem.Kumar@atheros.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 1:15 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> On 02/02/2011 11:26 PM, Luis R. Rodriguez wrote:
>> On Wed, Feb 02, 2011 at 02:09:26PM -0800, Luis Rodriguez wrote:
>>> Increasing audience.
>>>
>>> On Wed, Feb 02, 2011 at 01:27:10PM -0800, Zhao, Shanyu wrote:
>>>> Hi Luis,
>>>>
>>>> Thank you for the quick response. When I say USB, I didn't mean USB network
>>>> drivers, I'm talking about USB host/device controller drivers or gadget
>>>> drivers. For example, we can backport USB3 support to, say, 2.6.28.
>>>>
>>>> From what I understand, I can add any driver to your compat-wireless tree and
>>>> build it the same way as other wireless drivers. Am I right?
>>>
>>> That's right.
>>>
>>>> Then your tree should really be called compat-drivers. :) I'm not sure if
>>>> you're welcoming non-network related drivers.
>
> When adding more and more stuff we should probably rename
> compat-wireless to something else. ;-)

:) sure. compat-kernel ? Only reason I stopped adding more compat
stuff was I found ALSA folks already had their own backport effort and
that even goes down to 2.4. The style is a bit different though too. I
did try to do my own ALSA backport ala compat-wireless and I do have
that git tree still up on git.kernel.org. I then considered trying
video but Ubuntu folks did the whole in-kernel DRM backport so I lost
motivation as they had that taken care of. If we do want more kernel
stuff backported all together we essentially will just need people
taking ownership of helping upkeep other subsystems. I will welcome
patches :)

> I am fine with adding USB3 support, if Intel will help maintaining the
> stuff in compat-wireless after they added it.

Agreed.

>>> What I really need to get to at some point is to use implement a
>>> menuconfig thingy, we already drag the Kconfigs in but use config.mk for
>>> makefile/dependency mapping. Patches welcomed.
>>
>> BTW one idea I have as of recent is to consider using Hudson for automatic
>> build testing for compat-wireless but haven't yet mucked with it. Eventually
>> this will be more and more important as time goes by and we support older
>> kernels. The goal is to at the *very least* always support down to the last
>> stable 2.6 kernel listed on kernel.org, today that is 2.6.27 and I think its
>> a safe promise to commit to backporting *at least* to that kernel. We go
>> beyond 2.6.27 though today.
>
> Automatic compile testing is really needed for compat-wireless. There
> are often some special kernel version where it does not compile, like
> now. ;-)
>
> Some time ago I started writing a small bash script which tries to build
> compat-wireless for various kernel versions and sends a email if
> something went wrong. This was more or less hacked together from the
> compat-wireless release script and some other scripts I have here. I
> stopped working on this after I recognized that my server is way to slow
> for running this script (compat-wireless build for one kernel toke more
> than 30 minutes).
>
> Using hudson or buildbot [2] is the better choice, but it should just
> take 1 to 2 hours to get this hacked script working. Luis do you have a
> server with hudson installed or a server capable for running hudson and
> building compat-wireless? My server has a Intel Celeron with 2.4 GHz and
> 512MB Ram. I have to clean up my script before releasing it to someone
> else, but if someone is interest I have no problem with making it relay
> for use.

Yes, I do. I also have a Hudson demo to attend tomorrow that Lance is
putting together so I can also likely pick his brain. Let me try to
set that up.

  Luis
