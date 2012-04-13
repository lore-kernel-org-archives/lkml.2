Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab2DMLt7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 07:49:59 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63703 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2DMLt5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 07:49:57 -0400
MIME-Version: 1.0
In-Reply-To: <1334175985_372722@CP5-2952>
References: <1333108003-6341-1-git-send-email-djkurtz@chromium.org>
 <1333108003-6341-5-git-send-email-djkurtz@chromium.org> <20120410103746.GH4115@phenom.ffwll.local>
 <20120410104147.GI4115@phenom.ffwll.local> <CAGS+omAjDPxs1qR-EwzKhjE9c5J26fZinv6+5RFz1RyAsfStmw@mail.gmail.com>
 <20120410150304.GJ4115@phenom.ffwll.local> <1334093645_352764@CP5-2952>
 <CAGS+omAftY7bCYzRp-0XLbGt7-YTz9My6dPz21G1Hr4qC=g=Jw@mail.gmail.com> <1334175985_372722@CP5-2952>
From: Daniel Kurtz <djkurtz@chromium.org>
Date: Fri, 13 Apr 2012 19:49:36 +0800
X-Google-Sender-Auth: SclYPKGyIwLnnlvcyt2X_VlMDjw
Message-ID: <CAGS+omAJE_vjdL_H5r6ByJFagOHtH1tDHFwzwWuF2bWxaYdkcw@mail.gmail.com>
Subject: Re: [PATCH 4/8 v7] drm/i915/intel_i2c: use WAIT cycle, not STOP
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Daniel Vetter <daniel@ffwll.ch>, Keith Packard <keithp@keithp.com>,
        David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 12, 2012 at 4:26 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Thu, 12 Apr 2012 02:17:46 +0800, Daniel Kurtz <djkurtz@chromium.org> wrote:
>> On Wed, Apr 11, 2012 at 5:34 AM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
>> > The last major item on the wishlist is solving how to drive the SDVO i2c
>> > over gmbus. I think it is just a matter of massaging in the channel
>> > switch as msg[0].
>>
>> I noticed that random other i2c adapter, but haven't looked at it to
>> know why it is so different than the others.  What is it?
>
> Every command sequence over SDVO is preceded by an instruction to the
> controller as to which function to send the command to. Originally I
> tried to reuse the GPIO method of simply sending that switch command
> immediately followed by the real message, but I never succeeded in
> setting up the SDVO devices in that manner. I suspect what is actually
> required is to rebuild the message to include the preceeding bus switch.
>
> However, if you don't have any SDVO devices to experiment with we can
> find somebody who does.

Sorry, I don't have any SDVO hardware to play with.

> -Chris
>
> --
> Chris Wilson, Intel Open Source Technology Centre
