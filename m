Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753146Ab2KEIVW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:21:22 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59443 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751979Ab2KEIVV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:21:21 -0500
Date: Mon, 5 Nov 2012 09:21:16 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-kernel@vger.kernel.org, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 6/9] virtio_mmio: =?utf-8?Q?Cas?=
 =?utf-8?Q?t_&resources=5B1=5D=2Estart_to_=E2=80=98unsigned_int_*?=
 =?utf-8?B?4oCZ?= to rid compiler warning
Message-ID: <20121105082116.GB2699@gmail.com>
References: <1351980150-24145-1-git-send-email-lee.jones@linaro.org>
 <1351980150-24145-7-git-send-email-lee.jones@linaro.org>
 <87k3u0ydry.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87k3u0ydry.fsf@rustcorp.com.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 05 Nov 2012, Rusty Russell wrote:

> Lee Jones <lee.jones@linaro.org> writes:
> > drivers/virtio/virtio_mmio.c: In function ‘vm_cmdline_set’:
> > drivers/virtio/virtio_mmio.c:535:4: warning: format ‘%u’ expects argument of type ‘unsigned int *’, but argument 4 has type ‘resource_size_t *’ [-Wformat]
> >
> > Cc: Rusty Russell <rusty@rustcorp.com.au>
> > Cc: virtualization@lists.linux-foundation.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > ---
> >  drivers/virtio/virtio_mmio.c |    2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/drivers/virtio/virtio_mmio.c b/drivers/virtio/virtio_mmio.c
> > index 6b1b7e1..077e9ca 100644
> > --- a/drivers/virtio/virtio_mmio.c
> > +++ b/drivers/virtio/virtio_mmio.c
> > @@ -531,7 +531,7 @@ static int vm_cmdline_set(const char *device,
> >  	resources[0].end = memparse(device, &str) - 1;
> >  
> >  	processed = sscanf(str, "@%lli:%u%n:%d%n",
> > -			&base, &resources[1].start, &consumed,
> > +			&base, (unsigned int *)&resources[1].start, &consumed,
> >  			&vm_cmdline_id, &consumed);
> 
> This suppresses a valid warning, leaving our code no less wrong than
> before.  But now it's silently wrong!
> 
> Do you want to try again?

For sure I'll try again.

How does `s/%u/%p/` suit?

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
