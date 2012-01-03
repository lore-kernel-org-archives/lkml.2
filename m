Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753669Ab2ACO0S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 09:26:18 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51801 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752792Ab2ACO0O convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 09:26:14 -0500
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: linux-kernel@vger.kernel.org, "Gilad Ben-Yossef" <gilad@benyossef.com>
Cc: "David Airlie" <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        "Benjamin Herrenschmidt" <benh@kernel.crashing.org>,
        "Paul Mackerras" <paulus@samba.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        "Rob Herring" <rob.herring@calxeda.com>, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        "Richard Henderson" <rth@twiddle.net>,
        "Ivan Kokshaysky" <ink@jurassic.park.msu.ru>,
        "Matt Turner" <mattst88@gmail.com>, linux-alpha@vger.kernel.org,
        "Thomas Gleixner" <tglx@linutronix.de>,
        "Ingo Molnar" <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, "Tony Luck" <tony.luck@intel.com>,
        "Fenghua Yu" <fenghua.yu@intel.com>, linux-ia64@vger.kernel.org,
        "Will Deacon" <will.deacon@arm.com>,
        "Peter Zijlstra" <a.p.zijlstra@chello.nl>,
        "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
        "Russell King" <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC PATCH 0/9] Remove useless on_each_cpu return value
References: <1325600353-10895-1-git-send-email-gilad@benyossef.com>
Date: Tue, 03 Jan 2012 15:25:49 +0100
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v7iidbwz3l0zgt@mpn-glaptop>
In-Reply-To: <1325600353-10895-1-git-send-email-gilad@benyossef.com>
User-Agent: Opera Mail/11.60 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 03 Jan 2012 15:19:04 +0100, Gilad Ben-Yossef <gilad@benyossef.com> wrote:
> on_each_cpu() returns as its own return value the return value of
> smp_call_function(). smp_call_function() in turn returns a hard
> coded value of zero.
>
> Some callers to on_each_cpu() waste cycles and bloat code space
> by checking the return value to on_each_cpu(), probably for
> historical reasons.
>
> This patch set refactors callers to not test on_each_cpu()
> (fixed) return value and then refactors on_each_cpu to
> return void to avoid confusing future users.
>
> In other words, this patch aims to delete 18 source code lines
> while not changing any functionality :-)
>
> I tested as best as I could the x86 changes and compiled some
> of the others, but I don't have access to all the needed hardware
> for testing. Reviewers and testers welcome!

Other then the lack of Signed-off-by in the patches, looks good to me,
even though personally I'd choose a bottom-up approach, ie. make
smp_call_function() return void and from that conclude that
on_each_cpu() can return void.  With those patches, we have a situation,
where smp_call_function() has a return value which is then lost for no
immediately apparent reason lost in on_each_cpu().

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michał “mina86” Nazarewicz    (o o)
ooo +----<email/xmpp: mpn@google.com>--------------ooO--(_)--Ooo--
