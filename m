Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1BDPUK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 10:20:10 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:55977 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751880Ab1BDPUI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 10:20:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=Xg0HTkwT6Pu5b2FyZOT16iRObk5012F3LtVNwJxZyYAEBs60RUFy7zxnuZW/xnjNte
         3OtEMCaeVNI5xnOyzVjR13hWsUSOTlxDpRTFrpvSTHbA/kcSTkHFAgpRHCUrBLphj9H2
         NPdrkIj3775/mSKw2A1m8wrnaAqZJiWQRupYI=
MIME-Version: 1.0
In-Reply-To: <20110204150703.GA9254@hiauly1.hia.nrc.ca>
References: <20110203022420.A73F54E7B@hiauly1.hia.nrc.ca>
	<alpine.SOC.1.00.1102041150390.8218@math.ut.ee>
	<20110204150703.GA9254@hiauly1.hia.nrc.ca>
Date: Fri, 4 Feb 2011 10:20:05 -0500
X-Google-Sender-Auth: _0EM-E_4cM9_TakO5gmjuw_B0js
Message-ID: <AANLkTim9oXFf7ksuj9o-g2J4aL4xi-JPH3PsayMayxMt@mail.gmail.com>
Subject: Re: 2.6.38-rc3 regression on parisc: segfaults
From: "Carlos O'Donell" <carlos@systemhalted.org>
To: John David Anglin <dave.anglin@nrc-cnrc.gc.ca>
Cc: Meelis Roos <mroos@linux.ee>, linux-parisc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 4, 2011 at 10:07 AM, John David Anglin
<dave@hiauly1.hia.nrc.ca> wrote:
> On Fri, 04 Feb 2011, Meelis Roos wrote:
>
>> 2363  clone( <unfinished ...>
>> 2349  <... futex resumed> )             = 1
>> 2363  <... clone resumed> child_stack=0, flags=CLONE_CHILD_CLEARTID|CLONE_CHILD_SETTID|SIGCHLD, child_tidptr=0x460df4a8) = 2372
>> 2349  --- SIGSEGV (Segmentation fault) @ 0 (0) ---
>> 2372  rt_sigaction(SIGPIPE, {SIG_DFL, [], SA_RESTART},  <unfinished ...>
>> 2349  write(1, "\33[56;1H\33[34h\33[?25h", 18 <unfinished ...>
>>
>> Something futex-related. Full log temprarilty available at
>> http://www.cs.ut.ee/~mroos/aptitude-strace.txt
>
> This is possibly the infamous COW bug.

The COW bug that is triggered by a COW from an LWS-CAS? The solution
to which is to use locks around the LWS-CAS even on UP? I'd forgotten
about this issue actually, I should push that patch out to James.

Cheers,
Carlos.
