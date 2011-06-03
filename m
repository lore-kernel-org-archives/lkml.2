Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab1FCMoh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 08:44:37 -0400
Received: from ffm.saftware.de ([83.141.3.46]:39452 "EHLO ffm.saftware.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751172Ab1FCMof (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 08:44:35 -0400
Message-ID: <4DE8D72E.7010300@linuxtv.org>
Date: Fri, 03 Jun 2011 14:44:30 +0200
From: Andreas Oberritter <obi@linuxtv.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Hans Petter Selasky <hselasky@c2i.net>,
        "linux-media@vger.kernel.org" <linux-media@vger.kernel.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] FE_GET_PROPERTY should be _IOW, because the associated
 structure is transferred from userspace to kernelspace. Keep the old ioctl
 around for compatibility so that existing code is not broken.
References: <201105231558.13084.hselasky@c2i.net> <4DDA711E.3030301@linuxtv.org> <201105231651.55945.hselasky@c2i.net> <4DDA7E07.7070907@linuxtv.org> <4DE6ABF5.6020008@redhat.com>
In-Reply-To: <4DE6ABF5.6020008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/01/2011 11:15 PM, Mauro Carvalho Chehab wrote:
> The dvb_usercopy will do the right thing, if we use _IOR or _IORW.

It only works, because _IOC_READ triggers a copy_from_user, as a
workaround for wrongly marked ioctls like this, according to a code
comment. It does not really do the right thing, because in this special
case the later call to copy_to_user isn't required. But it doesn't do
any real harm either.

> I prefer to not apply this patch, as it won't fix anything. Adding an _OLD means
> that we'll need later to remove it, causing a regression. Ok, we may do like we did
> with V4L _OLD ioctl's that were marked as _OLD at 2.6.5 and were removed on a late
> 2.6.3x.

Either way is fine for me.

Regards,
Andreas
