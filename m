Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753217Ab2HBQTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 12:19:20 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:39989 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752328Ab2HBQTT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 12:19:19 -0400
Date: Thu, 2 Aug 2012 18:19:17 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sparc64: do not clobber personality flags in
	sys_sparc64_personality()
Message-ID: <20120802161917.GA5493@merkur.ravnborg.org>
References: <alpine.LNX.2.00.1208012204140.14910@pobox.suse.cz> <alpine.LNX.2.00.1208020912130.14910@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1208020912130.14910@pobox.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2012 at 09:12:46AM +0200, Jiri Kosina wrote:
> >From 4f000eda5917ceecb03767962026cc6a390b8216 Mon Sep 17 00:00:00 2001
> From: Jiri Kosina <jkosina@suse.cz>
> Date: Wed, 1 Aug 2012 21:10:51 +0200
> Subject: [PATCH 4/4] sparc64: do not clobber personality flags in sys_sparc64_personality()
> 
> There are multiple errors in how sys_sparc64_personality() handles
> personality flags stored in top three bytes.
> 
> - directly comparing current->personality against PER_LINUX32 doesn't work
>   in cases when any of the personality flags stored in the top three bytes
>   are used.
> - directly forcefully setting personality to PER_LINUX32 or PER_LINUX
>   discards any flags stored in the top three bytes
> 
> Fix the first one by properly using personality() macro to compare only
> PER_MASK bytes.
> Fix the second one by setting only the bits that should be set, instead of
> overwriting the whole value.

Hi Jiri.

Can you have a quick look at this too:
arch/sparc/include/asm/elf_32.h:#define SET_PERSONALITY(ex) set_personality(PER_LINUX)

>From your other comments it looks wrong. But I have not digged into this.

Thanks,
	Sam
