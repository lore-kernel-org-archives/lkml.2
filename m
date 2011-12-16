Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759003Ab1LPKri (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 05:47:38 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42916 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756249Ab1LPKrb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 05:47:31 -0500
Message-ID: <4EEB2182.6040508@mvista.com>
Date: Fri, 16 Dec 2011 14:46:26 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Felipe Contreras <felipe.contreras@gmail.com>
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, stable@vger.kernel.org
Subject: Re: [PATCH] usb: musb: fix pm_runtime mismatch
References: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
In-Reply-To: <1323988934-11350-1-git-send-email-felipe.contreras@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 16-12-2011 2:42, Felipe Contreras wrote:

> In musb_init_controller() there's a pm_runtime_put(), but there's no
> pm_runtime_get(), which creates a mismatch that causes the driver to
> sleep when it shouldn't.

> This was introduced in 7acc619, but it wasn't triggered until 18a2689
> was merged to Linus' branch at point 6899608.

    Please also specify the summaries for the commits you're mentioning.

> However, it seems most of the time this is used in a way that keeps the
> counter above 0, so nobody noticed. Also, it seems to depend on the
> configuration used.

> I found the problem by loading isp1704_charger before any usb gadgets:
> http://article.gmane.org/gmane.linux.kernel/1226122

> All versions after 2.6.39 are affected.

> Cc: stable@vger.kernel.org
> Signed-off-by: Felipe Contreras<felipe.contreras@gmail.com>

WBR, Sergei
