Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756161Ab2GFGIo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 02:08:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43586 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751309Ab2GFGIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 02:08:42 -0400
Date: Fri, 6 Jul 2012 15:38:34 +0930
From: Alan Modra <amodra@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@bakeyournoodle.com
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20120706060834.GC5805@bubble.grove.modra.org>
References: <20120705183345.ee84ec1048a19aa1c7129578@canb.auug.org.au>
 <20120705094348.GA5805@bubble.grove.modra.org>
 <20120706102151.fd4f769cf2aa3f753ad178bf@canb.auug.org.au>
 <20120706005709.GB5805@bubble.grove.modra.org>
 <20120706130137.6aae96c0072af1f330249c0d@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706130137.6aae96c0072af1f330249c0d@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 01:01:37PM +1000, Stephen Rothwell wrote:
> solos-pci.c:(.text+0x1ff923c): relocation truncated to fit: R_PPC64_REL24
                     ^^^^^^^^^

> I assume at this point, we are just too large.

Yeah, but not in total.  I didn't see any of these in the allyes
kernel I built with our proof of concept hack to avoid ld -r.  I think
you'll find that these are all from ld -r output, as I assume no one
in kernel land writes drivers or whatever with 33M of text in a single
file.  Branches in that monstrous section can't even reach the
trampolines that ld inserts to extend branch reach.  Did I mention
that ld -r is a bad idea?

One workaround might be to compile with -ffunction-sections.

-- 
Alan Modra
Australia Development Lab, IBM
