Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753556Ab2FFDZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 23:25:07 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29664 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2FFDZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 23:25:05 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6733"; a="195832986"
Message-ID: <4FCECD8F.8000600@codeaurora.org>
Date: Tue, 05 Jun 2012 20:25:03 -0700
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] remoteproc: block premature rproc booting
References: <1337687472-23009-1-git-send-email-ohad@wizery.com> <4FBDFC4A.1060602@codeaurora.org> <CAK=WgbaP5qSso_Eu=Oup4eqLDcorZ-qf=mysMKiEvOS=m7yLmg@mail.gmail.com> <4FCD276A.80505@codeaurora.org> <CAK=WgbZo-8GXY9bVYGk0XZvqKrdaJZWeNkK1FhRWnH5doGYLjA@mail.gmail.com>
In-Reply-To: <CAK=WgbZo-8GXY9bVYGk0XZvqKrdaJZWeNkK1FhRWnH5doGYLjA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/12 03:57, Ohad Ben-Cohen wrote:
> What about using a separate file for the resource table ?
>
> That should be very easy to support, and may make life easier for you
> in the long term.
>
> Resource tables tend to change in time, and hard coding it in the
> kernel doesn't sound ideal (both in terms of development overhead, and
> kernel-firmware backward and forward compatibility).

Thanks. I'll look into that as that seems feasible.

> Does the below work for you (sans the OMAP terminology ;) ?
>
> root@omap4430-panda:/sys/bus/platform/drivers/omap-rproc# echo
> omap-rproc.1 > unbind
> [  471.376556] remoteproc remoteproc0: releasing ipu_c0
> root@omap4430-panda:/sys/bus/platform/drivers/omap-rproc# echo
> omap-rproc.1 > bind
> [  478.219177] remoteproc remoteproc0: ipu_c0 is available
> [  478.224639] remoteproc remoteproc0: Note: remoteproc is still under
> development and considered experimental.
> [  478.235015] remoteproc remoteproc0: THE BINARY FORMAT IS NOT YET
> FINALIZED, and backward compatibility isn't yet guaranteed.
> [  478.325347] remoteproc remoteproc0: registered virtio0 (type 7)
> [  478.331848] remoteproc remoteproc0: registered virtio1 (type 3)
>
> This way user space can unbind a specific remote processor (which will
> also trigger unbinding the entire device hierarchy below it, i.e. all
> rpmsg/virtio devices).

This is great! I finally see how bind/unbind is useful.

What if I don't want to boot the device at kernel start-up? Do I have to
make it a module then?

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

