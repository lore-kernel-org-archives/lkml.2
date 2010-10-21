Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab0JUJHC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 05:07:02 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:61988 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355Ab0JUJHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 05:07:00 -0400
MIME-Version: 1.0
X-Originating-IP: [109.186.69.160]
In-Reply-To: <B85A65D85D7EB246BE421B3FB0FBB5930233F94602@dbde02.ent.ti.com>
References: <1287387875-14168-1-git-send-email-ohad@wizery.com>
 <1287387875-14168-4-git-send-email-ohad@wizery.com> <87r5fmxghm.fsf@deeprootsystems.com>
 <AANLkTinZ2+ocJCfUpT15Ow3J9XBa-8XWnVC3gDDJ7s-v@mail.gmail.com>
 <87bp6pviwf.fsf@deeprootsystems.com> <AANLkTikE1dCXW-7ScVoDgEK3sxai_TyFzstSG+zvNm2F@mail.gmail.com>
 <8739s0sobc.fsf@deeprootsystems.com> <AANLkTikdjtYtzhgM_=io3SFdUZq=8Xcc8n24bW=SFgTA@mail.gmail.com>
 <B85A65D85D7EB246BE421B3FB0FBB5930233F94602@dbde02.ent.ti.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 21 Oct 2010 11:06:39 +0200
Message-ID: <AANLkTi=dfw==t+u1Ap26iwPHH9A2M-cEU0hs92Gxdkxc@mail.gmail.com>
Subject: Re: [PATCH 3/3] omap: add hwspinlock device
To: "Kamoolkar, Mugdha" <mugdha@ti.com>
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        "Krishnamoorthy, Balaji T" <balajitk@ti.com>,
        "Kamat, Nishant" <nskamat@ti.com>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        Greg KH <greg@kroah.com>, Tony Lindgren <tony@atomide.com>,
        "Cousson, Benoit" <b-cousson@ti.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "Kanigeri, Hari" <h-kanigeri2@ti.com>, "Anna, Suman" <s-anna@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 21, 2010 at 10:36 AM, Kamoolkar, Mugdha <mugdha@ti.com> wrote:
>> <khilman@deeprootsystems.com> wrote:
>> > Yes, that would indeed simplify things.
>>
>> Balaji, Nishant, are you OK with this ?
>>
> The problem with this approach is that the i2c driver would have to
> sync up on the shared memory location that it uses to share the
> information of the spinlock ID.

I agree.

But we seem to have this sort of problem anyway:

Since we are forbidden to take a hwspinlock over a lengthy period of
time, i2c-omap can't really use it directly to achieve mutual
exclusion over the entire i2c transfer (which is long and involved
sleeping).

It was suggested that i2c-omap would only use the hwspinlock to
protect a shared memory entry which would indicate the owner of the
i2c bus. Either that, or use something like Peterson's mutual
exclusion algorithm which is entirely implemented in software.

Both of the latter approaches involves sync'ing up on a shared memory
location..  so it seems like i2c-omap anyway has to deal with this
kind of pain, and having a predefined hwspinlock id number doesn't
relieve it.

What do you think ?

Thanks,
Ohad.
