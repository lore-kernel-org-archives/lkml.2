Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750895Ab1FIELE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 00:11:04 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:33922 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1FIELC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 00:11:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type;
        b=Nz0dW5DZ0cAenUhMPySCf+DdieKkEpoCGCdrWs9aHkZZfBzcZG/YMJy/G2Q0YU4ef4
         eNJ/jHnPcRn9S9rygMWWtHjk+t6E+jf5My7n4nDxMosEys/RlAqZ0qDBnxUeBHexyyXY
         y2A8K8ERfVtQB0dii3cQeAR7FU++Bo6ggJ6wE=
MIME-Version: 1.0
In-Reply-To: <1307591659.3980.37.camel@edumazet-laptop>
References: <20110609004435.14550.qmail@science.horizon.com>
 <4DF037C6.4000507@linux.intel.com> <BANLkTik62dLMf5PCPGeW=9P=sF2QcnW42g@mail.gmail.com>
 <1307591659.3980.37.camel@edumazet-laptop>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 9 Jun 2011 00:10:41 -0400
X-Google-Sender-Auth: a7zX-uw2GiByBgVkdn8Lf6WJH_g
Message-ID: <BANLkTi=E9gR3JHa4ipHHGGR2AiO9xJri=A@mail.gmail.com>
Subject: Re: Change in functionality of futex() system call.
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Darren Hart <dvhart@linux.intel.com>, George Spelvin <linux@horizon.com>,
        david@rgmadvisors.com, kyle@moffetthome.net,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 8, 2011 at 11:54 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>
> You can not prevent DOS on a machine if you allow a process to RO map
> your critical files (where you put futexes), because you allow this
> process to interfere with critical cache lines bouncing between cpus.

The cacheline bounce DoS slows things down and they go back to normal
when you kill the DoS-ing task.

The wakeup-eating DoS is permanent.  Seems a good deal worse to me.

If you make this change, please at least document it in the man page.

>
> Really, please forget about this crazy idea of allowing foreigners to
> _read_ or memory _map_ your files. Dont do it.
>

Then how am I supposed to efficiently broadcast information to
untrusted processes?  I'll have to put any futexes involved into
different files, but one way or another the actual data will have to
be memory mapped to avoid syscall overhead.

--Andy
