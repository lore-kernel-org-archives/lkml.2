Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934175Ab2LIPPs (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 10:15:48 -0500
Received: from mail-qc0-f174.google.com ([209.85.216.174]:59490 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934051Ab2LIPPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 10:15:46 -0500
Date: Sun, 9 Dec 2012 15:15:39 +0000
From: Cong Ding <dinggnu@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Yaakov Selkowitz <yselkowitz@users.sourceforge.net>,
        Peter Foley <pefoley2@verizon.net>, Adam Lee <adam8157@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] kbuild: solve the DSO link change issue
Message-ID: <20121209151539.GA25293@gmail.com>
References: <1354209688-16247-1-git-send-email-dinggnu@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354209688-16247-1-git-send-email-dinggnu@gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ping Michal, did you have any comments on this?

- cong

On Thu, Nov 29, 2012 at 05:21:28PM +0000, Cong Ding wrote:
> when make menuconfig, it reports this error:
> 
> /usr/bin/ld: scripts/kconfig/lxdialog/checklist.o: undefined reference to symbol 'acs_map'
> /usr/bin/ld: note: 'acs_map' is defined in DSO /lib64/libtinfo.so.5 so try adding it to the linker command line
> /lib64/libtinfo.so.5: could not read symbols: Invalid operation
> collect2: ld returned 1 exit status
> 
> due to the DSO link change, we must explicitly link against every library needed.
> http://fedoraproject.org/wiki/UnderstandingDSOLinkChange
> 
> Signed-off-by: Cong Ding <dinggnu@gmail.com>
> ---
>  scripts/kconfig/Makefile |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/scripts/kconfig/Makefile b/scripts/kconfig/Makefile
> index 3091794..ae339a1 100644
> --- a/scripts/kconfig/Makefile
> +++ b/scripts/kconfig/Makefile
> @@ -215,6 +215,7 @@ HOSTCFLAGS_gconf.o	= `pkg-config --cflags gtk+-2.0 gmodule-2.0 libglade-2.0` \
>                            -Wno-missing-prototypes
>  
>  HOSTLOADLIBES_mconf   = $(shell $(CONFIG_SHELL) $(check-lxdialog) -ldflags $(HOSTCC))
> +HOSTLOADLIBES_mconf += -ltinfo
>  
>  HOSTLOADLIBES_nconf	= -lmenu -lpanel -lncurses
>  $(obj)/qconf.o: $(obj)/.tmp_qtcheck
> -- 
> 1.7.4.5
> 
