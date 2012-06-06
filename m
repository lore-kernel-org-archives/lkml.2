Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752238Ab2FFFok (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 01:44:40 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:64535 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750764Ab2FFFoi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 01:44:38 -0400
MIME-Version: 1.0
X-Originating-IP: [93.172.31.133]
In-Reply-To: <4FCECD8F.8000600@codeaurora.org>
References: <1337687472-23009-1-git-send-email-ohad@wizery.com>
 <4FBDFC4A.1060602@codeaurora.org> <CAK=WgbaP5qSso_Eu=Oup4eqLDcorZ-qf=mysMKiEvOS=m7yLmg@mail.gmail.com>
 <4FCD276A.80505@codeaurora.org> <CAK=WgbZo-8GXY9bVYGk0XZvqKrdaJZWeNkK1FhRWnH5doGYLjA@mail.gmail.com>
 <4FCECD8F.8000600@codeaurora.org>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Wed, 6 Jun 2012 08:44:17 +0300
Message-ID: <CAK=WgbakMG5eoSGP3GDFLFjA=z5fc_h_oFdzuC4tL5PcpCdLZA@mail.gmail.com>
Subject: Re: [PATCH] remoteproc: block premature rproc booting
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Fernando Guzman Lugo <fernando.lugo@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 6:25 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> What if I don't want to boot the device at kernel start-up? Do I have to
> make it a module then?

Currently, yeah.

But we can change stuff if needed.

We took that design decision because it was simple and we didn't have
any reason not to do it, but I'm thinking we can let the users decide
about this using runtime pm (e.g. calling pm_runtime_get_sync with an
rpmsg device, which will then be propagated all the way up to the
remoteproc device and power it up).
