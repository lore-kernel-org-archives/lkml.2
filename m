Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab2A0Ol3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:41:29 -0500
Received: from smtp-outbound-1.vmware.com ([208.91.2.12]:46371 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752702Ab2A0Ol2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:41:28 -0500
Date: Fri, 27 Jan 2012 06:41:27 -0800 (PST)
From: Jakob Bornecrantz <jakob@vmware.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: airlied@linux.ie, airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, joe Perches <joe@perches.com>,
        Ryan Mallon <rmallon@gmail.com>
Message-ID: <170320114.179239.1327675287439.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4F22B4A6.1070202@vmware.com>
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
> On 01/27/2012 03:24 PM, Jakob Bornecrantz wrote:
> > I was asking around and this seems to only be used by X when it
> > starts and we want to preserve the contents of the screen. That
> > feature is implemented by the X driver. So we need to figure how we
> > want to solve it.
> >
> > Either way this fix should probably go into this RC series, not
> > sure if we need to send this to stable, since we are not leaking
> > data to userspace (check drm_mode_getfb), but we might as well.
> >
> > Reviewed-by: Jakob Bornecrantz<jakob@vmware.com>
> 
> But shouldn't we return the *real* handle. Not 0??

Yeah, you are right. Not sure we have user_handle in the stable
kernels tho.

We need to change not only the X driver but also all the other
userspace components since at least libkms doesn't create shared
buffers. And if the thing that is running before X is using fbdev
this wont do much good either since fbdev is not backed by a
fb in the way other drivers do it.

Cheers, Jakob.
