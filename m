Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754284Ab0KHJTE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 04:19:04 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47185 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754179Ab0KHJTD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 04:19:03 -0500
Date: Mon, 8 Nov 2010 10:18:58 +0100
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Catalin Marinas <catalin.marinas@gmail.com>
Cc: Rabin Vincent <rabin@rab.in>, Frederic Weisbecker <fweisbec@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Tim Bird <tim.bird@am.sony.com>
Subject: Re: [PATCH 6/6] ARM: ftrace: enable function graph tracer
Message-ID: <20101108091858.GP16938@pengutronix.de>
References: <1289067954-5080-1-git-send-email-rabin@rab.in> <1289067954-5080-6-git-send-email-rabin@rab.in> <AANLkTin8UO9ixVep0jKK8H5roWEVRDJW4khUpT2TpPs+@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTin8UO9ixVep0jKK8H5roWEVRDJW4khUpT2TpPs+@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 06, 2010 at 07:06:28PM +0000, Catalin Marinas wrote:
> On Saturday, November 6, 2010, Rabin Vincent <rabin@rab.in> wrote:
> > Add the options to enable the function graph tracer on ARM.  Function
> > graph tracer support requires frame pointers, so exclude Thumb-2 and
> > also explicitly select FRAME_POINTER in FUNCTION_GRAPH_TRACER since
> > FUNCTION_TRACER doesn't select FRAME_POINTER when ARM_UNWIND is used
> > Therefore, with GCC 4.4.0+, you get plain function tracing without frame
> > pointers, but you'll need them if you want function graph tracing.
> .....
> > --- a/kernel/trace/Kconfig
> > +++ b/kernel/trace/Kconfig
> > @@ -141,6 +141,7 @@ config FUNCTION_TRACER
> >
> >  config FUNCTION_GRAPH_TRACER
> >         bool "Kernel Function Graph Tracer"
> > +       select FRAME_POINTER if ARM_UNWIND
> 
> Would it be better to modify FRAME_POINTER definition in the ARM
> Kconfig so that it is enabled automatically when FUNCTION_GRAPH_TRACER
> is enabled?
I don't like that suggestion much because it hides the dependency.
Moreover a "default y if FUNCTION_GRAPH_TRACER" doesn't work if a
precondition for FRAME_POINTER isn't true.  Rabin's approach at least
generates a warning.

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
