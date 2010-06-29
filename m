Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756509Ab0F2PIw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 11:08:52 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26048 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756477Ab0F2PIv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 11:08:51 -0400
Date: Tue, 29 Jun 2010 08:07:57 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
       Gao Yunpeng <yunpeng.gao@intel.com>, gregkh@suse.de
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for June 29 (staging/spectra)
Message-Id: <20100629080757.a8028091.randy.dunlap@oracle.com>
In-Reply-To: <20100629151938.6981044d.sfr@canb.auug.org.au>
References: <20100629151938.6981044d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C2A0C77.007B:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Jun 2010 15:19:38 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100628:
> 
> My fixes tree is now empty.


When CONFIG_MTD=m and
CONFIG_SPECTRA=y
# CONFIG_SPECTRA_MRST_HW is not set
CONFIG_SPECTRA_MTD=y
# CONFIG_SPECTRA_EMU is not set

build-r3554.out:(.text+0x28bc7c): undefined reference to `put_mtd_device'
build-r3554.out:(.text+0x28bcb1): undefined reference to `get_mtd_device'

due to this in spectra/Kconfig:

config SPECTRA_MTD
	bool "Linux MTD mode"
	depends on MTD

so when CONFIG_MTD=m, the "depends on MTD" on a 'bool' makes the bool become 'y',
which is not good.

Is this supposed to build a separate lld_mtd driver?
Can't it be tristate instead of bool?



---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
