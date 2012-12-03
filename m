Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754519Ab2LCQNy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 11:13:54 -0500
Received: from arrakis.dune.hu ([78.24.191.176]:41935 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751412Ab2LCQNx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 11:13:53 -0500
Date: Mon, 3 Dec 2012 17:13:46 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Daney <ddaney.cavm@gmail.com>, Alan Cooper <alcooperx@gmail.com>,
        linux-mips@linux-mips.org, linux-kernel@vger.kernel.org
Subject: Re: MIPS Function Tracer question
Message-ID: <20121203161346.GA29573@linux-mips.org>
References: <CAOGqxeUOrVFoqsmUV19h5tXsD6pw5creXP9aN1C-V7K3WL2EXA@mail.gmail.com>
 <50B7E91C.6070403@gmail.com>
 <1354545648.6276.202.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354545648.6276.202.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 03, 2012 at 09:40:48AM -0500, Steven Rostedt wrote:

> The issue is with x86. Gcc wont compile if you have -pg and
> -fomit-frame-pointer on x86. I originally forced function tracing to
> select FRAME_POINTER, but because now on x86 with -mfentry, -pg no
> longer requires frame pointers being set, I just let -pg complain one
> way or the other. I believe that gcc by default will not add frame
> pointers. Thus adding function tracing just prevents
> -fomit-frame-pointer from being set, and if -pg requires frame pointers
> it will automatically enable them otherwise they should not be enabled.

On architectures such as MIPS where a frame pointer is not required for
debugging -O and higher imply -fomit-frame-pointer.

  Ralf
