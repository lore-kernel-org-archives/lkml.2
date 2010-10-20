Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752601Ab0JTIsC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:48:02 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34887 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752048Ab0JTIr6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:47:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=yEeLMiUiynDuGd7d+vFpsg0IPvOumBiF1NX+CQAqdNkfbAkDSDLwQ/R6IDW75m1LWP
         roeiZkk4SaJf2mrvBLEoptulPBebXDyF4Jnr65AxDWXOl6m7q1IOtQD7Llluxwkm9htZ
         5wdgxkz3eCwX1304Ghx2dKLLOKAzQD8vgHQQU=
MIME-Version: 1.0
In-Reply-To: <87fww1u3fw.fsf@deeprootsystems.com>
References: <1287482608-11320-1-git-send-email-felipe.contreras@gmail.com>
	<1287482608-11320-4-git-send-email-felipe.contreras@gmail.com>
	<20101019103234.GI31170@legolas.emea.dhcp.ti.com>
	<AANLkTinXzMQXoyyu+anSCvSuE9w3FWAP5HswDS0kfpzE@mail.gmail.com>
	<20101019111613.GJ31170@legolas.emea.dhcp.ti.com>
	<AANLkTikkMphKa2DGGtWxy-3LpFX0kn92UEYPj==Euzok@mail.gmail.com>
	<20101019115236.GL31170@legolas.emea.dhcp.ti.com>
	<AANLkTim3NsgjC3Nh8VCCrx4cV1Y+kn38=30=en0KCft6@mail.gmail.com>
	<6ea089ac75d4d15d88698468eacb7fe3@secure211.sgcpanel.com>
	<AANLkTinYM5aavk9_jcTTymff=OY+Yyv8T6C+dmMih0p_@mail.gmail.com>
	<20101019234414.GB30991@atomide.com>
	<87fww1u3fw.fsf@deeprootsystems.com>
Date: Wed, 20 Oct 2010 11:47:56 +0300
Message-ID: <AANLkTikd1v1RwHuU+mL4NoRcPuJQcjrOQUh_sXdQPC3Y@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] drivers: cleanup Kconfig stuff
From: "felipe.contreras@gmail.com" <felipe.contreras@gmail.com>
To: Kevin Hilman <khilman@deeprootsystems.com>
Cc: Tony Lindgren <tony@atomide.com>, Felipe Balbi <me@felipebalbi.com>,
        balbi@ti.com, linux-usb@vger.kernel.org,
        linux-omap <linux-omap@vger.kernel.org>,
        linux-main <linux-kernel@vger.kernel.org>, Greg KH <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 20, 2010 at 3:13 AM, Kevin Hilman
<khilman@deeprootsystems.com> wrote:
> Tony Lindgren <tony@atomide.com> writes:
>> So if you have something that's needed on almost every omap,
>> you can select it there.
>
> One thing I don't like about this is that there is currently no way to
> 'select' as a module.
>
> In order to get to a minimal kernel, in theory, we don't need regulator,
> i2c, MFD, or twl4030* built in.  They should all be built as modules.
> Yes, there are some assumptions made today that some of these things are
> built in, and then are used from init code, but that is broken.
>
> If someone is looking for a good omap-kernel-janitors project, I would
> suggest getting to a *really* minimal OMAP2+ kernel with everything
> possible built as modules to be a very good project.

Yes, one use-case would be to select things as modules by default only
if ARCH_OMAP2PLUS_TYPICAL is selected.

But not everyone needs many of these things, I expect to be able to do
ARCH_OMAP2PLUS_TYPICAL=n, and manually enable USB stuff
USB_MUSB_HDRC=y, without having to know the dependencies myself.

That was the idea: simplify the defconfigs so that they are truly
minimal (they boot), and then people can add whatever they need (like
USB).

-- 
Felipe Contreras
