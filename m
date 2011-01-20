Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755377Ab1ATKRT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 05:17:19 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53049 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755301Ab1ATKRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:17:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=nL0EX++eANAPjCBjuj/4PzzbpuhYaRVn84oHST4Cqn8WhgmMfCtxcD/etQRcMPeRQD
         SlnN2WNY440sgTpo3PgCCQa3f7nnIm/b4FXpdpEvIpIR90d9wLtFELO85Srkr13S3vyJ
         uleyAMGg5UaL6Jrl1tF7+7pREvReDSNHtoEkE=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=s9ZMdUe2bsK2OA5rJBej=R8CaJyE+kT3Fd5wG@mail.gmail.com>
References: <AANLkTimOkFckq+r4cD-PSzc_RNs+HJL5CcEM-3Yh+dF6@mail.gmail.com>
	<AANLkTin98pf1d29AtT7RwjGBeR=m4rBp7Ks6vvmz18vf@mail.gmail.com>
	<AANLkTi=s9ZMdUe2bsK2OA5rJBej=R8CaJyE+kT3Fd5wG@mail.gmail.com>
Date: Thu, 20 Jan 2011 18:17:17 +0800
Message-ID: <AANLkTi=CoUWLegGzuXVM1w2Uvez_Y23U2uaZTE_O9Mdn@mail.gmail.com>
Subject: Re: more intel drm issues (was Re: [git pull] drm intel only fixes)
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Len Brown <len.brown@intel.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jesse Barnes <jbarnes@virtuousgeek.org>,
        Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 2:22 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Wed, Jan 19, 2011 at 8:55 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>>
>> Rafael send out two patches earlier. Could be related. I was facing
>> issue during resume.
>
> No, I'm aware of the rcu-synchronize thing, this isn't it. This is
> really at the suspend stage, and I had bisected it down to the drm
> changes.
>
> In fact, by now I have bisected it down to a single commit. It's
> another merge commit, which makes me a bit nervous (I bisected another
> issue today, and it turned out to simply not be repeatable).
>
> But this time the merge commit actually has a real conflict that got
> fixed up in the merge, and the code around the conflict waits for
> three seconds, and three seconds is also exactly how long the delay at
> suspend time is. So I get the feeling that this time it's a real
> issue, and what happened was that the merge may have been a mismerge.

I did see that once during suspend. But as you mentioned,  3 seconds,
and it wasn't repeatable. It was at the first suspend right after
reboot.


Jeff
