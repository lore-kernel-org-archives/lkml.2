Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755661Ab2BGHwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 02:52:44 -0500
Received: from mail.mnsspb.ru ([84.204.75.2]:50960 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751349Ab2BGHwn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 02:52:43 -0500
Date: Tue, 7 Feb 2012 11:55:53 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: No /dev/root with devtmpfs?
Message-ID: <20120207075553.GB8632@tugrik.mns.mnsspb.ru>
References: <20120206111853.GA11506@tugrik.mns.mnsspb.ru>
 <CAPXgP11N=8NULMH-o0Us0OuqYpP9sKe9uUKWzE35h1AiRP1Cjg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPXgP11N=8NULMH-o0Us0OuqYpP9sKe9uUKWzE35h1AiRP1Cjg@mail.gmail.com>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 06, 2012 at 08:45:24PM +0100, Kay Sievers wrote:
> On Mon, Feb 6, 2012 at 12:18, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> > Recently I've reworked my system not to use udev, but use devtmpfs
> > instead and discovered there is no /dev/root symlink in devtmpfs case.
> >
> > My setup uses /dev/root early to know what is the boot device and then
> > do some operations on it like checksumming, etc...
> >
> > Now when /dev/root is gone the best workaround I could come up with is
> > to   grep /proc/partitions for '[hs]d[a-z]1'  but it's ugly and will
> > break when there are several block devices attached.
> >
> > Is it somehow possible to add /dev/root to devtmpfs?
> 
> No, devtmpfs has no business in knowing anything about the rootfs or
> who mounted what ans where. I can not create such links.
> 
> The entire concept of /dev/root is flawed anyway, and nothing should
> really depend on that.
> 
> Modern filesystems will not offer a direct relation to a single block
> device, they allocate an superblock which has a major == 0, so there
> can be by definition never such a link. Better get rid of all uses of
> /dev/root, it will just fail in the future.

Kay, thanks for explanation.

Though now I'm confused about how to know on what "place" root
filesystem was mounted... To me the question makes sense, but you say
with modern filesystems there by definition is no answer (or did I
misunderstood you?) Strange...
