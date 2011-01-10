Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754170Ab1AJPUm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jan 2011 10:20:42 -0500
Received: from canuck.infradead.org ([134.117.69.58]:52915 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751950Ab1AJPUl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jan 2011 10:20:41 -0500
Subject: Re: sparc boot failure due to perf init
From: Peter Zijlstra <peterz@infradead.org>
To: David Miller <davem@davemloft.net>
Cc: sam@ravnborg.org, linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org
In-Reply-To: <20110109.153745.35032992.davem@davemloft.net>
References: <1294431832.2016.457.camel@laptop>
	 <1294432055.2016.458.camel@laptop>
	 <20110107203119.GA30408@merkur.ravnborg.org>
	 <20110109.153745.35032992.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 10 Jan 2011 16:21:08 +0100
Message-ID: <1294672868.12715.0.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-01-09 at 15:37 -0800, David Miller wrote:
> sparc64: Fix bootup regression due to perf init ordering.
> 
> Commit 004417a6d468e24399e383645c068b498eed84ad
> ("perf, arch: Cleanup perf-pmu init vs lockup-detector")
> move the perf events init to be an early_initcall.
> 
> But this won't work properly unless the dependencies for
> this code initialize beforehand.
> 
> Fix it by making cpu_type_probe and pcr_arch_init be
> an early_initcall as well.
> 
> Reported-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: David S. Miller <davem@davemloft.net> 

Thanks for sorting that David! and sorry for causing the breakage to
begin with.
