Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab0E1GG1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 02:06:27 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56176 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758866Ab0E1GFv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 02:05:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=KuHMCnFuxaS59LI0z81/2QSnhMB2pLyOsBLBIMAnC20YHO3uhizXP79dUqPjYQc1U0
         YA1f+oZDK5cBZF0ZUw7SA5J++BpXVW/jNzTRYLOs3kQi4gVfw1VXsw8gY8cEll2/XS8Z
         1Ju/yDjrTfRgjNFBuwn5ZANr6ppoZ+lyjyDMk=
MIME-Version: 1.0
In-Reply-To: <1274863506-14168-1-git-send-email-vapier@gentoo.org>
References: <1274815467-14584-1-git-send-email-vapier@gentoo.org> 
	<1274863506-14168-1-git-send-email-vapier@gentoo.org>
From: Mike Frysinger <vapier.adi@gmail.com>
Date: Fri, 28 May 2010 02:05:27 -0400
Message-ID: <AANLkTilUCAoppSG7TIWyUqVa98ItoFHTh_lxA6Fl8l8g@mail.gmail.com>
Subject: Re: [PATCH 1/2 v2] FLAT: split the stack & data alignments
To: linux-kernel@vger.kernel.org
Cc: uclinux-dev@uclinux.org, David Howells <dhowells@redhat.com>,
       David McCullough <davidm@snapgear.com>, Greg Ungerer <gerg@uclinux.org>,
       Paul Mundt <lethal@linux-sh.org>,
       uclinux-dist-devel@blackfin.uclinux.org,
       microblaze-uclinux@itee.uq.edu.au, Michal Simek <monstr@monstr.eu>,
       linux-m32r@ml.linux-m32r.org, Hirokazu Takata <takata@linux-m32r.org>,
       Yoshinori Sato <ysato@users.sourceforge.jp>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 04:45, Mike Frysinger wrote:
> The stack and data have different alignment requirements, so don't force
> them to wear the same shoe.  Increase the data alignment to match that
> which the elf2flt linker script has always been using: 0x20 bytes.  Not
> only does this bring the kernel loader in line with the toolchain, but
> it also fixes a swath of gcc tests which try to force larger alignment
> values but randomly fail when the FLAT loader fails to deliver.

btw, a follow up patch might be to move the shared lib identifiers
from the start of the data section to the end of it so that the
re-aligning isnt necessary (we'd get a 4k page alignment from mmap and
such).  but i cant seem to figure out how these identifiers are being
read/written.  otherwise, the fact that we're force aligning to 0x20
bytes means that there is always room for 8 identifiers ... no point
in flipping between 1 or 4, at least from this point of view ...
-mike
