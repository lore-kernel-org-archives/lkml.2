Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760849Ab1D2Ser (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 14:34:47 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33760 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753557Ab1D2Seq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 14:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=hVZdqPBVn2gCxje0Dx8D61b8OGAJ2giJsaHFmNSZ6sp/7BZqJiBHVim8aYxEk21Xig
         lD7QtEWmcKId3di/78lcZCw4eZrrNWfhdMGkgXEgiuuxyTjFr+qXce4zCocIBw0GVvpz
         552hAg6cYZ2BeumV2eROsWujkX/30zGjQpAEo=
Message-ID: <4DBB04C1.30003@gmail.com>
Date: Fri, 29 Apr 2011 20:34:41 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: "Ostrovsky, Boris" <Boris.Ostrovsky@amd.com>
CC: =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <peetz@dynato-kyma.net>,
        Borislav Petkov <bp@alien8.de>,
        =?ISO-8859-1?Q?J=F6rg-Volker_Peetz?= <jvpeetz@web.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Herrmann3, Andreas" <Andreas.Herrmann3@amd.com>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        the arch/x86 maintainers <x86@kernel.org>, stable@kernel.org
Subject: Re: Linux 2.6.38.4 : regression due to x86 AMD ARAT feature
References: <20110421213926.GA19721@kroah.com> <4DB3DA0C.1050003@web.de> <20110424182041.GA19984@liondog.tnic>,<4DB47211.90901@dynato-kyma.net> <EE335F95F28A664DB4A21289D2AA053BD1807651@SAUSEXMBP01.amd.com>
In-Reply-To: <EE335F95F28A664DB4A21289D2AA053BD1807651@SAUSEXMBP01.amd.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2011 09:44 PM, Ostrovsky, Boris wrote:
> Borislav Petkov wrote, on 04/24/11 20:20:
>> On Sun, Apr 24, 2011 at 10:06:36AM +0200, Jörg-Volker Peetz wrote:
>>> With 2.6.38.4 the clock slows down and the affected laptop sometimes, e.g. for
>>> the output of "ps axuw" to appear, needs an input from the keyboard or the
>>> touchpad. Please find attached the kernel config file and the output of dmesg.
>>>
>>> Commenting out the the lines
>>>
>>>      if (c->x86 >= 0xf && !cpu_has_amd_erratum(amd_erratum_400))
>>>              set_cpu_cap(c, X86_FEATURE_ARAT);
>>>
>>> in arch/x86/kernel/cpu/amd.c makes this laptop work as before with kernel
>>> 2.6.38.3. I think these lines came with commit
>>> d7b7f0c401303dd7eafcff11752fe74d3b75c766.

> It's an old family fh processor (CPUID 00020F42) that
cpu_has_amd_erratum(amd_erratum_400) apparently hasn't picked up. Since
all fh processors are affected by this erratum I'll replace "c->x86 >=
0xf" with "c->x86 > 0xf" (and probably fix erratum formula anyway).

Hi, what's the status of this please?

I don't see the fix neither in the -next tree.

thanks,
-- 
js
