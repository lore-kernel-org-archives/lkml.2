Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab1EMGPb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 02:15:31 -0400
Received: from smtp.outflux.net ([198.145.64.163]:56911 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab1EMGPa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 02:15:30 -0400
Date: Thu, 12 May 2011 23:12:52 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Pekka Enberg <penberg@kernel.org>
Cc: David Miller <davem@davemloft.net>, davej@redhat.com, eranian@google.com,
        acme@redhat.com, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [BUG] perf: bogus correlation of kernel symbols
Message-ID: <20110513061252.GV28888@outflux.net>
References: <BANLkTim8mAzZbdOhBodaOFKM5esP-Q+K7g@mail.gmail.com>
 <20110512.140630.1779004012724490077.davem@davemloft.net>
 <20110512183741.GA22269@redhat.com>
 <20110512.150132.1679483014638599288.davem@davemloft.net>
 <BANLkTimUko9Y-spdzQFDEvZBjaKSaJrHBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTimUko9Y-spdzQFDEvZBjaKSaJrHBw@mail.gmail.com>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pekka,

On Thu, May 12, 2011 at 10:58:53PM +0300, Pekka Enberg wrote:
> On Thu, May 12, 2011 at 10:01 PM, David Miller <davem@davemloft.net> wrote:
> > From: Dave Jones <davej@redhat.com>
> > Date: Thu, 12 May 2011 14:37:41 -0400
> >
> >> On Thu, May 12, 2011 at 02:06:30PM -0400, David Miller wrote:
> >>  > I hate this too, and I think it's absolutely rediculous.
> >>  >
> >>  > Also, like you, I lost an entire afternoon trying to figure out why
> >>  > this started happening.
> >>  >
> >>  > I wish we could revert this change.
> >>
> >> At least it can be permanently disabled..
> >>
> >> echo kernel.kptr_restrict = 0 >> /etc/sysctl.conf
> >
> > Regardless, what to do about all of the "perf is broken" reports?
> 
> Lets revert the commit 9f36e2c448007b54851e7e4fa48da97d1477a175
> ("printk: use %pK for /proc/kallsyms and /proc/modules"), please! I
> too have been wondering what's going on with perf reporting insane
> symbols and this should definitely not be enabled by default.

No, reverting that is not the answer. If perf has a problem with the
kptr_restrict feature, it should just disable it in /proc/sys when it
runs and restore it when finished. Since our defaults should be secure
for the average user (who does not use perf), it's fine the way it
is. Anyone using perf can adjust this for their use-case (that is why
there is a /proc/sys tunable).

-Kees

-- 
Kees Cook
Ubuntu Security Team
