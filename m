Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751975Ab1CZOJC (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 10:09:02 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53720 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751151Ab1CZOJB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 10:09:01 -0400
Subject: Re: [PATCH] regulator: fix tps6524x section mismatch
From: Liam Girdwood <lrg@slimlogic.co.uk>
To: Randy Dunlap <randy.dunlap@oracle.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Cyril Chemparathy <cyril@ti.com>, akpm <akpm@linux-foundation.org>
In-Reply-To: <20110324133059.eb17c442.randy.dunlap@oracle.com>
References: <20110324133059.eb17c442.randy.dunlap@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 26 Mar 2011 14:08:51 +0000
Message-ID: <1301148531.3455.48.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-03-24 at 13:30 -0700, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix section mismatch that is caused by init code calling exit code:
> pmic_remove() cannot be marked as __devexit.
> 
> WARNING: drivers/regulator/tps6524x-regulator.o(.devinit.text+0x205): Section mismatch in reference from the function pmic_probe() to the function .devexit.text:pmic_remove()
> The function __devinit pmic_probe() references
> a function __devexit pmic_remove().
> This is often seen when error handling in the init function
> uses functionality in the exit path.
> The fix is often to remove the __devexit annotation of
> pmic_remove() so it may be used outside an exit section.
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
> Cc:	Liam Girdwood <lrg@slimlogic.co.uk>
> Cc:	Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc:	Cyril Chemparathy <cyril@ti.com>
> ---
>  drivers/regulator/tps6524x-regulator.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Applied.
Thanks

Liam

