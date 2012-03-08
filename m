Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759381Ab2CHAIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 19:08:43 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:58196 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab2CHAIk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 19:08:40 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Dave Jones" <davej@redhat.com>
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>, linux-mm@kvack.org
Subject: Re: decode GFP flags in oom killer output.
References: <20120307233939.GB5574@redhat.com> <op.watq2ixr3l0zgt@mpn-glaptop>
 <20120308000233.GA10695@redhat.com>
Date: Thu, 08 Mar 2012 01:08:38 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.watr0ors3l0zgt@mpn-glaptop>
In-Reply-To: <20120308000233.GA10695@redhat.com>
User-Agent: Opera Mail/11.61 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 08 Mar 2012 01:02:33 +0100, Dave Jones <davej@redhat.com> wrote:

> On Thu, Mar 08, 2012 at 12:48:08AM +0100, Michal Nazarewicz wrote:
> > >  static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
> > >  			struct mem_cgroup *memcg, const nodemask_t *nodemask)
> > >  {
> > > +	char gfp_string[80];
> >
> > For ~0, the string will be 256 characters followed by a NUL byte byte at the end.
> > This combination may make no sense, but the point is that you need to take length
> > of the buffer into account, probably by using snprintf() and a counter.
>
> alternatively, we could just use a bigger buffer here.

Allocating 257 bytes on stack does not seem like a good idea especially inside of
OOM killer, where probably quite a bit of the stack was already consumed prior to
reaching this function.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
