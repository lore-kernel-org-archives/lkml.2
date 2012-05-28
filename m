Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752248Ab2E1AaF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 20:30:05 -0400
Received: from mga09.intel.com ([134.134.136.24]:41527 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191Ab2E1AaD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 20:30:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="145235954"
Message-ID: <1338165058.14538.209.camel@ymzhang.sh.intel.com>
Subject: RE: [PATCH 1/2] printk: add interface for disabling recursion check
From: Yanmin Zhang <yanmin_zhang@linux.intel.com>
To: "Luck, Tony" <tony.luck@intel.com>
Cc: "Liu, ShuoX" <shuox.liu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        Ingo Molnar <mingo@elte.hu>
Date: Mon, 28 May 2012 08:30:58 +0800
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com>
References: <4FBC444A.6060500@intel.com>
	 <20120523100138.GA13506@x1.osrc.amd.com> <4FBDCE4A.7050900@intel.com>
	 <20120524061145.GA18284@liondog.tnic>
	 <20120524155611.b7aeff4d.akpm@linux-foundation.org>
	 <1337905811.14538.206.camel@ymzhang.sh.intel.com>
	 <4FBF3295.7090608@intel.com>
	 <3908561D78D1C84285E8C5FCA982C28F192F4D39@ORSMSX104.amr.corp.intel.com>
Organization: MCG
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-05-25 at 16:09 +0000, Luck, Tony wrote:
> +void printk_recursion_check_enable(void)
> +{
> +	atomic_dec(&recursion_check_disabled);
> +}
> 
> 
> Is it worth a BUG_ON() in here to check that recursion_check_disabled
> is >=1 before blindly decrementing it? Or is this interface so simple
> that nobody would ever get this wrong?
Tony,

The interface is clear and simple. But a WARN_ON checking is better
to have. We would add WARN_ON.

Thanks,
Yanmin


