Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751818Ab0JJHRT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Oct 2010 03:17:19 -0400
Received: from LUNGE.MIT.EDU ([18.54.1.69]:57362 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751271Ab0JJHRS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Oct 2010 03:17:18 -0400
Date: Sun, 10 Oct 2010 00:19:49 -0700
From: Andres Salomon <dilinger@queued.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: David Miller <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, sam@ravnborg.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH] sparc: stop exporting openprom.h header
Message-ID: <20101010001950.1e58211c@debxo>
In-Reply-To: <20101010051324.GA9292@angua.secretlab.ca>
References: <20101008173650.GH3863@angua.secretlab.ca>
	<20101008.104557.59696706.davem@davemloft.net>
	<20101008113424.2249c2df@debxo>
	<20101008.115226.179923658.davem@davemloft.net>
	<AANLkTikuaM5VZadCs302HwYYhOHi1Czw2BLam3ZQP=aj@mail.gmail.com>
	<20101008143450.1334d8df@debxo>
	<20101009085143.GA1595@angua.secretlab.ca>
	<20101009134808.47723524@debxo>
	<20101010051324.GA9292@angua.secretlab.ca>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 9 Oct 2010 23:13:24 -0600
Grant Likely <grant.likely@secretlab.ca> wrote:

> On Sat, Oct 09, 2010 at 01:48:08PM -0700, Andres Salomon wrote:
> > On Sat, 9 Oct 2010 02:51:43 -0600
> > Grant Likely <grant.likely@secretlab.ca> wrote:
> > 
[...]
> Hmmm, series fails to build on sparc32, and doesn't appear to be
> fully bisectable.  Patches 1-3 compile file.  Adding patch 4 gives

Thanks for testing!


> the following build error.  Missing include perhaps?
> 
> /home/grant/hacking/linux-2.6/drivers/of/pdt.c: In function
> 'build_one_prop': /home/grant/hacking/linux-2.6/drivers/of/pdt.c:80:
> error: implicit declaration of function
> 'prom_firstprop' /home/grant/hacking/linux-2.6/drivers/of/pdt.c:80:
> warning: assignment makes pointer from integer without a
> cast /home/grant/hacking/linux-2.6/drivers/of/pdt.c:82: error:
> implicit declaration of function
> 'prom_nextprop' /home/grant/hacking/linux-2.6/drivers/of/pdt.c:82:
> warning: assignment makes pointer from integer without a
> cast /home/grant/hacking/linux-2.6/drivers/of/pdt.c:92: error:
> implicit declaration of function
> 'prom_getproplen' /home/grant/hacking/linux-2.6/drivers/of/pdt.c:99:
> error: implicit declaration of function
> 'prom_getproperty' /home/grant/hacking/linux-2.6/drivers/of/pdt.c: In
> function
> 'prom_build_tree': /home/grant/hacking/linux-2.6/drivers/of/pdt.c:213:
> error: implicit declaration of function
> 'prom_getchild' /home/grant/hacking/linux-2.6/drivers/of/pdt.c:218:
> error: implicit declaration of function 'prom_getsibling'
> distcc[16086] ERROR:
> compile /home/grant/hacking/linux-2.6/drivers/of/pdt.c on localhost
> failed make[3]: *** [drivers/of/pdt.o] Error 1 make[2]: ***
> [drivers/of] Error 2 make[2]: *** Waiting for unfinished jobs....
> 
> And after applying patch 5, I get this instead:
> 
> cc1: warnings being treated as errors
> /home/grant/hacking/linux-2.6/arch/sparc/kernel/prom_common.c: In
> function
> 'prom_common_nextprop': /home/grant/hacking/linux-2.6/arch/sparc/kernel/prom_common.c:144:
> error: passing argument 2 of 'prom_nextprop' discards qualifiers from
> pointer target
> type /home/grant/hacking/linux-2.6/arch/sparc/include/asm/oplib_32.h:227:
> note: expected 'char *' but argument is of type 'const char *'
> make[2]: *** [arch/sparc/kernel/prom_common.o] Error 1 make[2]: ***
> Waiting for unfinished jobs....
> 

D'oh:

arch/sparc/include/asm/oplib_32.h:extern char *prom_nextprop(phandle
node, char *prev_property, char *buffer);
arch/sparc/include/asm/oplib_64.h:extern char *prom_nextprop(phandle
node, const char *prev_property, char *buf);


> And applying the subsequent patches fails with the same error.
> Sparc64 builds fine with the entire stack applied, but I haven't
> bisected and I suspect that patch 4 will still fail there.
> 
> So, I'll leave patches 1-3 in my tree, and drop 4-7 until you get it
> sorted out.

I'll go ahead and resend 4-8 once I fix 'em up; the nextprop fix
require modifications to 5 and 8, and I haven't fixed the problem w/ 4
yet.
