Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab0IPEpM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Sep 2010 00:45:12 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62408 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab0IPEpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Sep 2010 00:45:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=oXzuT8kdGVVrAg9AS5HRWlFRlPOBYidsircfSthSJsJMkZqVKxqsFlBpoJWciL8VQh
         E1pCq3AOzXdASKeHMf4Z67S2Y2voox9kMG7yTpsEPcvNbpZZmVrG8ExP8/TeS1VI3meQ
         5O+DxVM3SWj3Wvx9N8tlO/mZNyOkXy6N9kgpw=
MIME-Version: 1.0
In-Reply-To: <AANLkTikHfDUh3LdmyA5eMNACFPfi6pqGLFJiyzVm79X_@mail.gmail.com>
References: <tip-54ff7e595d763d894104d421b103a89f7becf47c@git.kernel.org>
	<alpine.LFD.2.00.1009151500060.2416@localhost6.localdomain6>
	<AANLkTineVitetJgKS2AsZUMvuuxDhcPF45dFWK8rtFfd@mail.gmail.com>
	<AANLkTikHfDUh3LdmyA5eMNACFPfi6pqGLFJiyzVm79X_@mail.gmail.com>
Date: Thu, 16 Sep 2010 00:45:09 -0400
Message-ID: <AANLkTi=1SyZe=G1DCPcccnRRsTtqYow-0-92PPqWq=jE@mail.gmail.com>
Subject: Fwd: [PATCH RFC] x86: hpet: Avoid the readback penalty
From: John Drescher <drescherjm@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 15, 2010 at 9:54 AM, John Drescher <drescherjm@gmail.com> wrote:
> On Wed, Sep 15, 2010 at 9:11 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> On Tue, 14 Sep 2010, tip-bot for Thomas Gleixner wrote:
>>> x86: hpet: Work around hardware stupidity
>>
>> After my brain recovered from yesterdays exposure with the x86 timer
>> horror, I came up with a different solution for this problem, which
>> avoids the readback of the compare register completely. It works
>> nicely on my affected ATI system, but needs some exposure to the other
>> machines.
>>
>> Comments ?
>>
>
> I can test this on my i7 machine in tonight (around 12 hours from now).

Seems to work fine on my i7 box. I applied the first patch to
2.6.36-rc4-git2 then after that I applied the new patch from this
email. Both patches applied cleanly and I am now running the patched
kernel without any issue. I turned off the clocksource=acpi_pm
workaround I had enabled from the original problem.

jmd1 ~ # uname -a
Linux jmd1 2.6.36-rc4-git2-no-penalty #3 SMP PREEMPT Wed Sep 15
21:25:53 EDT 2010 x86_64 Intel(R) Core(TM) i7 CPU 920 @ 2.67GHz
GenuineIntel GNU/Linux

John



-- 
John M. Drescher
