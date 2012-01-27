Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab2A0Oeq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 09:34:46 -0500
Received: from smtp-outbound-2.vmware.com ([208.91.2.13]:57258 "EHLO
	smtp-outbound-2.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752017Ab2A0Oep (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 09:34:45 -0500
X-Greylist: delayed 590 seconds by postgrey-1.27 at vger.kernel.org; Fri, 27 Jan 2012 09:34:45 EST
Date: Fri, 27 Jan 2012 06:24:53 -0800 (PST)
From: Jakob Bornecrantz <jakob@vmware.com>
To: Thomas Hellstrom <thellstrom@vmware.com>
Cc: airlied@linux.ie, airlied@redhat.com, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, joe Perches <joe@perches.com>,
        Ryan Mallon <rmallon@gmail.com>
Message-ID: <1345211595.178155.1327674293610.JavaMail.root@zimbra-prod-mbox-2.vmware.com>
In-Reply-To: <4F22B02F.2010502@vmware.com>
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

I was asking around and this seems to only be used by X when it
starts and we want to preserve the contents of the screen. That
feature is implemented by the X driver. So we need to figure how we
want to solve it.

Either way this fix should probably go into this RC series, not
sure if we need to send this to stable, since we are not leaking
data to userspace (check drm_mode_getfb), but we might as well.

Reviewed-by: Jakob Bornecrantz <jakob@vmware.com>

Cheers, Jakob.

----- Original Message -----
> Ryan,
> 
> Thanks for pointing this out. Unfortunately there  seems to be two
> bugs here, the one you pointed out and the fact that we set the handle
> to zero, when it probably should be set to struct
> vmw_framebuffer::user_handle.
> 
> Jakob, can you comment on this?
> 
> /Thomas
> 
> On 01/27/2012 07:25 AM, Ryan Mallon wrote:
> > The assignment of handle in vmw_framebuffer_create_handle doesn't
> > actually do anything useful and is incorrectly assigning an integer
> > value to a pointer argument. It appears that this is a typo and
> > should
> > be dereferencing handle rather than assigning to it directly.
> >
> > Signed-off-by: Ryan Mallon<rmallon@gmail.com>
> > ---
> >
> > diff --git a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> > b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> > index 0af6ebd..b66ef0e 100644
> > --- a/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> > +++ b/drivers/gpu/drm/vmwgfx/vmwgfx_kms.c
> > @@ -378,7 +378,7 @@ int vmw_framebuffer_create_handle(struct
> > drm_framebuffer *fb,
> >   				  unsigned int *handle)
> >   {
> >   	if (handle)
> > -		handle = 0;
> > +		*handle = 0;
> >
> >   	return 0;
> >   }
> >
> 
> 
