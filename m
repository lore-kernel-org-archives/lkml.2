Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab1ENXNq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 19:13:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:62317 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754722Ab1ENXNn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 19:13:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PDXJl76YCGvAeM0JFpr8LkDaSacx2uMBdnX5o6oNDYUrMp+e4GetyGQEMHnyuk+OMN
         SDP/o+rlQkCXVKxPl8QJ0FwchUagFq9QAO1dkP44eDMLAF8G3T5vhyLEGNK7Flb3k6cV
         svAHvsLY2aJ8Uno8koaaYkdAxFxUc8ePkRGN0=
MIME-Version: 1.0
In-Reply-To: <20110514204536.GA16496@1wt.eu>
References: <20110428082625.GA23293@pcnci.linuxbox.cz>
	<20110428183434.GG30645@1wt.eu>
	<20110429100200.GB23293@pcnci.linuxbox.cz>
	<20110430093605.GA10529@1wt.eu>
	<20110430173905.GA25641@tty.gr>
	<20110430201436.GF10529@1wt.eu>
	<20110514190423.GA2264@nik-comp.lan>
	<20110514204536.GA16496@1wt.eu>
Date: Sun, 15 May 2011 01:13:42 +0200
Message-ID: <BANLkTikow2BL5_YGHvE6HQDymODx3T0Mfg@mail.gmail.com>
Subject: Re: 2.6.32.21 - uptime related crashes?
From: Nicolas Carlier <chronidev@gmail.com>
To: Willy Tarreau <w@1wt.eu>
Cc: Nikola Ciprich <nikola.ciprich@linuxbox.cz>,
        Faidon Liambotis <paravoid@debian.org>, linux-kernel@vger.kernel.org,
        stable@kernel.org, seto.hidetoshi@jp.fujitsu.com,
        =?ISO-8859-1?Q?Herv=E9_Commowick?= <hcommowick@exosec.fr>,
        Randy Dunlap <rdunlap@xenotime.net>, Greg KH <greg@kroah.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Apollon Oikonomopoulos <apoikos@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, May 14, 2011 at 10:45 PM, Willy Tarreau <w@1wt.eu> wrote:
> Hi,
>
> On Sat, May 14, 2011 at 09:04:23PM +0200, Nikola Ciprich wrote:
>> Hello gentlemans,
>> Nicolas, thanks for further report, it contradicts my theory that problem occured somewhere during 2.6.32.16.
>
> Well, I'd like to be sure what kernel we're talking about. Nicolas said
> "2.6.32.8 Debian Kernel", but I suspect it's "2.6.32-8something" instead.
> Nicolas, could you please report the exact version as indicated by "uname -a" ?


Sorry, I can't provide more informations on this version because I
don't use it anymore, I can just corrected myself,  it was not a
2.6.32.8 kernel but a 2.6.32.7 backport debian kernel, which had been
recompiled.

Because of this problem I took the oportunity to change to a 2.6.32.26
kernel, however as there was nothing on the changelog or bugzilla
about the resolution of  this issue we have applied the patch found in
bugzilla which revealed this problem:

https://bugzilla.kernel.org/show_bug.cgi?id=16991#c17

>
>> Now I think I know why several of my other machines running 2.6.32.x for long time didn't crashed:
>>
>> I checked bugzilla entry for (I believe the same) problem here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=16991
>> and Peter Zijlstra asked there, whether reporters systems were running some RT tasks. Then I realised that all of my four crashed boxes were pacemaker/corosync clusters and pacemaker uses lots of RT priority tasks. So I believe this is important, and might be reason why other machines seem to be running rock solid - they are not running any RT tasks.
>> It also might help with hunting this bug. Is somebody of You also running some RT priority tasks on inflicted systems, or problem also occured without it?
>
> No, our customer who had two of these boxes crash at the same time was
> not running any RT task to the best of my knowledge.
>

Regards,

--
Nicolas Carlier
