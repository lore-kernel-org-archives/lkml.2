Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757584Ab2EERwS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 13:52:18 -0400
Received: from [89.21.227.130] ([89.21.227.130]:42410 "EHLO
	mail.epsilon.itdev.co.uk" rhost-flags-FAIL-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756487Ab2EERwQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 13:52:16 -0400
X-Greylist: delayed 623 seconds by postgrey-1.27 at vger.kernel.org; Sat, 05 May 2012 13:52:16 EDT
Message-ID: <4FA5665D.80304@itdev.co.uk>
Date: Sat, 05 May 2012 18:41:49 +0100
From: Nick Dyer <nick.dyer@itdev.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Daniel Kurtz <djkurtz@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Henrik Rydberg <rydberg@euromail.se>,
        Joonyoung Shim <jy0922.shim@samsung.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org, Benson Leung <bleung@chromium.org>,
        Yufeng Shen <miletus@chromium.org>
Subject: Re: [PATCH 09/14 v3] Input: atmel_mxt_ts - refactor get info
References: <1334755319-21365-1-git-send-email-djkurtz@chromium.org> <1334755319-21365-10-git-send-email-djkurtz@chromium.org>
In-Reply-To: <1334755319-21365-10-git-send-email-djkurtz@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel-

Daniel Kurtz wrote:
> -	dev_info(&client->dev,
> -			"Family ID: %d Variant ID: %d Version: %d Build: %d\n",
> -			info->family_id, info->variant_id, info->version,
> -			info->build);
> +	dev_info(dev, "Family ID: %d Variant ID: %d Major.Minor.Build: %d.%d.%d\n",
> +		 info->family_id, info->variant_id, info->version >> 4,
> +		 info->version & 0xf, info->build);

The canonical format for the Atmel firmware versions has the build number
in hex, eg. 2.0.AA

So it should be %d.%d.%02X

cheers

Nick
