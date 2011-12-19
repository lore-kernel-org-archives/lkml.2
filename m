Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752883Ab1LSSjI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:39:08 -0500
Received: from smtp.studnetz.uni-leipzig.de ([139.18.143.252]:50936 "EHLO
	smtp.studnetz.uni-leipzig.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752692Ab1LSSjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:39:05 -0500
X-Greylist: delayed 1547 seconds by postgrey-1.27 at vger.kernel.org; Mon, 19 Dec 2011 13:39:04 EST
Message-ID: <4EEF7EC2.5060900@mageta.org>
Date: Mon, 19 Dec 2011 19:13:22 +0100
From: Benjamin <bebl@mageta.org>
Reply-To: bebl@mageta.org
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Robert Richter <robert.richter@amd.com>,
        Hans Rosenfeld <hans.rosenfeld@amd.com>, hpa@zytor.com,
        tglx@linutronix.de, suresh.b.siddha@intel.com, eranian@google.com,
        brgerst@gmail.com, Andreas.Herrmann3@amd.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, Benjamin Block <benjamin.block@amd.com>
Subject: Re: [RFC 4/5] x86, perf: implements lwp-perf-integration (rc1)
References: <20111216160757.GL665@escobedo.osrc.amd.com> <1324051943-21112-1-git-send-email-hans.rosenfeld@amd.com> <1324051943-21112-4-git-send-email-hans.rosenfeld@amd.com> <20111218080443.GB4144@elte.hu> <ae462f089fd4375fe44b09361fb955af@server102.greatnet.de> <20111218234309.GA12958@elte.hu> <20111219090923.GB16765@erda.amd.com> <20111219105429.GC19861@elte.hu> <4EEF1C3B.3010307@redhat.com> <20111219114023.GB29855@elte.hu> <4EEF26F0.1050709@redhat.com>
In-Reply-To: <4EEF26F0.1050709@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Antivirus: avast! (VPS 111219-0, 19.12.2011), Outbound message
X-Antivirus-Status: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 19.12.2011 12:58, schrieb Avi Kivity:
>> I'd suggest the easy hack first, to get things going - we can
>> then help out with the proper solution.
> I think you're underestimating the complexity there.  LWP wasn't
> designed for this.
>

LWP is highly limited in its ability's to support more than one
"LWP-Instance" being active for a thread, IOW it is not possible.
You can't activate LWP from a threads context and simultaneously
activate lwp-system-wide-profiling in the way you suggested it,
Ingo. Either do the first xor do the last, because you only have
one xsave-area/msr/lwpcb that is read by the hardware and only one
LWP-Buffer that is written by the hw.

So, if one thread is running LWP, because he wants to
(selfmonitoring and stuff [like for what lwp was designed]) and a
su or u would activate this system-wide-monitoring, both would
frequently interfere with the each other. I don't think you want
this to be possible at all.

Frankly, it was already a pain to get LWP running from in-kernel,
like it is done now. I would expect a much higher pain, if you
would want to do this with a transparent buffer, that gets passed
around each scheduling (and this would permanently eliminate the
"lightweight" in "LWP").

best regards,
- Benjamin
