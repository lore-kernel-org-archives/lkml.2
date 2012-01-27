Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755827Ab2A0PBf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 10:01:35 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:38620 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755756Ab2A0PBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 10:01:33 -0500
Date: Fri, 27 Jan 2012 07:01:33 -0800 (PST)
From: Jakob Bornecrantz <jakob@vmware.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: airlied@linux.ie, airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, joe Perches <joe@perches.com>,
        Ryan Mallon <rmallon@gmail.com>
Message-ID: <1884829440.180014.1327676493018.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4F22BA91.9020406@vmware.com>
Subject: Re: [RFC PATCH] vmwgfx: Fix assignment in
 vmw_framebuffer_create_handle
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Originating-IP: [85.225.38.204]
X-Mailer: Zimbra 7.1.3_GA_3374 (ZimbraWebClient - GC15 (Linux)/7.1.3_GA_3346)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On 01/27/2012 03:41 PM, Jakob Bornecrantz wrote:
> > ----- Original Message -----
> >> On 01/27/2012 03:24 PM, Jakob Bornecrantz wrote:
> >>> I was asking around and this seems to only be used by X when it
> >>> starts and we want to preserve the contents of the screen. That
> >>> feature is implemented by the X driver. So we need to figure how
> >>> we
> >>> want to solve it.
> >>>
> >>> Either way this fix should probably go into this RC series, not
> >>> sure if we need to send this to stable, since we are not leaking
> >>> data to userspace (check drm_mode_getfb), but we might as well.
> >>>
> >>> Reviewed-by: Jakob Bornecrantz<jakob@vmware.com>
> >> But shouldn't we return the *real* handle. Not 0??
> >
> > Yeah, you are right. Not sure we have user_handle in the stable
> > kernels tho.
>
> We do AFAICT.
> 
> >
> > We need to change not only the X driver but also all the other
> > userspace components since at least libkms doesn't create shared
> > buffers.
>
> Libkms is not used anymore, at least not in the X server driver.

I was more referring to Plymouth and the like.

> >   And if the thing that is running before X is using fbdev
> > this wont do much good either since fbdev is not backed by a
> > fb in the way other drivers do it.
>
> OK. Then I suggest we just return 0 here, and go ahead with the
> current patch, and when we've figured out how to do the handover,
> we bump kernel minor and return a proper handle. Does that sound
> OK?

Sounds good to me.

Cheers, Jakob.
