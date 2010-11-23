Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab0KWVmM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 16:42:12 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:64981 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502Ab0KWVmL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 16:42:11 -0500
X-Authority-Analysis: v=1.1 cv=6ptpMFIBtxRk0xdOb6IhJTbTLVRlKjWFes7R4SsWCrA= c=1 sm=0 a=dloADZ4KP7gA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=YY22zN6FWk-OHBbpI8sA:9 a=u1DrlKNfgVzMBjTZRnvFPLd3vFIA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH 0/3] jump label: updates for 2.6.37
From: Steven Rostedt <rostedt@goodmis.org>
To: Jason Baron <jbaron@redhat.com>
Cc: mingo@elte.hu, peterz@infradead.org, mathieu.desnoyers@polymtl.ca,
        hpa@zytor.com, tglx@linutronix.de, andi@firstfloor.org,
        roland@redhat.com, rth@redhat.com, masami.hiramatsu.pt@hitachi.com,
        fweisbec@gmail.com, avi@redhat.com, davem@davemloft.net,
        sam@ravnborg.org, ddaney@caviumnetworks.com, michael@ellerman.id.au,
        linux-kernel@vger.kernel.org
In-Reply-To: <cover.1290546539.git.jbaron@redhat.com>
References: <cover.1290546539.git.jbaron@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 23 Nov 2010 16:42:07 -0500
Message-ID: <1290548527.30543.401.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-23 at 16:27 -0500, Jason Baron wrote:
> Hi,
> 
> A few jump label patches that I want considered for 2.6.37. Patches are against
> the latest -tip tree.

I can see patch 2 and 3 going to 2.6.37, but patch 1 seems a bit too
big. If it is not a true fix for anything and is just a design change,
then lets hold off till 2.6.38.


> 
> The first one, which adds 'state' to the jump label mechanism is the most
> important. Essentially, it ensures that if jump labels are enabled/disabled in
> the core kernel but the actual call sites are in modules, we properly honor the
> state of the jump label. This also works for jump labels which may be defined in
> one module but made use of in another module.

What happens if we don't do this. What does "honoring" the state
actually mean?


> 
> There has been some discussion about using the 'key' variable to store the
> enabled/disabled state for each jump label. However, I think a better design
> will be to use the 'key' variable to store a pointer to the appropriate jump
> label tables. In this way, we can enable/disable jump labels, without the
> hashing that I'm currently doing. However, I didn't want to propose these more
> invasive changes until 2.6.38. 

I'm thinking even patch 1 is too invasive. Unless it crashes or truly
breaks something without the change.

Patch 2 is small and reasonable, and patch 3 is just documentation
changes. Both OK for an -rc update.

-- Steve


