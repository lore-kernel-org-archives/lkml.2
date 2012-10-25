Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965507Ab2JYJbP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 05:31:15 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:13057 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935050Ab2JYJbO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 05:31:14 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/ll387qFkE=
X-RZG-CLASS-ID: mo00
Date: Thu, 25 Oct 2012 11:31:10 +0200
From: Olaf Hering <olaf@aepfle.de>
To: Jan Beulich <JBeulich@suse.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [Xen-devel] [PATCH] xen PVonHVM: move shared_info to reserved
 memory area
Message-ID: <20121025093110.GA29278@aepfle.de>
References: <1351155873-26500-1-git-send-email-olaf@aepfle.de>
 <5089202E02000078000A45E7@nat28.tlf.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5089202E02000078000A45E7@nat28.tlf.novell.com>
User-Agent: Mutt/1.5.21.rev5555 (2012-07-20)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 25, Jan Beulich wrote:

> >>> On 25.10.12 at 11:04, Olaf Hering <olaf@aepfle.de> wrote:
> > @@ -1495,38 +1494,53 @@ asmlinkage void __init xen_start_kernel(void)
> >  #endif
> >  }
> >  
> > -void __ref xen_hvm_init_shared_info(void)
> 
> Was the __ref here in fact unnecessary (i.e. did you check that
> its removal doesn't cause any section mismatch warnings)?

It does not cause any warnings for me.

> > +static void xen_hvm_set_shared_info(struct shared_info *sip)
> 
> With its sole caller being __init, this should also be __init.

Thanks, I will respin the patch with this change.

Olaf
