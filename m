Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751631Ab2JBDpE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 23:45:04 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35422 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751203Ab2JBDpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 23:45:01 -0400
Date: Mon, 1 Oct 2012 20:44:59 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Tim Shepard <shep@alum.mit.edu>
cc: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: CONFIG_EXPERT is a booby trap
In-Reply-To: <E1TIXga-0008T1-00@www.xplot.org>
Message-ID: <alpine.DEB.2.00.1210012042220.31644@chino.kir.corp.google.com>
References: <E1TIXga-0008T1-00@www.xplot.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 1 Oct 2012, Tim Shepard wrote:

> Interestingly, of the 26 configs that use EXPERT in the default
> clause, 15 of them are in drivers/hid (see below).
> 
> 			-Tim Shepard
> 			 shep@alum.mit.edu
> 
>  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - -  - - 
> 
> $ find . -type f -name Kconfig'*' -print | xargs fgrep default | grep EXPERT 
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/hid/Kconfig:  default !EXPERT
> ./drivers/media/common/tuners/Kconfig:  default y if !EXPERT
> ./drivers/media/common/tuners/Kconfig:  default y if EXPERT
> ./drivers/media/dvb/frontends/Kconfig:  default y if EXPERT
> ./drivers/media/video/Kconfig:  default y if !EXPERT
> ./init/Kconfig: default !EXPERT
> ./lib/Kconfig.debug:    default !EXPERT
> ./net/rfkill/Kconfig:   default y if !EXPERT
> ./usr/Kconfig:  default !EXPERT
> ./usr/Kconfig:  default !EXPERT
> ./usr/Kconfig:  default !EXPERT
> ./usr/Kconfig:  default !EXPERT

I don't think selecting CONFIG_EXPERT should change whether a config 
option is enabled or disabled by default, I think it should only change 
whether certain options are available for enabling or disabling.  These do 
need care when fixing, though, and in the above circumstances you may find 
that s/EXPERT/EMBEDDED/ is the right change.
