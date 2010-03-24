Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756513Ab0CXTzc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 15:55:32 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:61943 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab0CXTza convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 15:55:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=X+EUihtn1R3gC1uFbMZ+Cb6S68mxL87PJbeXNjv9ROCJw2OWHVCbPkFbb2i7de17hx
         TrqkC6TPZt4nH2TsaOEZsH8QqSgC2soduXZcrGgh+t7fzsmuMij0CIeYsHKT091RllaE
         VdEFhDDZDnLKi9yFSgoz4xD6pbTn8ulIl+Nmg=
MIME-Version: 1.0
In-Reply-To: <4BAA69BF.3080600@nortel.com>
References: <84621a61003240915p2a4ce6bbjd0c6bfb02ab05ba8@mail.gmail.com>
	 <4BAA4EE4.3090900@nortel.com>
	 <84621a61003241128x3afbcea1w387aeaa68c887320@mail.gmail.com>
	 <4BAA69BF.3080600@nortel.com>
Date: Wed, 24 Mar 2010 14:55:28 -0500
Message-ID: <84621a61003241255i74282f53v3bb0111808895401@mail.gmail.com>
Subject: Re: behavior of recvmmsg() on blocking sockets
From: Brandon Black <blblack@gmail.com>
To: Chris Friesen <cfriesen@nortel.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 24, 2010 at 2:36 PM, Chris Friesen <cfriesen@nortel.com> wrote:
> Note that I said "large numbers of sockets".  Like tens of thousands.
> In addition to context switch overhead this can also lead to issues with
> memory consumption due to stack frames.

Ok, agreed there.  In my case though, there will only ever be a
handful of sockets.  Ideally it would be just one socket.  The only
reason I allocate multiple sockets and spawn threads for them is
because you can't scale past one CPU core on a single socket, due to
the NIC and/or the driver and/or the socket locks and/or the basic
nature of the problem.

> Consider the case where you want to do some other useful work in
> addition to running your network server.  Every cpu cycle spent on the
> network server is robbed from the other work.  In this scenario you want
> to handle packets as efficiently as possible, so the timeout-based
> behaviour is better since it is more likely to give you multiple packets
> per syscall.

That's a good point, I tend to tunnelvision on the dedicated server
scenario.  I should probably have a user-level option for
timeout-based operation as well, since the decision here gets to the
systems admin/engineering level and will be situational.

Thanks,
-- Brandon
