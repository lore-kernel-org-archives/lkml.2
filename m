Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab0K3PK0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:10:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31596 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750936Ab0K3PKY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:10:24 -0500
Message-ID: <4CF5139A.1080607@redhat.com>
Date: Tue, 30 Nov 2010 13:09:14 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100827 Red Hat/3.1.3-1.el6 Lightning/1.0b2 Thunderbird/3.1.3
MIME-Version: 1.0
To: Len Brown <lenb@kernel.org>
CC: Mark Lord <kernel@teksavvy.com>, Huang Ying <ying.huang@intel.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 0/2] Generic hardware error reporting support
References: <1290154233-28695-1-git-send-email-ying.huang@intel.com> <AANLkTin_SyFFP_2=pKoS+8+4V1qXVWyrus7BKz8ENVsJ@mail.gmail.com> <AANLkTincYS7G1yb2ukT67qvpjwQmptXzQZabLQLYrEqn@mail.gmail.com> <AANLkTi=U7F7MS48dC=GgGqh=cm8YrtVhrm6sDXOma6Fc@mail.gmail.com> <AANLkTiki3d3Ft3-XJwFg8DUzUYcz3xPoYTzLZokLf+dv@mail.gmail.com> <AANLkTinAZgHbexU+LTUZHs-+7C0N990=kyuO-USV1Ncp@mail.gmail.com> <AANLkTinBBELXbUu1O+iSX+1FMXTwa9epwPYmi7EnCP+o@mail.gmail.com> <AANLkTikZ=TPN4_GXnUasRq-m8uwy6Spdzd=m_fR08Okt@mail.gmail.com> <AANLkTimvf8t5Rti73kYKV9cG3d7d7Y=OCn57LQNzUuTR@mail.gmail.com> <AANLkTin_-05__F-CMPcOFHceJraJgDN3EGaHe4MT-EyM@mail.gmail.com> <4CEB0037.3000303@teksavvy.com> <1290472198.2903.156.camel@yhuang-dev> <4CEDCCF5.5030308@teksavvy.com> <alpine.LFD.2.00.1011242320000.637@x980>
In-Reply-To: <alpine.LFD.2.00.1011242320000.637@x980>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-11-2010 02:27, Len Brown escreveu:
>> ... most *NIX tools store and manage data in _text_ form.
> 
> If the hardware error dump is complicated there is a trade-off
> between making things human readable and putting a lot of
> comlicated parsing code into the kernel.  Maybe the kernel
> should just dump hex "text" in some cases and let a user-program
> parse the syslog?
> 
> What do do if the hardware error log is very large?
> Is there a limit on how much is practical to send through syslog?

If you look what sysadm's do with the Unix logs, you'll see that they 
use either one of the following approaches:

1) have something looking at syslog (and/or serial console logs), and 
storing them for their analisys, in text format;

2) convert syslog errors into a SNMP object UID's, on a machine-readable code, 
in order to manage them via some SNMP management system.

On both cases, the approach is there for a long time.

If an error "magic" code is added, both ways will break, as sysadm's won't be
able to understand the meaning of the magic number, and the SNMP conversion 
tools won't be ready to convert that magic code into something else. 

Of course, with time, the SNMP parsers will eventually add the needed decoders
for the magic numbers, in order to convert them into a MIB representation.

So, even being a number, such code is not machine readable (at least not for the
right tools), as it is not an SNMP object, so, the management systems won't catch 
it without a parser.

So, IMO, the better is to keep providing a text message. 

We might think on adding a way to directly output a SNMP UID from kernel,
but this seems overkill to me, and anything else would just be meaningless
for most sysadmins.

Thanks,
Mauro.
