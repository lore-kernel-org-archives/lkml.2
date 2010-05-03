Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759536Ab0ECOy0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 10:54:26 -0400
Received: from kroah.org ([198.145.64.141]:53917 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759026Ab0ECOyY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 10:54:24 -0400
Date: Sun, 2 May 2010 19:59:28 -0700
From: Greg KH <greg@kroah.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       David Woodhouse <dwmw2@infradead.org>,
       Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: linux-next: build warnings after merge of the
 driver-core.current tree
Message-ID: <20100503025928.GA28102@kroah.com>
References: <20100503100137.a05c9098.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100503100137.a05c9098.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 03, 2010 at 10:01:37AM +1000, Stephen Rothwell wrote:
> Hi Greg,
> 
> After merging the driver-core.current tree, today's linux-next build (powerpc
> ppc64_defconfig and x86_64 allmodconfig) produced these warning:
> 
> drivers/pcmcia/ds.c: In function 'pcmcia_load_firmware':
> drivers/pcmcia/ds.c:761: warning: passing argument 1 of 'release_firmware' discards qualifiers from pointer target type
> include/linux/firmware.h:46: note: expected 'struct firmware *' but argument is of type 'const struct firmware *'
> drivers/net/cxgb3/cxgb3_main.c: In function 't3_get_edc_fw':
> drivers/net/cxgb3/cxgb3_main.c:1084: warning: passing argument 1 of 'release_firmware' discards qualifiers from pointer target type
> include/linux/firmware.h:46: note: expected 'struct firmware *' but argument is of type 'const struct firmware *'
> 
> and *lots* more similar warnings ...
> 
> Caused by commit d5ae47f7d90f94a15e668f389c12211a11798b6f
> ("firmware_class: fix memory leak - free allocated pages").  This patch
> was modified from an earlier version that produced different (though many
> fewer) warnings.

Yeah, the people responsible were been notified last Friday, and they
sent me a patch today, hopefully it fixes the issue.  I'll test it out
tomorrow and merge it if it does.

thanks,

greg k-h
