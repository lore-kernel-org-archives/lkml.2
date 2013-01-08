Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab3AHQJb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 11:09:31 -0500
Received: from mail-da0-f43.google.com ([209.85.210.43]:58824 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755213Ab3AHQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 11:09:29 -0500
Message-ID: <50EC44B5.6020605@lwfinger.net>
Date: Tue, 08 Jan 2013 10:09:25 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Sujith Manoharan <sujith@msujith.org>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Stable <stable@vger.kernel.org>,
        "Luis R. Rodriguez" <mcgrof@qca.qualcomm.com>,
        Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
        Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
        ath9k-devel@lists.ath9k.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath9k_htc: Fix skb leaks
References: <1357098567-8558-1-git-send-email-Larry.Finger@lwfinger.net> <20707.47067.474241.813195@gargle.gargle.HOWL> <50E3BE23.3010102@lwfinger.net> <20707.50445.510814.481023@gargle.gargle.HOWL>
In-Reply-To: <20707.50445.510814.481023@gargle.gargle.HOWL>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/2013 11:26 PM, Sujith Manoharan wrote:
> Larry Finger wrote:
>> My only counter argument is that none of the other paths that get to
>> ath9k_htc_txcompletion_cb() leak the skb. It only happens for the path that goes
>> through htc_connect_service().
>
> Sure, but the TX completion handler would be invoked for every skb that is passed
> to the USB layer, including the ones that are allocated in htc_hst.c. When this
> skb goes down to hif_usb.c, a URB is allocated and I am not sure how freeing
> the skb before the USB layer invokes the completion handler for the URB is correct.
>
> I'll come up with a patch and see if kmemleak still complains.

Did I miss your posting on this issue?

Larry


