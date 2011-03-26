Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab1CZL47 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Mar 2011 07:56:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49227 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750871Ab1CZL46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Mar 2011 07:56:58 -0400
Message-ID: <4D8DD46B.1030903@redhat.com>
Date: Sat, 26 Mar 2011 08:56:27 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Tony Luck <tony.luck@intel.com>
CC: Borislav Petkov <bp@amd64.org>, Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly Report
 Mechanism (HARM)
References: <cover.1300996141.git.mchehab@redhat.com>	<20110324173257.36680b90@pedra>	<20110324223907.GA10498@liondog.tnic>	<4D8C6C80.8010600@redhat.com>	<20110325141322.GB28313@gere.osrc.amd.com>	<4D8D078C.1040201@redhat.com> <AANLkTi=jGB_nFO0nnWWZ60gqgdELAQjv5dpAZmz5zKSz@mail.gmail.com>
In-Reply-To: <AANLkTi=jGB_nFO0nnWWZ60gqgdELAQjv5dpAZmz5zKSz@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 25-03-2011 19:37, Tony Luck escreveu:
> On Fri, Mar 25, 2011 at 2:22 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
>> Em 25-03-2011 11:13, Borislav Petkov escreveu:
>>> However, there's
>>> another issue with fatal errors - you want to execute as less code as
>>> possible in the wake of a fatal error.
>>
>> Yes. That's one of the reasons why it may make sense to have a separate event
>> for fatal errors.
> 
> We have three categories (severities):
> 1) Corrected - log these
> 2) Uncorrected-but-not-immediately-fatal - log these too
> 3) Fatal - all we can do with these is log to some persistent store (or
>     to a serial console connected to a logging device). perf style event
>     tracing doesn't help when all the userland daemons will never get a
>     chance to run.

Ok. Assuming that fatal errors will be stored on some persistent way, on a next
boot, the daemon will be able to catch them. So, I think it would be a nice feature
to have 3 different trace events, in order to allow users to filter between them.
Alternatively, we may implement filtering capabilities on userspace, but as perf
has this already, I'm in favor of using what's there.

>> It would be good to use some non-volatile ram for these. I was told that
>> APEI spec defines a way for that, but I'm not sure if low end machines would
>> be shipped with that.
> 
> You are talking about ERST - and you are right, this is generally not going
> to be present on low-end machines.  drivers/acpi/apei/erst.c was accepted
> in 2.6.35.  My /dev/pstore changes are in the current merge for 2.6.39 (but
> currently only show dmesg traces to the user).

It makes sense to integrate it on perf, after we add there a way to recover
persistent data when the daemon starts.

>> Alternatively, edac could fill a translation table, and the decoding code at
>> mce would be just a table retrieve routine (in order to speed-up translation,
>> in the case of fatal errors.
> 
> Eventually the translation table should move above edac (to the drivers/ras/
> area that Borislav suggested earlier?) so that both mce and edac can access.
> I think we'll need this for some time as SMBIOS continues to disappoint
> me with its inaccuracies.

That makes sense to me. The translation table there is only for memories, currently.

The /ras table needs to be generic enough to cover other types of translation, like
for example, translating a cpu Kernel representation into a CPU socket label,
and a PCI BUS ID into a PCI slot number.

Mauro.
