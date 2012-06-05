Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab2FERt0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:49:26 -0400
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:41933 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab2FERtY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:49:24 -0400
Message-ID: <4FCE466A.3050202@linux.vnet.ibm.com>
Date: Tue, 05 Jun 2012 23:18:26 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120424 Thunderbird/12.0
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Jan Beulich <JBeulich@suse.com>, Russell King <linux@arm.linux.org.uk>,
        yong.zhang0@gmail.com, Jeremy Fitzhardinge <jeremy@goop.org>,
        peterz@infradead.org, mingo@kernel.org, x86@kernel.org,
        akpm@linux-foundation.org, nikunj@linux.vnet.ibm.com,
        paulmck@linux.vnet.ibm.com, vatsa@linux.vnet.ibm.com,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Ingo Molnar <mingo@redhat.com>, rusty@rustcorp.com.au, rjw@sisk.pl,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Keir Fraser <keir@xen.org>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 05/27] xen, cpu hotplug: Don't call cpu_bringup()
 in xen_play_dead()
References: <20120601090952.31979.24799.stgit@srivatsabhat.in.ibm.com> <20120601091124.31979.91984.stgit@srivatsabhat.in.ibm.com> <4FC8D8E30200007800087D2B@nat28.tlf.novell.com> <4FC8DC19.4000007@linux.vnet.ibm.com> <4FC8FD9C0200007800087DF5@nat28.tlf.novell.com> <4FCA5608.2010404@linux.vnet.ibm.com> <alpine.LFD.2.02.1206051921320.3086@ionos>
In-Reply-To: <alpine.LFD.2.02.1206051921320.3086@ionos>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12060517-9574-0000-0000-0000030E7E83
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/05/2012 11:10 PM, Thomas Gleixner wrote:

> On Sat, 2 Jun 2012, Srivatsa S. Bhat wrote:
>> Ok.. So, I would love to hear a confirmation about whether this patch (which
>> removes cpu_bringup() in xen_play_dead()) will break things or it is good as is.
>>
>> If its not correct, then we can probably make __cpu_post_online() return an int,
>> with the meaning:
>>
>> 0 => success, go ahead and call cpu_idle()
>> non-zero => stop here, thanks for your services so far.. now leave the rest to me.
>>
>> So all other archs will return 0, Xen will return non-zero, and it will handle
>> when to call cpu_idle() and when not to do so.
>>
>> Might sound a bit ugly, but I don't see much other option. Suggestions are
>> appreciated!
> 
> Yes, it's butt ugly. 
> 
> You are tripping over the main misconception of the current hotplug
> code: It's asymetric.
> 
> So people added warts and workarounds like the xen one. What you are
> proposing is another wart and workaround.
> 
> The real way to avoid it, is to have the symetric state machine in
> place first and then convert everything to that instead of introducing
> an intermediate state which resembles the existing state.
> 
> One of the main things we need to do to make it symetric is to kill
> the play_dead() thing in the idle loop and make idle a function which
> returns on cpu_should_die().
> 
> Give me a day or two and I get you a working version of that. (Up is
> functional, just down refuses to play along)
> 


Oh great! So, then I'll wait for your patches and then adapt this patchset
to your model then. Let me know if I can help out with something..

Regards,
Srivatsa S. Bhat

