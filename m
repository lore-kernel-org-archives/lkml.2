Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab1BVUOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 15:14:35 -0500
Received: from mail02do.versatel.de ([89.245.129.22]:54822 "EHLO
	mail02do.versatel.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751722Ab1BVUOc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 15:14:32 -0500
Message-ID: <4D641936.90404@versanet.de>
Date: Tue, 22 Feb 2011 21:14:46 +0100
From: "pantherchen@versanet.de" <pantherchen@versanet.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110208 Thunderbird/3.1.8
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Boot time regression in 2.6.38 after initial wq merge
References: <4D62CE9C.7090806@versanet.de> <20110222081752.GP31267@htj.dyndns.org> <20110222085223.GC11681@core.coreip.homeip.net> <20110222090255.GR31267@htj.dyndns.org> <B04A0050-5AE7-4072-BE6F-279E24B0DA64@gmail.com> <4D63D062.3040404@versanet.de> <20110222172254.GA13114@core.coreip.homeip.net> <20110222175955.GA27991@core.coreip.homeip.net> <4D640F67.3040109@versanet.de> <20110222195257.GA13256@core.coreip.homeip.net>
In-Reply-To: <20110222195257.GA13256@core.coreip.homeip.net>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 08:52 PM, Dmitry Torokhov wrote:
> Ewww... tty/ldisc...
>
> Does it help if you change drivers/input/serio/serio.c::serio_queue_event()
> from calling
>
> 	schedule_work(&serio_event_work);
>
> to call
>
> 	queue_work(system_long_wq,&serio_event_work);
>
> ?

Yes, that works: http://img.xrmb2.net/images/499337.png

Regards,

Hernando Torque
