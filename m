Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab0LNPIq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 10:08:46 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:33682 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543Ab0LNPIp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 10:08:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=K9q69CPRVXngUFVLe5mE9zYDimA9YUF+Hbi21W4L4tQPM1tCiPZS22RXzRsngAgZco
         iH/UdLOdduMLaVCIvMIwUjQIXUop7/gwbWxguJKgDtlQpPGg5obo3pXGpDnTD5x4nOiL
         +EYOmTeWKnZFoyWH/PAuOFmsBqFBqIdidi6E0=
MIME-Version: 1.0
In-Reply-To: <1292332047-8206-5-git-send-email-fernando.lugo@ti.com>
References: <1292332047-8206-1-git-send-email-fernando.lugo@ti.com>
	<1292332047-8206-5-git-send-email-fernando.lugo@ti.com>
Date: Tue, 14 Dec 2010 17:08:42 +0200
Message-ID: <AANLkTin0eBk1tMDUJQQ6KuM6eOu1gu+JmwY-Nz0V+jw8@mail.gmail.com>
Subject: Re: [PATCHv6 4/4] omap: iommu - create new api to set valid da range
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Fernando Guzman Lugo <fernando.lugo@ti.com>
Cc: Hiroshi.DOYU@nokia.com, linux@arm.linux.org.uk, h-kanigeri2@ti.com,
        felipe.contreras@nokia.com, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        tony@atomide.com, "Guzman Lugo, Fernando" <x0095840@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 14, 2010 at 3:07 PM, Fernando Guzman Lugo
<fernando.lugo@ti.com> wrote:
> From: Guzman Lugo, Fernando <x0095840@ti.com>
>
> Some IOMMUs cannot use the whole 0x0 - 0xFFFFFFFF rage.
> With this new API the valid range can be set.
>
> Signed-off-by: Fernando Guzman Lugo <x0095840@ti.com>
> Acked-by: Hiroshi DOYU <Hiroshi.DOYU@nokia.com>

I still don't see where this API is being used.

Also, the point of using platform data was to add it to omap3_devices
in omap-iommu.c, see[1]. I thought the platform data start/end would
move to struct iommu, and iommu_set_da_range would change the
start/end on struct iommu, but that would only be necessary if the
platform data doesn't match that.

If there's no sensible platform data default, then there's no point in
using platform data, as the platform is not the limiting factor, but
the DSP SW.

[1] http://article.gmane.org/gmane.linux.kernel/1051268

-- 
Felipe Contreras
