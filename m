Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755119Ab2LFPRh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Dec 2012 10:17:37 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:49342 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754470Ab2LFPRg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Dec 2012 10:17:36 -0500
Message-ID: <50C0B704.5050808@ahsoftware.de>
Date: Thu, 06 Dec 2012 16:17:24 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: =?UTF-8?B?TG90aGFyIFdhw59tYW5u?= <LW@KARO-electronics.de>
CC: Alessandro Zummo <a.zummo@towertech.it>, rtc-linux@googlegroups.com,
        linux-kernel@vger.kernel.org
Subject: Re: [BUGFIX PATCH] rtc: eliminate extra call of ida_simple_remove()
References: <1354721131-31177-1-git-send-email-LW@KARO-electronics.de>
In-Reply-To: <1354721131-31177-1-git-send-email-LW@KARO-electronics.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 05.12.2012 16:25, schrieb Lothar Waßmann:
> Unbinding an RTC chip driver from its device leads to the error
> message:
> |ida_remove called for id=0 which is not allocated.
>
> This is caused by a redundant call to ida_simple_remove() in
> rtc_device_unregister().
> Eliminate the call in rtc_device_unregister() and only call the
> function in rtc_device_release().
>
> Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>

I've just discovered the same problem. Although I've removed the call to
ida_simple_remove() in rtc_device_release() (for symmetry of 
register/unregister) I can offer a

Signed-off-by: Alexander Holler

A

Cc: <stable@vger.kernel.org>

might make sense, but it should just remove a warning, so I don't know 
if that qualifies for the stable series.

Regards,

Alexander


