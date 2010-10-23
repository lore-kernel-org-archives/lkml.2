Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab0JWATX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Oct 2010 20:19:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:48131 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753011Ab0JWATW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Oct 2010 20:19:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Fhb89MGe8rViEmb9958L08EKvGFmxsajwMoByj2r9ZA3+tnEFJr9TpvUFclTqyvdWu
         2Cj/oUEVxYXVJPKsknl0eS+WwsppA+Q6WuLXnVh/ot1FOpWeTPp5t5vqlk14t0OtW71Q
         UScOpm8rRyNQlD5HExW5kHlWHnM/I0dm9FMmQ=
MIME-Version: 1.0
In-Reply-To: <20101022170255.7feab5de.rdunlap@xenotime.net>
References: <1287753199.2122.0.camel@cowboy>
	<20101022165517.effde8fb.akpm@linux-foundation.org>
	<20101022170255.7feab5de.rdunlap@xenotime.net>
Date: Sat, 23 Oct 2010 10:19:20 +1000
Message-ID: <AANLkTi=w5p8Un_xyaDWVuV8Ksvj7HX0WDipptU4XGqEN@mail.gmail.com>
Subject: Re: [PATCH RESEND] drm: include missing types header to drm_mode.h
From: Dave Airlie <airlied@gmail.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Andrew Morton <akpm@linux-foundation.org>, dave@gnu.org,
        Dave Airlie <airlied@redhat.com>, Dave Airlie <airlied@linux.ie>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 23, 2010 at 10:02 AM, Randy Dunlap <rdunlap@xenotime.net> wrote:
> On Fri, 22 Oct 2010 16:55:17 -0700 Andrew Morton wrote:
>
>> On Fri, 22 Oct 2010 10:13:19 -0300
>> Davidlohr Bueso <dave@gnu.org> wrote:
>>
>> > drm: include missing types header to drm_mode.h
>> >
>> > Signed-off-by: Davidlohr Bueso <dave@gnu.org>
>> > ---
>> >  include/drm/drm_mode.h |    2 ++
>> >  1 files changed, 2 insertions(+), 0 deletions(-)
>> >
>> > diff --git a/include/drm/drm_mode.h b/include/drm/drm_mode.h
>> > index 0fc7397..eddd7f4 100644
>> > --- a/include/drm/drm_mode.h
>> > +++ b/include/drm/drm_mode.h
>> > @@ -24,6 +24,8 @@
>> >   * IN THE SOFTWARE.
>> >   */
>> >
>> > +#include <linux/types.h>
>> > +
>> >  #ifndef _DRM_MODE_H
>> >  #define _DRM_MODE_H
>> >
>>
>> Does this fix a build error?  If so, please send along the compiler
>> error output.
>
>
> Every build that has CONFIG_HEADERS_CHECK=y reports the following:
>
> linux-next-20101022/X64/usr/include/drm/drm_mode.h:85: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/drm/i915_drm.h:120: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/drm/mga_drm.h:260: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/drm/radeon_drm.h:758: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/drm/via_drm.h:117: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/scsi/scsi_netlink.h:108: found __[us]{8,16,32,64} type without #include <linux/types.h>
> linux-next-20101022/X64/usr/include/linux/resource.h:49: found __[us]{8,16,32,64} type without #include <linux/types.h>
>
>

Why doesn't the tool understand header recursion? drm_mode.h needs to
include drm.h but the rest already include drm.h.

Including drm.h includes linux/types.h if defined(__linux__)

So really I've said this a few times now, its the stupid tool that is
broken for most of these, fix the tool and I'll fix drm_mode.h

Dave.
