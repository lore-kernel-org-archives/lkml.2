Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752847Ab2GFA5T (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 20:57:19 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64910 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751094Ab2GFA5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 20:57:17 -0400
Date: Fri, 6 Jul 2012 10:27:10 +0930
From: Alan Modra <amodra@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        tony@bakeyournoodle.com
Subject: Re: linux-next: build failure after merge of the final tree
Message-ID: <20120706005709.GB5805@bubble.grove.modra.org>
References: <20120705183345.ee84ec1048a19aa1c7129578@canb.auug.org.au>
 <20120705094348.GA5805@bubble.grove.modra.org>
 <20120706102151.fd4f769cf2aa3f753ad178bf@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120706102151.fd4f769cf2aa3f753ad178bf@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 06, 2012 at 10:21:51AM +1000, Stephen Rothwell wrote:
> which have now been fixed.  So would a simple patch that puts the
> _savegpr etc functions in their own section (defined how?) fix this for
> us?

Ah, the kernel provides its own save/restore functions, and these get
mashed into a .text containing normal functions with toc references by
ld -r.  Well, you could stop using ld -r.  Otherwise, try

 .section ".text.save.restore","ax",@progbits

-- 
Alan Modra
Australia Development Lab, IBM
