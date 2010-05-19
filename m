Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752794Ab0ESG1G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 02:27:06 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:36368 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab0ESG1C convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 02:27:02 -0400
Subject: Re: [PATCH] x86: Export tsc related information in sysfs
From: Peter Zijlstra <peterz@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Dan Magenheimer <dan.magenheimer@oracle.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Venkatesh Pallipadi <venki@google.com>, Ingo Molnar <mingo@elte.hu>,
       chris.mason@oracle.com, linux-kernel@vger.kernel.org
In-Reply-To: <20100518211328.GH22675@basil.fritz.box>
References: <20100518112509.GD22675@basil.fritz.box>
	 <1274183935.5605.7726.camel@twins>> <4BF2C30F.6030502@zytor.com>
	 <1274201536.5605.8347.camel@twins> <4BF2C881.60807@zytor.com>
	 <1dc4abc2-6455-4b95-90f6-c86bf56ff39a@default> <4BF2E0A2.6030209@zytor.com>
	 <dd1c0508-5570-4e65-89c0-4037eb210646@default>
	 <61e3a205-b578-4972-a65a-b96f779aeeb1@default> <4BF2F9E4.8020808@zytor.com>
	 <20100518211328.GH22675@basil.fritz.box>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 19 May 2010 08:26:26 +0200
Message-ID: <1274250386.5605.9982.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-18 at 23:13 +0200, Andi Kleen wrote:
> > I'm not in favor of emulating rdtsc instructions.  I would consider
> > letting them SIGILL (actually SIGSEGV since RDTSC #GP in userspace) when
> > the TSC is unavailable, though.
> 
> I doubt we could ever do that, it would likely break just too much
> code.  Yes the code is already broken likely on some system, but there's

s/some/most/

> a big difference between wrong time and crash.

Maybe start with a patch that logs all users and start sending patches
to the respective projects to clean them up.

Once we get most of userspace running fine, we can switch it to
generating faults.

Of course closed source stuff will have to deal with it themselves, but
who cares about that anyway ;-)


