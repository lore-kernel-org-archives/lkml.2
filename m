Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754942Ab1C1Ssg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 14:48:36 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:47270 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab1C1Ssf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 14:48:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tDtfxc3tfTIHbwM7bTt9ZystQq6hkuYNnv4bATxm6tY6YXZXa7GH8eVAupdlYKJ6mB
         Gj7fDdjTmYGgmxqeqLzgrTdx5pDWPymWaxZigRE7xyMXX/KtlkjC+j6Su/sUuHP2IMH5
         hwJ8QxIUG+8juJUZjVHXy/8LiWINyH1fCYXNs=
MIME-Version: 1.0
In-Reply-To: <20110328180655.GI2287@linux.vnet.ibm.com>
References: <AANLkTi=de3yDfXxCDp082+e3T+g_1wRWKWjqS0n1vy0+@mail.gmail.com>
	<AANLkTi=W0mW2o2muNgMnb1OQ6WaBeOmu1VBHr8Zf63r9@mail.gmail.com>
	<20110326120847.71b6ae4d@lxorguk.ukuu.org.uk>
	<20110328180655.GI2287@linux.vnet.ibm.com>
Date: Mon, 28 Mar 2011 19:48:34 +0100
Message-ID: <AANLkTin6kg84P50RHR7h6NG+P_nJK=N_Nefc1q4NxzY_@mail.gmail.com>
Subject: Re: advice sought: practicality of SMP cache coherency implemented in
 assembler (and a hardware detect line)
From: Luke Kenneth Casson Leighton <luke.leighton@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Will Newton <will.newton@gmail.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 7:06 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
>> Basically it would become a cluster with a very very fast "page transfer"
>> operation for moving data between nodes.
>
> This works for applications coded specially for this platform, but unless
> I am missing something, not for existing pthreads applications.  Might
> be able to handle things like Erlang that do parallelism without shared
> memory.

 ok - well, having thought about this a little bit (in a non-detailed
high-level way) i was sort-of hoping, as alan hinted at, to still do
SMP, even if it's slow, for userspace.   the primary thing to prevent
from happening is to have kernelspace data structures from
conflicting.

 i found kerrigan, btw, spoke to the people on it: louis agreed that
the whole idea was mad as hell and was therefore actually very
interesting to attempt :)

 as a first approximation i'm absolutely happy for existing pthreads
applications to be forced to run on the same core.

 l.
