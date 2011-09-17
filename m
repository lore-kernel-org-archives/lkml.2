Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab1IQQvA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 12:51:00 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:48306 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751150Ab1IQQu6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 12:50:58 -0400
MIME-Version: 1.0
In-Reply-To: <4E74C6C3.2000704@gmx.de>
References: <1316088425.11294.78.camel@lappyti>
	<yunboul7sx7.fsf@aiko.keithp.com>
	<1316100594.23214.65.camel@deskari>
	<yun8vpp7qk7.fsf@aiko.keithp.com>
	<4E72320B.6020000@gmx.de>
	<CADnq5_NnzLtJmSzOgyppnBtv96DRTJ71u6ZSrs56KJ-F5CC-mw@mail.gmail.com>
	<4E724659.5080709@gmx.de>
	<20110915195804.4e6d965b@lxorguk.ukuu.org.uk>
	<CAMP44s1ywhCV+FaudnwjwJUvj5Cf3_oz1M++kjXxRDGQpJ6-0w@mail.gmail.com>
	<CAF6AEGu2-O+2KuCrQPJ6-xejg8TCScrFVZSimgkAV_5Xs-bgkg@mail.gmail.com>
	<4E74C6C3.2000704@gmx.de>
Date: Sat, 17 Sep 2011 11:50:57 -0500
X-Google-Sender-Auth: 6ZURYYFYxEN2_ElK7auqxYF6XTQ
Message-ID: <CAF6AEGuuv4sDJbwHpYGUUsX36gFBcfH_Pa+t57ifvwdON3PP-Q@mail.gmail.com>
Subject: Re: Proposal for a low-level Linux display framework
From: Rob Clark <rob@ti.com>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-fbdev@vger.kernel.org, linaro-dev@lists.linaro.org,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Archit Taneja <archit@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 17, 2011 at 11:11 AM, Florian Tobias Schandinat
<FlorianSchandinat@gmx.de> wrote:
> On 09/17/2011 03:16 PM, Rob Clark wrote:
>>>From userspace perspective, fbdev doesn't go away.  It is just a
>> legacy interface provided on top of DRM/KMS driver mostly via helper
>> functions.  With this approach, you get the richer KMS API (and all
>> the related plumbing for hotplug, EDID parsing, multi-head support,
>> flipping, etc) for userspace stuff that needs that, but can keep the
>> fbdev userspace interface for legacy apps.  It is the best of both
>> worlds.  There isn't really any good reason to propagate standalone
>> fbdev driver anymore.
>
> I disagree. This depends on the functionality the hardware has, the desired
> userspace and the manpower one has to do it. And of course if you just want fb
> having fb via DRM/KMS has some overhead/bloat. It's perfectly okay to have just
> an fb driver for devices that can't do more anyway.
> And fb is no legacy interface but actively developed, just with other goals than
> DRM/KMS is, it aims for stability and to provide a direct interface, not needing
> any X or wayland crap.

Hmm, for simple enough devices, maybe fb is fine.. but if you are
covering a range of devices which include stuff with more
sophisticated userspace (X/wayland), then just doing DRM/KMS and using
the DRM fbdev helpers, vs doing both DRM/KMS and standalone fbdev..
well that seems like a no-brainer.

I still think, if you are starting a new driver, you should just go
ahead and use DRM/KMS.. a simple DRM/KMS driver that doesn't support
all the features is not so complex, and going this route future-proofs
you better when future generations of hardware gain more capabilities
and sw gain more requirements.

BR,
-R

>
> Best regards,
>
> Florian Tobias Schandinat
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
