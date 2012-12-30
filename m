Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab2L3DIQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 22:08:16 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:44297 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754154Ab2L3DIO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 22:08:14 -0500
Message-ID: <1356836868.17061.7.camel@joe-AO722>
Subject: Re: [PATCH] printk: Fix incorrect length from print_time() when
 seconds > 99999
From: Joe Perches <joe@perches.com>
To: Roland Dreier <roland@purestorage.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sylvain Munaut <s.munaut@whatever-company.com>,
        Kay Sievers <kay@vrfy.org>, Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sat, 29 Dec 2012 19:07:48 -0800
In-Reply-To: <CAL1RGDV5fje8+sNQUCgJNKaasZ=pvg4rWrXaz-3cZ+uNgsWDzg@mail.gmail.com>
References: <1356754984-13917-1-git-send-email-roland@kernel.org>
	 <20121229175625.GA1963@kroah.com> <1356811734.16149.1.camel@joe-AO722>
	 <CAL1RGDV5fje8+sNQUCgJNKaasZ=pvg4rWrXaz-3cZ+uNgsWDzg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-12-29 at 14:27 -0800, Roland Dreier wrote:
> On Sat, Dec 29, 2012 at 12:08 PM, Joe Perches <joe@perches.com> wrote:
> > Sylvan Munaut did something similar
> > https://lkml.org/lkml/2012/12/5/168
> 
> Missed that and duplicated the debugging :(
> Sorry Sylvain.
> 
> I guess my patch may be preferable, since I happened to use the snprintf()
> method that you suggest -- all the open-coded digit-counting seems a bit
> verbose and perhaps hard to read and see the equivalence to the sprintf.

the kernel implementation of snprint/vsnprintf does expand on c99
and allow snprintf(NULL, 0... so your code should work fine.

I think the
	snprintf(NULL, 0
might be suspect.
(the same form is already used in drivers/usb/gadget/composite.c)

man snprintf says in part:

       Concerning the return value of snprintf(),  SUSv2  and  C99  contradict
       each other: when snprintf() is called with size=0 then SUSv2 stipulates
       an unspecified return value less than 1, while C99  allows  str  to  be
       NULL in this case, and gives the return value (as always) as the number
       of characters that would have been written in case  the  output  string
       has been large enough.

If not here, maybe the tools/perf/util/values.c code
that uses the same form might need changing.

