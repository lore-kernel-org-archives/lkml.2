Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753426Ab0HWIE3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 04:04:29 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:7200 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752955Ab0HWIE2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 04:04:28 -0400
X-Greylist: delayed 1337 seconds by postgrey-1.27 at vger.kernel.org; Mon, 23 Aug 2010 04:04:27 EDT
Message-ID: <4C72264A.3030302@parallels.com>
Date: Mon, 23 Aug 2010 11:42:02 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: ye janboe <janboe.ye@gmail.com>
CC: davem@davemloft.net, linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Is it possible for addrconf_init_net to kfree no-heap address?
References: <AANLkTinxVG=X-ncpF21kxh+XifUOtLHBfsP2FJ-Cgx6U@mail.gmail.com>
In-Reply-To: <AANLkTinxVG=X-ncpF21kxh+XifUOtLHBfsP2FJ-Cgx6U@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/19/2010 08:15 AM, ye janboe wrote:
> hi, Pavel and David
> 
> addrconf_init_net make me a little confused.
> 
> if all and dflt are not allocated by kmemdup and sysctl_register
> failed, this function will try to kfree dftl which points to
> ipv6_devconf_dfl which is not a heap address. AFAIK, kfree will panic
> if the address does not belong to slab page.
> 
> Is there any special reason for these codes?

This situation can only occur for the init namespace, i.e. early at host
boot so the sysctl registration will not fail for sure.

On the other hand, since the ipv6 can be built as module this code can be
executed later run-time ...

Can you send a fixing patch?

> many thanks!
> 

