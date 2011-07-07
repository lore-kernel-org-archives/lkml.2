Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755687Ab1GGPwW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:52:22 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:41994 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751748Ab1GGPwV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:52:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=a+Rp0vDAXftPzXup41oVA8xVdTBJeRpNQZUCqbxRAfGpcw2He+0XL355Jbb6MdiDiiR8jJsvR0IqtY67asKLRuDlkcWl6ua8QTe1QE5OE6YNf6QHM3cePUf4KqWfSb4k;
Date: Thu, 7 Jul 2011 08:52:05 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ram Pai <linuxram@us.ibm.com>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-ID: <20110707085205.7524a5a7@jbarnes-desktop>
In-Reply-To: <20110707105823.43343d2f9446f994f97cfd65@canb.auug.org.au>
References: <20110707105823.43343d2f9446f994f97cfd65@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011 10:58:23 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Jesse,
> 
> After merging the pci-current tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/built-in.o:(.toc1+0xb98): undefined reference to `pci_realloc'
> 
> Caused by commit 72007d2b4797 ("PCI: conditional resource-reallocation
> through kernel parameter pci=realloc").
> 
> I have used the pci-current tree from next-20110706 for today.

Oops, x86 bits used in common code.  I've pushed a fix that just moves
the variable into setup-bus.c rather than x86/pci/common.c.

Ram, did you see the microblaze patch I forwarded you?  It moves some
re-alloc control flags into common code; for -next it might be cleaner
to use them in a few places.  Any comments?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
