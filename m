Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064Ab0G1GHA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 02:07:00 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:43303 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371Ab0G1GG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 02:06:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=g6R8g5t7sG5nXfuNw5oPHq835sPuknuRxZGMkNR4/VQvx7C3uk6Nb5ob2FZggy/xPl
         VgtOLZXnzS9KyaTEVOvc5AVrvvcUCCMNj9A7eGjEESnPdYCQ9hvq+UcZXtVQi3z5SJml
         UaTtqnGWHlHOBJAdQx0N1mhXzzr0oskv6BkN8=
Date: Wed, 28 Jul 2010 08:03:51 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: Valdis.Kletnieks@vt.edu
Cc: Andrew Morton <akpm@linux-foundation.org>, David Airlie <airlied@linux.ie>,
        Ben Skeggs <bskeggs@redhat.com>,
        Francisco Jerez <currojerez@riseup.net>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org, nouveau@lists.freedesktop.org
Subject: Re: mmotm 2010-07-27 - nouveau lockdep issues.
Message-ID: <20100728060334.GA2756@joi.lan>
References: <201007272226.o6RMQRBm008735@imap1.linux-foundation.org>
 <31845.1280295723@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31845.1280295723@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 01:42:03AM -0400, Valdis.Kletnieks@vt.edu wrote:
> On Tue, 27 Jul 2010 14:56:50 PDT, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2010-07-27-14-56 has been uploaded to
> > 
> >    http://userweb.kernel.org/~akpm/mmotm/
> 
> Hit this while the X server was on its way down during a 'shutdown -r now'. Worked fine
> in -rc5-mmotm0719. 'e16' is the Enlightenment window manager, if that matters.
> 
> [   93.181787] [drm:output_poll_execute] *ERROR* delayed enqueue failed 1
> [   99.802836] [drm] nouveau 0000:01:00.0: Allocating FIFO number 4
> [   99.808875] [drm] nouveau 0000:01:00.0: nouveau_channel_alloc: initialised FIFO 4
> [  103.262226] [drm:output_poll_execute] *ERROR* delayed enqueue failed 1
> [  113.341948] [drm:output_poll_execute] *ERROR* delayed enqueue failed 1
> [  123.421836] [drm:output_poll_execute] *ERROR* delayed enqueue failed 1
> [  123.550520] [drm] nouveau 0000:01:00.0: nouveau_channel_free: freeing fifo 4
> [  123.551253] 
> [  123.551253] ======================================================
> [  123.551253] [ INFO: HARDIRQ-safe -> HARDIRQ-unsafe lock order detected ]
> [  123.551253] 2.6.35-rc6-mmotm0727 #1
> [  123.551253] ------------------------------------------------------
> [  123.551253] e16/3822 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> [  123.551253]  (&(&mm->unused_lock)->rlock){+.+...}, at: [<ffffffff812a94bc>] drm_mm_put_block+0x10e/0x142
> [  123.551253] 
> [  123.551253] and this task is already holding:
> [  123.551253]  (&(&dev_priv->context_switch_lock)->rlock){-.....}, at: [<ffffffff812bdbab>] nouveau_channel_free+0x10f/0x233
> [  123.551253] which would create a new lock dependency:
> [  123.551253]  (&(&dev_priv->context_switch_lock)->rlock){-.....} -> (&(&mm->unused_lock)->rlock){+.+...}
> [  123.551253] 

It's only theoritcal issue. If you want to quiet it down until it will be "fixed" properly, you can
apply patch from http://lists.freedesktop.org/archives/nouveau/2010-July/005994.html

Marcin

