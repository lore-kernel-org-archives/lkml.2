Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752982Ab1ASVnz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 16:43:55 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:32965
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751122Ab1ASVny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:43:54 -0500
Date: Wed, 19 Jan 2011 13:44:28 -0800 (PST)
Message-Id: <20110119.134428.71569409.davem@davemloft.net>
To: mathieu.desnoyers@efficios.com
Cc: rostedt@goodmis.org, richm@oldelvet.org.uk, 609371@bugs.debian.org,
        ben@decadent.org.uk, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com, mingo@redhat.com
Subject: Re: Bug#609371: linux-image-2.6.37-trunk-sparc64: module scsi_mod:
 Unknown relocation: 36
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110119182052.GB18970@Krystal>
References: <20110119161534.GB15031@Krystal>
	<1295460822.12215.1389.camel@gandalf.stny.rr.com>
	<20110119182052.GB18970@Krystal>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Date: Wed, 19 Jan 2011 13:20:53 -0500

> Now what I'm discussing with David Miller is if creating a
> 
>   __long_packed_aligned
> 
> and using it for *both* type and variable alignment would be more palatable (it
> also works, and is more compact).

As I mentioned in another reply, we should not be using packed.

Packed has other implications, which makes it use byte-at-a-time accesses
for all parts of a structure when you tag it with 'packed'.  GCC doesn't
try to be clever and see that actually such accesses are safe.

If plain "__long_aligned" works and, since you're tagging it to the structure
definition, it only specifies a minimum-alignment, then I'm fine with using
that to fix this.
