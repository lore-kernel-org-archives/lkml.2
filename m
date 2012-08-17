Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758573Ab2HQQyU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 12:54:20 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:29925 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758432Ab2HQQyO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 12:54:14 -0400
Date: Fri, 17 Aug 2012 18:54:11 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Adam Lee <adam8157@gmail.com>
Cc: linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        "open list:KERNEL BUILD + fi..." <linux-kbuild@vger.kernel.org>
Subject: Re: [PATCH] kconfig: allow ARCH set to 'the machine hardware
	name', like 's390x' but not 's390'
Message-ID: <20120817165411.GA11373@merkur.ravnborg.org>
References: <1345189199-22145-1-git-send-email-adam8157@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345189199-22145-1-git-send-email-adam8157@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 17, 2012 at 03:39:59PM +0800, Adam Lee wrote:
> This patch add support for setting ARCH to 'the machine hardware
> name'(`uname -m).

Snip from s390 Makefile:

ifeq ($(CONFIG_64BIT),y)
        $(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso64 $@
endif
        $(Q)$(MAKE) $(build)=arch/$(ARCH)/kernel/vdso32 $@

You need more changes to support this.
Check all arch Makefiles for similar uses.

	Sam
