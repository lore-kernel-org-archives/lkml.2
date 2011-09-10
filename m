Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755942Ab1IJBRJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Sep 2011 21:17:09 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:36511 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab1IJBRH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Sep 2011 21:17:07 -0400
From: Denys Vlasenko <vda.linux@googlemail.com>
To: "Indan Zupancic" <indan@nul.nu>
Subject: Re: Why I want PTRACE_O_TRACESTOP option
Date: Sat, 10 Sep 2011 03:17:03 +0200
User-Agent: KMail/1.8.2
Cc: "Oleg Nesterov" <oleg@redhat.com>, "Tejun Heo" <tj@kernel.org>,
        "Denys Vlasenko" <dvlasenk@redhat.com>, linux-kernel@vger.kernel.org
References: <1315500802.18043.45.camel@dhcp-25-63.brq.redhat.com> <20110909162606.GC23271@redhat.com> <e7392891fba13321668f533c6a0d637b.squirrel@webmail.greenhost.nl>
In-Reply-To: <e7392891fba13321668f533c6a0d637b.squirrel@webmail.greenhost.nl>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201109100317.03979.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 10 September 2011 01:09, Indan Zupancic wrote:
> On Fri, September 9, 2011 18:26, Oleg Nesterov wrote:
> > On 09/09, Indan Zupancic wrote:
> >>
> >> It is very useful to set options atomically at SEIZE time.
> >
> > Nobody argues with this.
> >
> >> Another important reason to make PTRACE_O_TRACESTOP an option is
> >> because not everyone uses SEIZE: Users using PTRACE_TRACEME can't
> >> set this option at all.
> >
> > Yes. This was already discussed, PTRACE_TRACEME obviously doesn't
> > work if you need the new features. So far it was decided TRACEME
> > should be avoided,
> 
> How do you want to attach/seize a just forked child without races
> in a less ugly way than with TRACEME?

I needed to do it when I was adding usage of SEIZE to strace.
It goes like this:

- fork
- child: raise(SIGSTOP)
- parent: waits until it sees child stopping
- parent: seizes the child
- parent: kill(child, SIGCONT)


-- 
vda
