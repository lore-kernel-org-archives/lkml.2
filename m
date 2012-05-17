Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762110Ab2EQPpQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 11:45:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:47782 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752248Ab2EQPpO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 11:45:14 -0400
MIME-Version: 1.0
X-Originating-IP: [46.116.86.177]
In-Reply-To: <81C3A93C17462B4BBD7E272753C10579232F20847B@EXDCVYMBSTM005.EQ1STM.local>
References: <1335388200-18504-1-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=WgbYisX2A-DHZy6-AhFFTR3QuxJ0OcVaz+JcpzJOwxT3eWA@mail.gmail.com> <81C3A93C17462B4BBD7E272753C10579232F20847B@EXDCVYMBSTM005.EQ1STM.local>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 17 May 2012 18:44:53 +0300
Message-ID: <CAK=WgbY8RpOfZT5qNtFKOHoE5TD9s7JeqGvXadaXoZ6a7m0r4Q@mail.gmail.com>
Subject: Re: Remoteproc adaptations for ST-Ericsson modems
To: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

Sorry for the late response. I wanted to play with a few of the stuff
you mentioned, but some internal schedule prevented me from doing
that, and eventually I just decided not to wait anymore so we could at
least continue our discussion. so sorry again and thanks for your
patience.

On Tue, May 8, 2012 at 4:26 PM, Sjur BRENDELAND
<sjur.brandeland@stericsson.com> wrote:
> No, I trigger this warning by calling rproc_register() and rproc_boot()
> in sequence from a remoteproc client without using rpmsg.

Is this just testing code or a real driver you expect to merge ?

It sounds like we may have a race there, but the usage you describe is
somewhat non-standard and I don't think we really want to consider it
valid: usually we have a low level driver, responsible for the
platform-specific remoteproc implementation, which only calls
rproc_register() and not rproc_boot(), and a different, high-level
driver which triggers an rproc_boot() invocation when required by the
use case.

> 1. rproc-client does rproc_alloc() and rproc_register()
> 2. This trigger loading of firmware asynchronously.
> 3. Resource table is scanned for virtio device and virtio device
>   are registered.
> 4. Registration cause probing of rpmsg virtio driver

Yes, and it may also cause probing of any other virtio driver whose
device was just registered by remoteproc.

> >> I think it would be nice to be able to turn this feature off.
> >
> > Care to explain why ? what exactly do you want to do that you can't
> > today ?
>
> The difference is that I am not planning to call rproc_boot()
> from rpmsg, but trigger booting from user space using sysfs.

What's the bigger design picture you have in mind ? No kernel drivers at all ?
How do you plan to support recovery from crashes of the remote
processor (i.e. who notifies user space that something bad happened) ?

After we'll understand the bigger picture, we could surely come up
with the technical solution.

Thanks!
Ohad.
