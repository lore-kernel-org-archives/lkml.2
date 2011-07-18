Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1GRFRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 01:17:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:57059 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405Ab1GRFRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 01:17:38 -0400
Date: Mon, 18 Jul 2011 06:17:37 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@redhat.com>
Subject: Re: linux-next: build warning after merge of the vfs tree
Message-ID: <20110718051736.GY11013@ZenIV.linux.org.uk>
References: <20110718150456.d0eea458aab56fd1488ccc39@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110718150456.d0eea458aab56fd1488ccc39@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 18, 2011 at 03:04:56PM +1000, Stephen Rothwell wrote:
> Hi Al,
> 
> After merging the vfs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
> 
> drivers/char/ps3flash.c:347:2: warning: initialization from incompatible pointer type
> 
> Introduced by commit 62ec115d5b9c ("fs: push i_mutex and
> filemap_write_and_wait down into ->fsync() handlers").

Argh...  There had been several places where ->fsync() change hadn't been
done in the original patch; I've patched them up, but forgot to change the
prototype in this one ;-/

s/file,/& loff_t start, loff_t end,/ in the obvious place; I'll push the
updated variant in a few.
