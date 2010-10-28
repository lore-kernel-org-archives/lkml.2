Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758520Ab0J1LU6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 07:20:58 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40269 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754222Ab0J1LU5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 07:20:57 -0400
Date: Thu, 28 Oct 2010 13:20:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Ian Campbell <Ian.Campbell@citrix.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH] x86: use pgd accessors when cloning a pgd range.
Message-ID: <20101028112052.GA21757@a1.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Ian Campbell <Ian.Campbell@citrix.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"H. Peter Anvin" <hpa@linux.intel.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"x86@kernel.org" <x86@kernel.org>
References: <1288169413-29065-1-git-send-email-ian.campbell@citrix.com>
 <20101027104020.GA16954@a1.tnic>
 <4CC85839.4000507@goop.org>
 <4CC85EE6.7030608@linux.intel.com>
 <4CC861F9.8080200@goop.org>
 <20101027174417.GA19194@a1.tnic>
 <1288202321.10179.102.camel@localhost.localdomain>
 <1288257797.8361.1545.camel@zakaz.uk.xensource.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1288257797.8361.1545.camel@zakaz.uk.xensource.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 10:23:17AM +0100, Ian Campbell wrote:
> Now tested and it works. Patch below.

I'm assuming you tested bare metal too?

> I'm also going to look into switching Xen to startup on
> initial_page_table, since I think the consistency with native would be
> useful from a principle of least surprise PoV. However the following
> is a useful stopgap if nothing else.

Sounds good. Then we can drop this temporary workaround.

> BTW, are there plans to unify 32 and 64 bit WRT the use of
> swapper_pg_dir vs initial_page_table?

To be honest, I thought about it but 64bit does the bootstrapping
differently. I'll look into it one fine day when there's time. (like
there ever is :))

> From: Ian Campbell <ian.campbell@citrix.com>
> Date: Thu, 28 Oct 2010 10:16:52 +0100
> Subject: [PATCH] x86/32: skip early initialisation of swapper_pg_dir if it is already current
> 
> In particular in the Xen PV case the Xen early startup code has
> already initialised swapper_pg_dir and switched to it. In this case
> initial_page_table is uninitialised since Xen has no use for it so
> copying it over swapper_pg_dir is not correct.
> 
> Signed-off-by: Ian Campbell <ian.campbell@citrix.com>
> Cc: Borislav Petkov <bp@alien8.de>
> Cc: H. Peter Anvin <hpa@linux.intel.com>
> Cc: Jeremy Fitzhardinge <jeremy@goop.org>

Acked-by: Borislav Petkov <bp@alien8.de>

-- 
Regards/Gruss,
Boris.
