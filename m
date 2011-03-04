Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932289Ab1CDQmR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 11:42:17 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48862 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752185Ab1CDQmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 11:42:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=KbiQMPGTAFoVP4Y/KzXheF3S1rEJWhsUsggDIbCI1XAT0ZAtA59R1pWJjwtNDENBBX
         o7ldhZCOMhzElkD0l3eQE7bOLuFwrPAbXT6vxDdeH3rcvIYSl90YDgehSad+mPE0DwAs
         wGPszTNy/R4tvju4dtQDW8kkzmi6dhdQzCRf4=
MIME-Version: 1.0
In-Reply-To: <20110304161441.GA12987@host1.jankratochvil.net>
References: <20110301152457.GE26074@htj.dyndns.org> <20110301190638.GA12196@host1.dyn.jankratochvil.net>
 <AANLkTiknaHNADRa3R4Tefg2TGuFmKPZY-_08_krFiNFF@mail.gmail.com> <20110304161441.GA12987@host1.jankratochvil.net>
From: Denys Vlasenko <vda.linux@googlemail.com>
Date: Fri, 4 Mar 2011 17:41:21 +0100
Message-ID: <AANLkTikk=4ssOYBK8+11ydp+-Y1-B6_wd0yYb6OKcz8Z@mail.gmail.com>
Subject: Re: [RFC] Proposal for ptrace improvements
To: Jan Kratochvil <jan.kratochvil@redhat.com>
Cc: Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 4, 2011 at 5:14 PM, Jan Kratochvil
<jan.kratochvil@redhat.com> wrote:
> On Tue, 01 Mar 2011 23:14:14 +0100, Denys Vlasenko wrote:
>> On Tue, Mar 1, 2011 at 8:06 PM, Jan Kratochvil <jan.kratochvil@redhat.com> wrote:
>> > Currently it is already a problem that apps did not / do not expect the first
>> > waitpid after PTRACE_ATTACH may not be SIGSTOP.
>>
>> That's exactly why we want to add a better alternative, which doesn't
>> insert that blasted SIGSTOP.
>
> But it inserts blasted SIGTRAP (or some other signal) instead.

Not a problem. The problem with SIGSTOP is that we race against
possible real SIGSTOP.

> It would be best if such PTRACE_SEIZE (similar to PTRACE_INTERRUPT)

My understanding is that those are the same idea with different names.

> would
> guarantee the first waitpid afterwards returns the artificial signal from
> PTRACE_SEIZE.

Yes.

-- 
vda
