Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756564Ab0IUP01 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Sep 2010 11:26:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755859Ab0IUP0Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Sep 2010 11:26:25 -0400
Date: Tue, 21 Sep 2010 11:25:25 -0400
From: Jason Baron <jbaron@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, mathieu.desnoyers@polymtl.ca,
        tglx@linutronix.de, rostedt@goodmis.org, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, mhiramat@redhat.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        vgoyal@redhat.com, sam@ravnborg.org, tony@bakeyournoodle.com
Subject: Re: [PATCH 08/10] jump label v11: x86 support
Message-ID: <20100921152525.GC2873@redhat.com>
References: <cover.1284733808.git.jbaron@redhat.com> <f838f49f40fbea0254036194be66dc48b598dcea.1284733808.git.jbaron@redhat.com> <4C981BC4.90405@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C981BC4.90405@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 20, 2010 at 07:43:16PM -0700, H. Peter Anvin wrote:
> On 09/17/2010 08:09 AM, Jason Baron wrote:
> > add x86 support for jump label. I'm keeping this patch separate so its clear to
> > arch maintainers what was required for x86 support this new feature. hopefully,
> > it wouldn't be too painful for other arches.
> 
> > +	select HAVE_ARCH_JUMP_LABEL if !CC_OPTIMIZE_FOR_SIZE
> 
> Why?
> 
> 	-hpa
> 

Hi,

>From the documentation patch:

"
The optimization depends on !CC_OPTIMIZE_FOR_SIZE. When CC_OPTIMIZE_FOR_SIZE is
set, gcc does not always out of line the not taken label path in the same way
that the "if unlikely()" paths are made out of line. Thus, with
CC_OPTIMIZE_FOR_SIZE set, this optimization is not always optimal. This may be
solved in subsequent gcc versions, that allow us to move labels out of line,
while still optimizing for size.
"

This was also discuessed a bit on lkml previously:

http://marc.info/?l=linux-kernel&m=127618233108964&w=2


thanks,

-Jason



