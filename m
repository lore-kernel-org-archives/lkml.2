Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757871Ab0KOQDW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Nov 2010 11:03:22 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:45935 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756897Ab0KOQDV (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 15 Nov 2010 11:03:21 -0500
Date: Mon, 15 Nov 2010 11:02:45 -0500
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Xen-devel <xen-devel@lists.xensource.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/3] xen/microcode: partially enable even for
 non-privileged kernels
Message-ID: <20101115160245.GD345@dumpdata.com>
References: <cover.1289519130.git.jeremy.fitzhardinge@citrix.com>
 <049ad0809c51dedebab0b8e4bfcf58f5f26375b7.1289519130.git.jeremy.fitzhardinge@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <049ad0809c51dedebab0b8e4bfcf58f5f26375b7.1289519130.git.jeremy.fitzhardinge@citrix.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 11, 2010 at 03:58:06PM -0800, Jeremy Fitzhardinge wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
> 
> Don't attempt to load microcode on non-privileged kernels.  Kernels

The previous patch had this:

 if (!xen_initial_domain())
+               return NULL;

which pretty much made non-priviliged kernels not do any micro code loading.

It sounds like this patch is just to not compile the Xen microcode code
if CONFIG_DOM0 is not enabled?

> compiled without privileged support just get vestigial Xen detection
> to skip loading altogether; kernels with privileged support will
> load microcode if running privileged.  In either case, the normal
> Intel/AMD microcode loader is skipped under Xen.
