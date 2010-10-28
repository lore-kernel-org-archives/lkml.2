Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756704Ab0J1KTy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 06:19:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59124 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755901Ab0J1KTw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 06:19:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=tsYxlXSqlMvBQsG68hNfYT6Zm6SLvcKdWdqutJ4m1vFQPhZarLMwcC9e6QZOvN1cdZ
         +hLKZwGS2WMu5kWqdjZ94K0L66pHQwgTbeI10/t4gLTiovjapANyqdBHvDCHJTL55jsr
         1YBwxHIpSRHaZycn304Qs76DIPEqwNqMCx4rk=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1010271725260.9704@router.home>
References: <AANLkTimzEDtfUKajFPgGOhifPhyRQboZbKNbypBaKpKO@mail.gmail.com>
	<alpine.DEB.2.00.1010260959250.10975@odin.tweek.dk>
	<alpine.DEB.2.00.1010271725260.9704@router.home>
Date: Thu, 28 Oct 2010 14:19:52 +0400
Message-ID: <AANLkTimOx=cMr+cwzEc8z7puZDEpa_7aDOxCPSzotjBP@mail.gmail.com>
Subject: Re: Tickles scheduler
From: Dragoslav Zaric <zaricdragoslav@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

1.Currently processes in the system are in some kind of list I think
(double circular).
So what if we assign each process structure (task_struct) property for
priority (maybe already there)
and another property which is time how long should run. So instead
having ticker in system,
each process runs itself predetermined period of time based on
priority and probably few more
parameters that should be in algorithm.

2. Second, when adding process into list, we can have separate side
lists, created in advance (something
like slab), where each lists hold tasks of same priority. So when we
add new process to list, at same
time we add it to his priority list. Than scheduler goes trough these
lists, based on priority and each
tasks hold it's running time. So we have two points to ease algorithm,
lists with single priority and time inside
each process task_struct related to priority.

3. In this way time-granularity of the system is high and allows for
real-time behavior, because we do
not have outside time that we "cut" in the middle when interrupt
happens, we just interrupt current process and when
finished, scheduler continue to walk trough lists of processes that
run its own time.

regards

On Thu, Oct 28, 2010 at 2:26 AM, Christoph Lameter <cl@linux.com> wrote:
> On Tue, 26 Oct 2010, Martin Nybo Andersen wrote:
>
>> On Tue, 26 Oct 2010, Dragoslav Zaric wrote:
>>
>> > [...]
>> >
>> > Is it at all possible to implement kernel without ticking, spin system
>> > by events and periods ?
>>
>> You can compile with CONFIG_NO_HZ=n if you want a ticking kernel.
>
> The kernel always ticks when a process is running CONFIG_NO_HZ does
> nothing for that.
>
>> > Maybe ticking is still best solution to have fast responding system ?
>
> I think we need a tickless kernel.... Yes....
>
>> My guesses are that it has already been benchmarked for speed, but you can
>> still test it yourself.
>> At least power usage/battery times is much better with a tickless kernel.
>
> Well yes CONFIG_NO_HZ really should say CONFIG_NO_HZ_IDLE. You have
> no ticks when a cpu is idle. Otherwise we are ticking...
>
>



-- 
Dragoslav Zaric

Professional Programmer
MSc Astrophysics
