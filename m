Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1BDAGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 19:06:25 -0500
Received: from mail-vx0-f174.google.com ([209.85.220.174]:64021 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754853Ab1BDAGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 19:06:22 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Zoc+5+7/CfD2fYN54BQ9NYOqgCqtQM8praSZ1E7gQ+3K//e88vqK7JVRhpX/XTubpW
         eSuTcr+etO+jfdhi4d1YfCCAr+ztsg+/eIIAMIqgQJW6Rtf8VQL0qd2NyrTrQFZ09B2F
         Qw4rnNB4cSlq3vzKFZvOtEAY510XbXIo4z3/Q=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=7EOih=fY5FCvhQbewSc=3a49cYVaKJRWM+-3d@mail.gmail.com>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
	<AANLkTikELiGS+fM5WguZS=Fo-sSXmej1UnKWqCFmnE0k@mail.gmail.com>
	<s5haaid3xos.wl%tiwai@suse.de>
	<201102032009.17100.rjw@sisk.pl>
	<AANLkTi=suS1VDL=6EtT0D2=0c1DWwxdwZBBv=-BySNX-@mail.gmail.com>
	<AANLkTi=7EOih=fY5FCvhQbewSc=3a49cYVaKJRWM+-3d@mail.gmail.com>
Date: Fri, 4 Feb 2011 10:06:19 +1000
Message-ID: <AANLkTin7kBur95H=UBcYEcjYsUkrdG8znX-7PFZ4rrHf@mail.gmail.com>
Subject: Re: 2.6.38-rc3-git1: Reported regressions 2.6.36 -> 2.6.37
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Carlos Mafra <crmafra2@gmail.com>, Keith Packard <keithp@keithp.com>,
        Dave Airlie <airlied@redhat.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Takashi Iwai <tiwai@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 4, 2011 at 8:10 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Thu, Feb 3, 2011 at 1:56 PM, Carlos Mafra <crmafra2@gmail.com> wrote:
>>>
>>> I added https://bugzilla.kernel.org/show_bug.cgi?id=24982 to the list of
>>> post-2.6.36 regressions for further tracking.
>>
>> I also tested on 2.6.38-rc3+ now and the issue is not solved,
>> just like Takashi expected.
>
> Hmm. That commit (bf9dc102e284) still reverts cleanly.
>
> Keith, Dave, should we just revert it? It's definitely a regression,
> and we do _not_ allow "fixes" to one thing that just causes a
> regression to another.
>
> Quite frankly, I think it's totally wrong to just blindly set DPMS
> status to ON like that. It's as wrong as it was to leave it off, and
> the regressions reported are basically mirror images of the exact same
> bug that that commit tried to fix.
>
> IOW, the commit message says:
>
>    When setting a new crtc configuration, force the DPMS state of all
>    connectors to ON. Otherwise, they'll be left at OFF and a future mode set
>    that disables the specified connector will not turn the connector off.
>
> but setting it to ON doesn't actually _fix_ anything, because you just
> get the exact same issue in reverse, ie you just get
>
>   .. and a future mode set  that ENables the specified connector will
>    not turn the connector ON.

If we are setting a mode on a connector it automatically will end up
in a DPMS on state,
so this seemed correct from what I can see.

A future mode set shouldn't ever not turn the connector on, since
modesetting is an implicit
DPMS,

It sounds like something more subtle than that, though I'm happy to
revert this for now, and let Keith
think about it a bit more.

Dave.
