Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759297Ab1JFVkh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 17:40:37 -0400
Received: from claw.goop.org ([74.207.240.146]:34491 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757215Ab1JFVkg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 17:40:36 -0400
Message-ID: <4E8E2025.30004@goop.org>
Date: Thu, 06 Oct 2011 14:39:49 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110930 Thunderbird/7.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Jason Baron <jbaron@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        "David S. Miller" <davem@davemloft.net>,
        David Daney <david.daney@cavium.com>,
        Michael Ellerman <michael@ellerman.id.au>,
        Jan Glauber <jang@linux.vnet.ibm.com>,
        the arch/x86 maintainers <x86@kernel.org>,
        Xen Devel <xen-devel@lists.xensource.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        peterz@infradead.org, rth@redhat.com
Subject: Re: [PATCH RFC V2 3/5] jump_label: if a key has already been initialized,
 don't nop it out
References: <cover.1317506051.git.jeremy.fitzhardinge@citrix.com> <477dead9647029012f93c651f2892ed0e86b89e7.1317506051.git.jeremy.fitzhardinge@citrix.com> <20111003150205.GB2462@redhat.com> <4E89E28C.7010700@goop.org> <20111004141011.GA2520@redhat.com> <4E8B3489.60902@zytor.com> <4E8CF348.4080405@goop.org> <4E8CF385.2080804@zytor.com> <4E8DEB19.1050509@goop.org> <20111006181055.GA2505@redhat.com> <4E8DEFDE.4030706@zytor.com>
In-Reply-To: <4E8DEFDE.4030706@zytor.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2011 11:13 AM, H. Peter Anvin wrote:
> On 10/06/2011 11:10 AM, Jason Baron wrote:
>> It would be cool if we could make the total width 2-bytes, when
>> possible.  It might be possible by making the initial 'JUMP_LABEL_INITIAL_NOP'
>> as a 'jmp' to the 'l_yes' label. And then patching that with a no-op at boot
>> time or link time - letting the compiler pick the width. In that way we could
>> get the optimal width...
>>
> Yes, that would be a win just based on icache footprint alone.

I'm not sure it would be a win, necessarily.  My test with back-to-back
jmp2 was definitely slower than with the nop padding it out to 5 bytes;
I suspect that's a result of having too many jmps within one cacheline. 
Of course, there's no reason why the CPU would optimise for jumps to
jumps, so perhaps its just hitting a "stupid programmer" path.

    J
