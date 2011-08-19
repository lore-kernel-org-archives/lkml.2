Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752343Ab1HSHwV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 03:52:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:33786 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751150Ab1HSHwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 03:52:18 -0400
Message-ID: <4E4E1627.8010902@redhat.com>
Date: Fri, 19 Aug 2011 09:52:07 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110807 Thunderbird/5.0
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: device-mapper development <dm-devel@redhat.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        "David S. Miller" <davem@davemloft.net>, containers@lists.osdl.org
Subject: Re: clone() with CLONE_NEWNET breaks kobject_uevent_env()
References: <4E4CDF44.5080109@redhat.com>
In-Reply-To: <4E4CDF44.5080109@redhat.com>
X-Enigmail-Version: 1.2.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(added cc to containers list)

On 08/18/2011 11:45 AM, Milan Broz wrote:
> Hi,
> 
> after analysing very strange report (with running chromium
> some device-mapper ioctl functions started to fail) I found
> interesting problem:
> 
> If you run clone() with CLONE_NEWNET (which is chromium using
> for sanboxing), udev namespace is cloned too (newly registered
> in uevent_sock_list) and netlink send (except the first in list)
> fails with -ESRCH.
> 
> This causes that _every_ call of kobject_uevent_env() return failure.
> 
> Most of users silently ignores  kobject_uevent() return value,
> so the problem was invisible for long time.
> 
> Unfortunately dm checks return value and reports failure,
> taking the wrong error path.
> 
> How is this supposed to work?
> 
> Why cloning net namespace breaks the udev netlink subsystem?
> 
> Is it bug or we need to do something differently?
> (I do not think ignoring return value is the proper way...)

I forgot to explicitly mention that running clone with CLONE_NEWNET
causes kobject_uevent_env() to fail _outside_ of cloned namespace
(for all kernel users in fact).

(The former problem is described here
http://article.gmane.org/gmane.linux.kernel.device-mapper.dm-crypt/5256
but it is IMHO generic problem. Instrumenting  kobject_uevent() shows
that it returns send failure really to all events.)

Can anyone please explain this behavior?

Milan
