Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753654Ab0LFQRk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 11:17:40 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:35415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774Ab0LFQRi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 11:17:38 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=E7w0mK1DqmIA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=1XWaLZrsAAAA:8 a=4InhS8vWX-yu2Wzo52QA:9 a=ap-GuRiQDoVqLnlQgDmlkLfWsS8A:4 a=PUjeQqilurYA:10 a=UTB_XpHje0EA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [Patch 00/15] Reduce tracing payload size.
From: Steven Rostedt <rostedt@goodmis.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "Ted Ts'o" <tytso@mit.edu>, David Sharp <dhsharp@google.com>,
        linux-kernel@vger.kernel.org, mrubin@google.com
In-Reply-To: <20101206145852.GA24977@basil.fritz.box>
References: <1291421609-14665-1-git-send-email-dhsharp@google.com>
	 <878w03t4sn.fsf@basil.nowhere.org> <20101206135637.GC8135@thunk.org>
	 <20101206145852.GA24977@basil.fritz.box>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 06 Dec 2010 11:17:35 -0500
Message-ID: <1291652255.16223.29.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 15:58 +0100, Andi Kleen wrote:
> On Mon, Dec 06, 2010 at 08:56:37AM -0500, Ted Ts'o wrote:
> > On Mon, Dec 06, 2010 at 02:22:00PM +0100, Andi Kleen wrote:
> > > David Sharp <dhsharp@google.com> writes:
> > > >
> > > > These patches are just a start to shrinking the size of trace events. I am
> > > > planning to also make small versions of trace events that are used when
> > > > CONFIG_SMALL_TRACES is enabled. I'm also open to discussion of other ways to
> > > > shrink event sizes.
> > > 
> > > Maybe the simplest would be to lzo them as they get logged?
> > > I assume you already considered that?
> > 
> > The tracing subsystem is supposed to be extremely low-overhead.
> > Compressiong the event log would add considerable CPU overhead.  If we
> 
> lzo as a rule of thumb is about as expensive as 3x memcpy()
> That's not really expensive.

Usually the most expensive thing in the trace is the memcpy(). Which is
why we try to do it only once.

-- Steve


