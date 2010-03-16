Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966111Ab0CPKRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 06:17:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:51205 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966100Ab0CPKRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 06:17:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:openpgp:content-type
         :content-transfer-encoding;
        b=pcEpVuab/L6Lx7q/eubIjiWqhcY9hGzs3q1TZiHRQByQYJMyI8kHkfecQcObsXQytp
         Cje3nld1P80xevtRB/nknItJFsqspLpbrCbN4tNg0wig7fmikcX4B0ZhaXLSGcvhePgo
         oBZroLVhdGeOHwITUbUzaUVsqsE/avktG6ejo=
Message-ID: <4B9F5ABE.7040705@gmail.com>
Date: Tue, 16 Mar 2010 12:17:34 +0200
From: =?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwintorok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Paul Mackerras <paulus@samba.org>, x86@kernel.org,
       linux-kernel@vger.kernel.org,
       Fr??d??ric Weisbecker <fweisbec@gmail.com>,
       Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: fix callgraphs of 32-bit processes on 64-bit kernels.
References: <1268667260-5505-1-git-send-email-edwintorok@gmail.com> <4B9E5EFF.1080308@gmail.com> <4B9F3EEC.7050104@gmail.com> <20100316084714.GB7961@elte.hu>
In-Reply-To: <20100316084714.GB7961@elte.hu>
X-Enigmail-Version: 0.95.0
OpenPGP: id=5379965D
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/16/2010 10:47 AM, Ingo Molnar wrote:
> * T??r??k Edwin <edwintorok@gmail.com> wrote:
> 
>> On 03/15/2010 06:23 PM, T??r??k Edwin wrote:
>>> On 03/15/2010 05:34 PM, T??r??k Edwin wrote:
>>>> It would be good if perf knew how to lookup symbols in kernel modules!
>>> BTW perf report -m -k /home/edwin/builds/linux-2.6/vmlinux doesn't show
>>> the symbols either.
>> I always forget that, unlike every other program, perf doesn't install
>> by default to /usr/local!
>> So I was running the wrong version of perf (from an older kernel), since
>> perf was installed to $HOME/bin (which of course isn't in sudo's path).
>>
>> Sorry for the confusion, the 2.6.33 perf DOES know how to lookup the
>> symbols:
>>     9.92%  glxgears  [radeon]                           [k]
>> r600_packet3_check
>>             |
>>             --- r600_packet3_check
>>                |
>>                |--96.80%-- r600_cs_parse
> 
> Ok, great!

BTW the patch I sent yesterday for tracing 32-bit apps is still needed,
since that is a kernel patch, and it wasn't due to using the wrong perf.

> 
> I suspect we could install into /usr/local too. Do you want to send a patch 
> for that?

Sent.

BTW I think perf would need some documentation on how to install, and
what packages you need to build everything, what permissions it needs to
run, etc.

1. manpages
For example by default the manpages don't get built and installed, so
perf report --help doesn't work. It needs a 'make man', and 'make
install-man'.
This is fine, because they need asciidoc and xmlto which aren't usually
installed on every system. But there should be some documentation
mentioning this.

2. privileges
I just found out that perf works without root privileges (I just
assumed	 it needed root, since oprofile needs it).

3. non-working targets?
Also there are some targets in Documentation that can't be built due to
missing files, like pdf which needs a non-existent user-manual.xml.

4. unresolved symbols
Sometimes I get symbol addresses that are not resolved, like this:
    57.03%   :32216       7fc7dc0acfa6  [.] 0x007fc7dc0acfa6
    12.39%   :32216  [radeon]           [k] r600_packet3_check
     4.92%   :32216  [radeon]           [k] r600_cs_packet_parse
     2.70%   :32216  [radeon]           [k] r600_cs_parse

Is this due to ASLR? Does perf need ASLR disabled?
That address corresponds to this:
7fc7dc07e000-7fc7dc2ef000 r-xp 00000000 fd:03 27713
 /opt/xorg/lib/dri/r600_dri.so

It'd of course be nice if there was a distro package for perf, I think
I'll file a RFP in Debian for that.

Best regards,
--Edwin
