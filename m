Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab0G0Rz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:55:58 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:43985 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751195Ab0G0Rz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:55:57 -0400
Message-ID: <4C4F1D9E.70007@cs.helsinki.fi>
Date: Tue, 27 Jul 2010 20:55:42 +0300
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: Hannes Reinecke <hare@suse.de>, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        "=?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?=" 
	<u.kleine-koenig@pengutronix.de>,
        "=?UTF-8?B?QW5kcsOpIEdvZGRhcmQgUm9zYQ==?=" <andre.goddard@gmail.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] aic7xxx: Remove OS utility wrappers
References: <1279102377-958-1-git-send-email-penberg@cs.helsinki.fi>	 <4C43F3DE.8000405@suse.de> <1280252404.2833.168.camel@mulgrave.site>
In-Reply-To: <1280252404.2833.168.camel@mulgrave.site>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley wrote:
> On Mon, 2010-07-19 at 08:42 +0200, Hannes Reinecke wrote:
>> Pekka Enberg wrote:
>>> This patch removes malloc(), free(), and printf() wrappers from the aic7xxx
>>> SCSI driver. I didn't use pr_debug for printf because of some 'clever' uses of
>>> printf don't compile with the pr_debug. I didn't fix the overeager uses of
>>> GFP_ATOMIC either because I wanted to keep this patch as simple as possible.
>>>
>>> Cc: Hannes Reinecke <hare@suse.de>
>>> Cc: "James E.J. Bottomley" <James.Bottomley@suse.de>
>>> Cc: Jiri Kosina <jkosina@suse.cz>
>>> Cc: "Uwe Kleine-König" <u.kleine-koenig@pengutronix.de>
>>> Cc: "André Goddard Rosa" <andre.goddard@gmail.com>
>>> Cc: <linux-scsi@vger.kernel.org>
>>> Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
>> Thanks for the work. Long overdue.
>>
>> Acked-by: Hannes Reinecke <hare@suse.de>
> 
> A good rule of thumb is compile before acking:
> 
> drivers/scsi/aic7xxx/aic7770.c: In function 'aic7770_config':
> drivers/scsi/aic7xxx/aic7770.c:224: error: implicit declaration of function 'free'
> drivers/scsi/aic7xxx/aic7770.c:224: error: 'M_DEVBUF' undeclared (first use in this function)
> drivers/scsi/aic7xxx/aic7770.c:224: error: (Each undeclared identifier is reported only once
> drivers/scsi/aic7xxx/aic7770.c:224: error: for each function it appears in.)
> make[3]: *** [drivers/scsi/aic7xxx/aic7770.o] Error 1
> 
> It looks like a lone missed conversion, so I fixed it up.

Sorry about that, I thought I tested all the configurations. Thanks for 
fixing it up!

			Pekka
