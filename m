Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752328Ab1LUNE3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 08:04:29 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:52346 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751568Ab1LUNE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 08:04:28 -0500
Message-ID: <4EF1D97E.3000201@linaro.org>
Date: Wed, 21 Dec 2011 17:05:02 +0400
From: Dmitry Antipov <dmitry.antipov@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Sujit Reddy Thumma <sthumma@codeaurora.org>
CC: linaro-dev@lists.linaro.org, patches@linaro.org, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: use usleep_range() in mmc_delay()
References: <4EF18310.6080801@linaro.org> <4EF1C230.6060005@codeaurora.org>
In-Reply-To: <4EF1C230.6060005@codeaurora.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/21/2011 03:25 PM, Sujit Reddy Thumma wrote:

> I have posted similar patch some time back.
> http://comments.gmane.org/gmane.linux.ports.arm.msm/2119.
>
> Would you like to comment on that?

- I believe we should forget about jiffies, HZ and other similar obsolete
   timekeeping stuff;

- I have no ideas where did you get 'most typical' 20 ms. MMC subsystem uses
   mmc_delay() with two compile-time fixed values 1 and 10 ms, with the only
   exception of card-dependent sleep/awake timeout. I was unable to find a table
   with typical values, but it's rounded up to >= 1 ms anyway.

Dmitry
