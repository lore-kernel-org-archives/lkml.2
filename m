Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752042Ab1HQAg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:36:59 -0400
Received: from mga14.intel.com ([143.182.124.37]:31106 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751335Ab1HQAg6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:36:58 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,236,1312182000"; 
   d="scan'208";a="7937951"
Message-ID: <4E4B0D28.7010905@linux.intel.com>
Date: Tue, 16 Aug 2011 17:36:56 -0700
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: "lkml, " <linux-kernel@vger.kernel.org>
CC: Paul Mackerras <paulus@samba.org>, Gary Thomas <gary@mlbassoc.com>,
        "Woodhouse, David" <david.woodhouse@intel.com>
Subject: can't build modules after clean for powerpc
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

According to the Makefile comments and
Documentation/kconfig/makefile.txt, make clean should leave enough
intact to build modules with:

###
# Cleaning is done on three levels.
# make clean     Delete most generated files
#                Leave enough to build external modules

The following line in the arch/powerpc/Makefile prevents that from working:

KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o

External module compilation fails to link as it can't find
arch/powerpc/lib/crtsavres.o.

It appears from the make logs that crtsavres.o is linked in to
built-in.o, and thus vmlinux. If that is the case, it doesn't seem like
crtsavres.o should need to be singled out. What am I missing here?

If I comment it out:

#KBUILD_LDFLAGS_MODULE += arch/powerpc/lib/crtsavres.o

my example module builds successfully.

If it is necessary, then we need a means to instruct the top level
makefile to not delete it during "clean". Is there such a directive?

KBUILD_CLEAN_EXCLUDE_MODULES or something?

Thanks,

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel
