Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab0ICNAM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 09:00:12 -0400
Received: from ch-smtp01.sth.basefarm.net ([80.76.149.212]:34231 "EHLO
	ch-smtp01.sth.basefarm.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752754Ab0ICNAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 09:00:10 -0400
Message-ID: <4C80F131.2020004@euromail.se>
Date: Fri, 03 Sep 2010 14:59:29 +0200
From: Henrik Rydberg <rydberg@euromail.se>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100820 Thunderbird/3.1.2
MIME-Version: 1.0
To: Ping Cheng <pingc@wacom.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] input: wacom: Add a quirk for lowres Bamboo devices
References: <1283516247-11624-1-git-send-email-rydberg@euromail.se> <1283516247-11624-6-git-send-email-rydberg@euromail.se> <6753EB6004AFF34FAA275742C104F952022BB10D@wacom-nt10.wacom.com>
In-Reply-To: <6753EB6004AFF34FAA275742C104F952022BB10D@wacom-nt10.wacom.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Originating-IP: 83.248.196.134
X-Scan-Result: No virus found in message 1OrVrf-0007lP-3V.
X-Scan-Signature: ch-smtp01.sth.basefarm.net 1OrVrf-0007lP-3V a44a373b32cda057d57b2094a6249a0b
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2010 02:47 PM, Ping Cheng wrote:
[...]
> +	/* quirks for bamboo touch */

> +	if (features->x_max == 480 && features->y_max == 320) {
>  
> A check on all Bamboo touch devices can be a generic way to cover all
> Bamboos with touch feature (4 models). This check can be based on the
> product id or features->type (== BAMBOO_PT) in combination with the
> actual type (pen/touch) of the device.  All Bamboo touch devices use the
> same protocol.


I guess the only one who knows if there will be other resolutions reported for
BAMBOO_PT is you. :-) I wanted to not break any eventual resolution improvements
in the BAMBOO_PT family, but if you say there aren't any, using the BAMBOO_PT
check will be better, as you say.


> +		features->x_max = 15360;
> +		features->y_max = 10240;
> 
> I guess these two numbers rely on the original maxes: (480, 320). If so,
> can we also make them generic by accessing features->x_max/y_max
> directly?


If you mean something like "features->x_max <<= 5", absolutely. Again, this all
depends on what resolutions are to be anticipated, and which ones should be
scaled this way.

Henrik
