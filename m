Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753259Ab0CQGJI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 02:09:08 -0400
Received: from mga10.intel.com ([192.55.52.92]:51272 "EHLO
	fmsmga102.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752798Ab0CQGJG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 02:09:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.49,655,1262592000"; 
   d="scan'208";a="781469460"
Subject: Re: [PATCH] drivers/net/wimax/i2400m/fw.c fix possible double free
From: Inaky Perez-Gonzalez <inaky@linux.intel.com>
To: David Miller <davem@davemloft.net>
Cc: darrenrjenkins@gmail.com, cindy.h.kao@intel.com, wimax@linuxwimax.org,
       netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-wimax@intel.com
In-Reply-To: <20100316.141445.27416807.davem@davemloft.net>
References: <1268739988.17270.8.camel@ICE-BOX>
	 <20100316.141445.27416807.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 16 Mar 2010 23:05:47 -0700
Message-ID: <1268805947.2310.1.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 (2.28.2-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-03-16 at 14:14 -0700, David Miller wrote: 
> From: Darren Jenkins <darrenrjenkins@gmail.com>
> Date: Tue, 16 Mar 2010 22:46:28 +1100
> 
> > i2400m_fw_check() can free i2400m->fw_hdrs if krealloc() fails causing a double free
> > Add a check so we don't free the memory a second time.
> > 
> > coverity CID: 13455
> > 
> > Signed-off-by: Darren Jenkins <darrenrjenkins@gmail.com>
> 
> Please don't fix it like this, the check is obscure and it's
> allowing other bugs to happen.
> 
> If krealloc() fails, any refrence to i2400m->fw_hdrs is
> referencing freed memory.
> 
> Therefore the krealloc() failure handling in this driver should NULL
> out i2400m->fw_hdrs and that will fix the double kfree problem as well
> as trap any stray references.

I agree with David, the fix is quite obscure. The error path in
i2400m_fw_check()'s call to i2400m_kzrealloc_2x() should be rather
cleaning up in a better way.






