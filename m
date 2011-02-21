Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1BUGq4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 01:46:56 -0500
Received: from smtp-out.google.com ([74.125.121.67]:53006 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752276Ab1BUGqy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 01:46:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=gQpKstCUi8ofQV8512uk74zSHDw8FP0ovXLKcWUyElLyENqlD8AAz14iJloj85nfNu
         mMMNAdEja8keClohL30g==
MIME-Version: 1.0
In-Reply-To: <AANLkTimk5boeykToWCrosa5Q+Di5_uiOEU8tqh-aa0SE@mail.gmail.com>
References: <1298154371-5641-1-git-send-email-ccross@android.com>
	<1298154371-5641-4-git-send-email-ccross@android.com>
	<AANLkTimk5boeykToWCrosa5Q+Di5_uiOEU8tqh-aa0SE@mail.gmail.com>
Date: Sun, 20 Feb 2011 22:46:51 -0800
X-Google-Sender-Auth: 7YhbEuY1k46Khazh7dNGO1smgw0
Message-ID: <AANLkTim_y3cjWjHua0wc9pMvBNPMQNyamOyKgL92i3Vs@mail.gmail.com>
Subject: Re: [PATCH v2 02/21] ARM: tegra: clock: Don't BUG on changing an
 enabled PLL
From: Colin Cross <ccross@android.com>
To: Olof Johansson <olof@lixom.net>
Cc: linux-tegra@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        konkers@android.com, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 20, 2011 at 8:06 PM, Olof Johansson <olof@lixom.net> wrote:
> On Sat, Feb 19, 2011 at 2:25 PM, Colin Cross <ccross@android.com> wrote:
>> Signed-off-by: Colin Cross <ccross@android.com>
>
> Please add a 1-line description of why bugging doesn't make sense.
>
> Patch itself:
>
> Acked-by: Olof Johansson <olof@lixom.net>
>

I will add:
When updating the CPU PLL frequency, keeping the PLL enabled avoids
ramping the PLL all the way down and back up again.  Remove the BUG_ON
in tegra2_pll_clk_set_rate to allow the rate to change while the PLL
is enabled.
