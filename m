Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754196Ab2HALmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 07:42:35 -0400
Received: from hedwig.cmf.nrl.navy.mil ([134.207.12.162]:41595 "EHLO
	hedwig.cmf.nrl.navy.mil" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab2HALmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 07:42:33 -0400
X-Greylist: delayed 1143 seconds by postgrey-1.27 at vger.kernel.org; Wed, 01 Aug 2012 07:42:33 EDT
Date: Wed, 1 Aug 2012 07:22:47 -0400
From: chas williams - CONTRACTOR <chas@cmf.nrl.navy.mil>
To: Shea Levy <shea@shealevy.com>
Cc: netdev@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Build failure when installing atm ambassador firmware
Message-ID: <20120801072247.589c7162@thirdoffive.cmf.nrl.navy.mil>
In-Reply-To: <50188D89.3040404@shealevy.com>
References: <50188D89.3040404@shealevy.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-NRLCMF-Spam-Score: () hits=-1.011
X-NRLCMF-Virus-Scanned: No virus found
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 31 Jul 2012 21:59:37 -0400
Shea Levy <shea@shealevy.com> wrote:

> Hello,
> 
> When building with 
> MODLIB=/nix/store/ghx6s9hnk9irim7c7f63zrxqiv6xjh3w-linux-3.5/lib/modules/3.5.0 
> and 
> ="/nix/store/ghx6s9hnk9irim7c7f63zrxqiv6xjh3w-linux-3.5/lib/firmware", 
> building Linux 3.5 with CONFIG_ATM_AMBASSADOR=m fails with:
> 
> "make[2]: *** No rule to make target 
> `"/nix/store/ghx6s9hnk9irim7c7f63zrxqiv6xjh3w-linux-3.5/lib/firmware"/./', 
> needed by 
> `"/nix/store/ghx6s9hnk9irim7c7f63zrxqiv6xjh3w-linux-3.5/lib/firmware"/atmsar11.fw'.  
> Stop."

i think it might be trying to tell you that the target directory
$INSTALL_FW_PATH doesn't exist and is a prerequisite to actually
perform the action.

it complains about atmsar11.fw first because it just happens to be the
first firmware that needs to be installed.

/scratch/chas/net-next relax.53% ls -ld /tmp/funk
ls: cannot access /tmp/funk: No such file or directory
/scratch/chas/net-next relax.54% make INSTALL_FW_PATH="/tmp/funk" firmware_install
make[1]: *** No rule to make target `/tmp/funk/./', needed by `/tmp/funk/atmsar11.fw'.  Stop.
make: *** [firmware_install] Error 2
/scratch/chas/net-next relax.55% mkdir /tmp/funk
/scratch/chas/net-next relax.56% make INSTALL_FW_PATH="/tmp/funk" firmware_install
  INSTALL /tmp/funk/atmsar11.fw
  MKDIR   /tmp/funk/e100/
  INSTALL /tmp/funk/e100/d101m_ucode.bin
  INSTALL /tmp/funk/e100/d101s_ucode.bin
  INSTALL /tmp/funk/e100/d102e_ucode.bin
...

i am somewhat concerned that it appears to have an extra set of "'s in
the path as well.  how are you passing in INSTALL_FW_PATH?  i can get
the same result with:

/scratch/chas/net-next relax.57% make 'INSTALL_FW_PATH="/tmp/funk"' firmware_install
make[1]: *** No rule to make target `"/tmp/funk"/./', needed by `"/tmp/funk"/atmsar11.fw'.  Stop.
make: *** [firmware_install] Error 2

but it would be wrong to do it this way.
