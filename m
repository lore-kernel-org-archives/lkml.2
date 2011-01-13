Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933129Ab1AMSIm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 13:08:42 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37249 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932981Ab1AMSIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 13:08:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=lTtJf2KL0OBAkSPoE68/05B8R9e5WcQYLT6Pt2kF3JOSypDnTZgbkA5+qQIXjUpBKh
         D8MMDSi6RbLP8yH38zTLLjXWF6vfe3OphK1e0Kc/xw5uvixSvsHX3TyoqwSAz1wny+F1
         KNucz+fOW3o1c+5N2aq+3a7K/yJkH9b9Zrv6g=
Subject: Re: [PATCH v1 2/2] TCPCT API sockopt update to draft -03
From: Eric Dumazet <eric.dumazet@gmail.com>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Stephen Hemminger <shemminger@vyatta.com>,
        Linux Kernel Developers <linux-kernel@vger.kernel.org>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <4D2F3723.9040405@gmail.com>
References: <4D2DE824.10205@gmail.com>	<4D2DEC0A.70608@gmail.com>
	 <20110112105608.793787b2@s6510>  <4D2F3723.9040405@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 13 Jan 2011 19:00:18 +0100
Message-ID: <1294941618.3570.418.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 13 janvier 2011 à 12:32 -0500, William Allen Simpson a écrit :
> On 1/12/11 1:56 PM, Stephen Hemminger wrote:
> > On Wed, 12 Jan 2011 12:59:38 -0500
> > William Allen Simpson<william.allen.simpson@gmail.com>  wrote:
> >
> >> diff --git a/include/linux/tcp.h b/include/linux/tcp.h
> >> index e64f4c6..c8f4017 100644
> >> --- a/include/linux/tcp.h
> >> +++ b/include/linux/tcp.h
> >> @@ -185,22 +185,37 @@ struct tcp_md5sig {
> >>   #define TCP_COOKIE_PAIR_SIZE	(2*TCP_COOKIE_MAX)
> >>
> >>   /* Flags for both getsockopt and setsockopt */
> >> -#define TCP_COOKIE_IN_ALWAYS	(1<<  0)	/* Discard SYN without cookie */
> >> -#define TCP_COOKIE_OUT_NEVER	(1<<  1)	/* Prohibit outgoing cookies,
> >> +#define TCPCT_IN_ALWAYS		(1<<  0)	/* Discard SYN without cookie */
> >> +#define TCPCT_OUT_NEVER		(1<<  1)	/* Prohibit outgoing cookies,
> >
> > You end up changing values in kernel userspace API in a way
> > that is incompatible with older applications. This is not acceptable.
> >
> While I agree in principle and argued strongly against it, other
> members of the research group (particularly the original project
> sponsor) have over-ridden my concerns.  I'm sorry to inform you that
> many/most participants don't care much about Linux.
> 

How leaving TCP_COOKIE_IN_ALWAYS and TCP_COOKIE_OUT_NEVER definitions so
that user space programs compiles can be a problem to "research group" ?

AFAIK, TCPCT_IN_ALWAYS / TCPCT_OUT_NEVER are not mentioned in
http://www.rfc-editor.org/authors/rfc6013.txt

But TCP_COOKIE_IN_ALWAYS and TCP_COOKIE_OUT_NEVER are ...

Isnt it a bit confusing ?

> Note that the *bits* are the same, and previously compiled programs
> (that don't access more advanced features) should continue to run as
> they have in the past.
> 
> Even though I'm not paid to work on Linux, I'm doing my best to give you
> folks a quick heads up and provide code to rectify the very recent changes
> that can be propagated back through the stable tree (to 2.6.33).
> 
> As always, what you actually do with my code is up to you....

Maybe its too early, and we should wait for an official RFC, especially
if you insist breaking API in 6 months.


