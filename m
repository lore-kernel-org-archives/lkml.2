Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753666Ab1LLSUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 13:20:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30290 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753365Ab1LLST6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 13:19:58 -0500
Message-ID: <4EE645B0.9090501@redhat.com>
Date: Mon, 12 Dec 2011 20:19:28 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Pekka Enberg <penberg@kernel.org>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <levinsasha928@gmail.com>
Subject: Re: [patch 0/3] kvm tool: Serial emulation overhaul
References: <20111210132220.083204833@linutronix.de> <alpine.LFD.2.02.1112101715500.10936@tux.localdomain> <alpine.LFD.2.02.1112102144370.3020@ionos> <alpine.LFD.2.02.1112111014500.1663@tux.localdomain> <20111211103047.GA19299@elte.hu> <alpine.LFD.2.02.1112111459270.3020@ionos> <20111211155347.GA1297@elte.hu> <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com>
In-Reply-To: <CAOJsxLHTuN43AGA7C02MtETzJU87y9cRaWRg6e9ER7NxOK2w-Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/12/2011 01:19 PM, Pekka Enberg wrote:
> On Sun, Dec 11, 2011 at 5:53 PM, Ingo Molnar <mingo@elte.hu> wrote:
> > Okay, but look at it from another angle: the top output i
> > generate is about 300k characters. 5000 msecs to execute it
> > means 16 usecs overhead per character - or about 50k cycles - on
> > a top of the class x86 CPU.
>
> I'm seeing 1.5 usecs per character for this little benchmark:
>
>


No interrupts, right?  Things look differently with one interrupt per
character and none.  Try running kvm_stat with your benchmark and with a
guest kernel flooding the serial port.

-- 
error compiling committee.c: too many arguments to function

