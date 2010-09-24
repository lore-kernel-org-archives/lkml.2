Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750979Ab0IXEbY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 00:31:24 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:48505 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750749Ab0IXEbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 00:31:24 -0400
X-Greylist: delayed 1031 seconds by postgrey-1.27 at vger.kernel.org; Fri, 24 Sep 2010 00:31:23 EDT
X-Originating-Ip: 216.16.235.2
Date: Fri, 24 Sep 2010 00:14:10 -0400
From: Chris Frey <cdfrey@foursquare.net>
To: linux-kernel@vger.kernel.org
Subject: ext3 filesystem corruption in user mode linux
Message-ID: <20100924041410.GA18040@foursquare.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm running a stock 2.6.35.4 kernel, on both the host and the guest.

For one test, I've loaded a stage3 gentoo system including portage,
created completely on the host, using dd, a 10gig sparse virtual disk,
mkfs.ext3, and the gentoo tarballs.  (I get fs corruption with Ubuntu
guests as well).

If I do some heavy CPU and disk work in the guest, something like this:

	# (cd /usr && tar cjf - portage) | tar xjf -
	# rm -rf portage

Then the filesystem corrupts itself, giving errors like the following
in dmesg, during the rm:

    EXT3-fs error (device ubda): ext3_lookup: deleted inode referenced: 51715

I've posted my kernel configs online here:

	Host: http://foursquare.net/kernel/host-config.txt
	UML:  http://foursquare.net/kernel/uml-config.txt

I'm not sure what the next debugging step should be.  I can test different
versions of UML kernels, or test patches, if more testing is needed.

Thanks,
- Chris

