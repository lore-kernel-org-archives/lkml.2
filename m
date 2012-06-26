Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758737Ab2FZRCi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 13:02:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44303 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab2FZRCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 13:02:36 -0400
Date: Tue, 26 Jun 2012 10:02:32 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kay Sievers <kay@vrfy.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Wu Fengguang <fengguang.wu@intel.com>, Joe Perches <joe@perches.com>,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Subject: Re: [PATCH v3] printk: Have printk() never buffer its data
Message-ID: <20120626170232.GA2041@kroah.com>
References: <20120625150722.8cd4f45d.akpm@linux-foundation.org>
 <20120625235531.GB3652@kroah.com>
 <CA+55aFwczZTA=JUahoj_Sw1fQssDwoM2LGJ6g5nPvehTLxnSpg@mail.gmail.com>
 <20120626002307.GA4389@kroah.com>
 <CA+55aFxhYRqcU2EUmcsuLrhgo4FEO6-b+mB57wB3JRiXEp3ZrA@mail.gmail.com>
 <CAPXgP10cPFSmZ5yr6Z4wVtDa+x2J1yQDF57NJXtxjUuxMHm=Lw@mail.gmail.com>
 <CA+55aFzkX=jCC1O6+2oz8meswOqZQ+Q8Ao60q8eAS1G3AuEStQ@mail.gmail.com>
 <1340726856.977.6.camel@mop>
 <20120626165855.GA1851@kroah.com>
 <CAPXgP132AM9_3KryDc0cE+cKd-Q65wpGRkSzHaMvOGLM3AsrHg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPXgP132AM9_3KryDc0cE+cKd-Q65wpGRkSzHaMvOGLM3AsrHg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 26, 2012 at 07:00:38PM +0200, Kay Sievers wrote:
> On Tue, Jun 26, 2012 at 6:58 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Tue, Jun 26, 2012 at 06:07:36PM +0200, Kay Sievers wrote:
> >> On Mon, 2012-06-25 at 18:40 -0700, Linus Torvalds wrote:
> >> > On Mon, Jun 25, 2012 at 5:56 PM, Kay Sievers <kay@vrfy.org> wrote:
> >> > >
> >> > > Buffering has nice effects though:
> >> > > It makes continuation lines appear as one record in the buffer, not as
> >> > > n individual prints with n headers.
> >> >
> >> > As I already mentioned, buffering for *logging* is different from
> >> > buffering for *printing*.
> >> >
> >> > I think it might be a great idea to buffer for logging in order to
> >> > generate one individual buffer record there.
> >> >
> >> > But it needs to be printed as it is generated.
> >>
> >> That's a good idea.
> >>
> >> Something like this could work - only minimally tested at this moment.
> >
> > Hm, this doesn't boot for me, just hangs at startup :(
> 
> You have that patch against your tree? Let me try that, maybe it
> conflicts with one of the patches there ...

No, I applied to to a clean 3.5-rc4 (which boots fine on my laptop).

greg k-h
