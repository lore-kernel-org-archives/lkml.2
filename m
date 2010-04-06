Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab0DFD0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 23:26:49 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:41085 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab0DFD0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 23:26:45 -0400
Date: Tue, 6 Apr 2010 13:26:42 +1000
From: Simon Horman <horms@verge.net.au>
To: Changli Gao <xiaosuo@gmail.com>
Cc: wzt.wzt@gmail.com, linux-kernel@vger.kernel.org, wensong@linux-vs.org,
       Julian Anastasov <ja@ssi.bg>, netdev@vger.kernel.org,
       lvs-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] IPVS: replace sprintf to snprintf to avoid stack
 buffer overflow
Message-ID: <20100406032642.GG30359@verge.net.au>
References: <20100406025020.GA2741@localhost.localdomain>
 <k2l412e6f7f1004051958h7c50f439r6b7a84379c35cba5@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <k2l412e6f7f1004051958h7c50f439r6b7a84379c35cba5@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 06, 2010 at 10:58:28AM +0800, Changli Gao wrote:
> On Tue, Apr 6, 2010 at 10:50 AM,  <wzt.wzt@gmail.com> wrote:
> > IPVS not check the length of pp->name, use sprintf will cause stack buffer overflow.
> > struct ip_vs_protocol{} declare name as char *, if register a protocol as:
> > struct ip_vs_protocol ip_vs_test = {
> >        .name =                 "aaaaaaaa....128...aaa",
> >        .debug_packet =         ip_vs_tcpudp_debug_packet,
> > };
> >
> > when called ip_vs_tcpudp_debug_packet(), sprintf(buf, "%s TRUNCATED", pp->name);
> > will cause stack buffer overflow.
> >
> 
> Long messages will be truncated instead of buffer overflow. We need to
> find a way to handle long messages elegantly.

Its really a corner case. In practice protocol modules don't have really
long names. And if one was merged that did, the buffer size could be increased
at that time.

So while I think its reasonable to protect against something unexpected
in a protocol-module name crashing the system. Especially as that
can be achieved without any real overhead. I don't think we need
to sanitise the output.
