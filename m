Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755010Ab2H0Xir (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:38:47 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:58467 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754322Ab2H0Xiq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:38:46 -0400
Message-ID: <503C04F9.5070808@xenotime.net>
Date: Mon, 27 Aug 2012 16:38:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Yang Bai <hamo.by@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Q: What will happen if I insmod a new version driver when it
 has already been statically in kernel?
References: <CAO_0yfNxa9m0BR-MxMezC-CZ8M=JkOmnLrpWyUcti-cT8f3zzA@mail.gmail.com>
In-Reply-To: <CAO_0yfNxa9m0BR-MxMezC-CZ8M=JkOmnLrpWyUcti-cT8f3zzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/27/2012 03:06 AM, Yang Bai wrote:

> Hi all,
> 
> We have one driver which has been statically compiled into kernel, and
> now we want to upgrade it. But we only have a new version module for
> this driver. Could I just insmod this module and make the new driver
> work?

No, that should not work -- unless the in-kernel driver has a
close/release method that you can somehow trigger.


> If so, what happens to the static old one?

It stays.

> If not, Can we upgrade this driver without re-compile the kernel to
> make the in-kernel driver out or module?


If the current driver is not a loadable module, you cannot
replace it.  Assuming that they use mostly the same resources,
like I/O devices or memory BARs or however the device presents
its control & data interfaces, the new module would not be
able to access the device interfaces since they would still
be used/owned by the in-kernel driver.



-- 
~Randy
