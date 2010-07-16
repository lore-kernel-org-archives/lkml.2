Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759416Ab0GPWln (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 18:41:43 -0400
Received: from one.firstfloor.org ([213.235.205.2]:58751 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0GPWlm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 18:41:42 -0400
Date: Sat, 17 Jul 2010 00:41:40 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andi Kleen <andi@firstfloor.org>, Avi Kivity <avi@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
Message-ID: <20100716224140.GI7338@basil.fritz.box>
References: <4C409CBA.1050709@redhat.com>
 <4C409F62.6030303@zytor.com>
 <4C40A1BD.4040507@redhat.com>
 <4C40A227.6000207@zytor.com>
 <4C40A4E8.5090605@redhat.com>
 <AANLkTinc_of_KYCFt9-8GZYGFLyqQLlgNttPe-YvZn-1@mail.gmail.com>
 <4C40B277.9030408@redhat.com>
 <AANLkTimfZb22E7c_ftyc5WfKsGvJKKq-J3Vq8Y6FNvhT@mail.gmail.com>
 <20100716220730.GH7338@basil.fritz.box>
 <AANLkTikzZ436qG4vuNYNItDV69u9HqWna1ND51GzUtwH@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikzZ436qG4vuNYNItDV69u9HqWna1ND51GzUtwH@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 03:26:32PM -0700, Linus Torvalds wrote:
> On Fri, Jul 16, 2010 at 3:07 PM, Andi Kleen <andi@firstfloor.org> wrote:
> >
> > One issue I have with nesting NMIs is that you need
> > a nesting limit, otherwise you'll overflow the NMI stack.
> 
> Have you actually looked at the suggestion I (and now Mathieu)
> suggested code for?

Maybe I'm misunderstanding everything (and it has been a lot of emails
in the thread), but the case I was thinking of would be if the second NMI 
faults too, and then another one comes in after the IRET etc.

-Andi
