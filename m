Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756491Ab2BHKWZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 05:22:25 -0500
Received: from smtp1-g21.free.fr ([212.27.42.1]:45110 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753867Ab2BHKWY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 05:22:24 -0500
Date: Wed, 8 Feb 2012 11:22:10 +0100
From: Anisse Astier <anisse@astier.eu>
To: Witold Baryluk <baryluk@smp.if.uj.edu.pl>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        linux-kernel@vger.kernel.org
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [BUG] NVMe: compilation error
Message-ID: <20120208112210.10f41e68@destiny.ordissimo>
In-Reply-To: <20120203142536.GL12978@smp.if.uj.edu.pl>
References: <20120203142536.GL12978@smp.if.uj.edu.pl>
Organization: Substantiel
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 3 Feb 2012 15:25:36 +0100, Witold Baryluk <baryluk@smp.if.uj.edu.pl> wrote :

> Hi,
> 
> when doing compiling I got
> 
>   CC [M]  drivers/block/nvme.o
> drivers/block/nvme.c: In function ‘nvme_configure_admin_queue’:
> drivers/block/nvme.c:999:2: error: implicit declaration of function ‘writeq’ [-Werror=implicit-function-declaration]
> drivers/block/nvme.c:1003:2: error: implicit declaration of function ‘readq’ [-Werror=implicit-function-declaration]
> cc1: some warnings being treated as errors

I'm having the same problem, my build is broken(3.3-rc2+), and I don't
use -Werror (gcc (Debian 4.4.5-8) 4.4.5):

  CC [M]  drivers/block/nvme.o
drivers/block/nvme.c: In function ‘nvme_configure_admin_queue’:
drivers/block/nvme.c:999: error: implicit declaration of function ‘writeq’
drivers/block/nvme.c:1003: error: implicit declaration of function ‘readq’


>From a quick look at the code, writeq/readq are only defined for 64bits
builds, everywhere else it keeps being redefined (static definitons).

Regards,

Anisse
