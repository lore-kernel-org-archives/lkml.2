Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524Ab2JFSAM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Oct 2012 14:00:12 -0400
Received: from nm4-vm6.bullet.mail.gq1.yahoo.com ([98.136.218.165]:39929 "HELO
	nm4-vm6.bullet.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750760Ab2JFSAK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Oct 2012 14:00:10 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Sat, 06 Oct 2012 14:00:09 EDT
X-Yahoo-Newman-Id: 176618.27796.bm@omp1017.access.mail.mud.yahoo.com
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: jNrpjogVM1l3d17sW.1uJcp3uzh58L3Pk8NfO5NG9qf0oXw
 W1DmDcgIIMGHuBKd3GsMKyJUMhh8HmBJ5hNorgcpFp2qedtmWPmruMo1Ms1e
 aDyi1DTPCYaTomriBfPTitaUEDHSFlegwzgjFLFfxnicac2wmRc7BkGpnFd5
 usc_4kRSppMD9d0gyHwBd3goOY0w0qhydLTIo1UG6Ln0wYZI7shd4F79b58Q
 P1cbU8XDmJrgv08h2SOZDDRH7Imy.6aD2gcVCWZTSJxyup0gb54cpr4DQnR6
 4Zq2O.xrRVfVkYjhzMzgJUJND3tTjY3FoTFp6s9AsOrbiLvUEJZABMpthX3A
 Za_UWd2sx84CIyiv3.GCMR9YH2GdjRSJwGzZEj_UGlhkL04Pl6uSjQLWoL0l
 5dZnM4hmJjh_9cjCvxbMR0MGB_jqHXp7qVkhlsfsn80o2_JH2NA--
X-Yahoo-SMTP: xXkkXk6swBBAi.5wfkIWFW3ugxbrqyhyk_b4Z25Sfu.XGQ--
Message-ID: <5070703F.8050004@att.net>
Date: Sat, 06 Oct 2012 12:54:07 -0500
From: Daniel Santos <danielfsantos@att.net>
Reply-To: Daniel Santos <daniel.santos@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.4) Gecko/20120502 Thunderbird/10.0.4
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, LKML <linux-kernel@vger.kernel.org>,
        Andi Kleen <ak@linux.intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Christopher Li <sparse@chrisli.org>,
        David Daney <david.daney@cavium.com>,
        David Howells <dhowells@redhat.com>,
        David Rientjes <rientjes@google.com>, Joe Perches <joe@perches.com>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-sparse@vger.kernel.org, Michel Lespinasse <walken@google.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Pavel Pisa <pisa@cmp.felk.cvut.cz>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Daniel Santos <daniel.santos@pobox.com>
Subject: Re: [PATCH v2 01/10] compiler-gcc4.h: Reorder macros based upon gcc
 ver
References: <1349465759-20524-1-git-send-email-daniel.santos@pobox.com> <1349466169-20637-1-git-send-email-daniel.santos@pobox.com> <20121006174220.GB6110@liondog.tnic>
In-Reply-To: <20121006174220.GB6110@liondog.tnic>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/06/2012 12:42 PM, Borislav Petkov wrote:
>> @@ -56,10 +65,3 @@
>>  #define __visible __attribute__((externally_visible))
>>  #endif
>>  
>> -#if __GNUC_MINOR__ > 0
>> -#define __compiletime_object_size(obj) __builtin_object_size(obj, 0)
>> -#endif
>> -#if __GNUC_MINOR__ >= 3 && !defined(__CHECKER__)
>
> This last hunk doesn't apply since mainline has a "4" above instead of
> "3". And it has had a "4" since it got added by 4a3127693001c so unless
> I'm missing something, how did the 3 appear in your patches?
These are based against -mm, where another commit is already in that
changes it.  I was told that since that commit was already in -mm, to
not include it in the patch set:

6c620cf1536a0ce6a83ecaaaf05298dcc0f7d440 (committed 2012-09-27)

This was probably (at least partially) the result of the fiasco I had
with my email.

