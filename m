Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932941Ab1EWTRq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 15:17:46 -0400
Received: from www.linutronix.de ([62.245.132.108]:56972 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932903Ab1EWTRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 15:17:43 -0400
Date: Mon, 23 May 2011 21:17:39 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: KY Srinivasan <kys@microsoft.com>
cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
        "hch@infradead.org" <hch@infradead.org>,
        Hank Janssen <hjanssen@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: RE: [PATCH 1/1] Clocksource: Move the Hyper-V clocksource driver
 out of staging
In-Reply-To: <6E21E5352C11B742B20C142EB499E0481FC8D4@TK5EX14MBXC122.redmond.corp.microsoft.com>
Message-ID: <alpine.LFD.2.02.1105232116140.3078@ionos>
References: <1306170743-17797-1-git-send-email-kys@microsoft.com> <alpine.LFD.2.02.1105232010470.3078@ionos> <6E21E5352C11B742B20C142EB499E0481FC8D4@TK5EX14MBXC122.redmond.corp.microsoft.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 May 2011, KY Srinivasan wrote:
> > > +module_init(init_hv_clocksource);
> > > +MODULE_DESCRIPTION("HyperV based clocksource");
> > > +MODULE_AUTHOR("K. Y. Srinivasan <ksrinivasan@novell.com>");
> > > +MODULE_LICENSE("GPL");
> > 
> > Why do we need to build this as a module?
> 
> No particular reason. This is the way, I had it in the staging directory.
> Do you want me to build this as part of the kernel? I would then not have
> to worry about auto-loading issues.

If we get rid of the DMI/PCI stuff then the whole module code is
larger than the real code. So no point in building it modular, just
make it depend on CONFIG_WHATEVER_MEANS_HYPERV

Thanks,

	tglx
