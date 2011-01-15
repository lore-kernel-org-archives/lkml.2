Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974Ab1AOMZB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Jan 2011 07:25:01 -0500
Received: from mail-px0-f174.google.com ([209.85.212.174]:46796 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab1AOMY7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Jan 2011 07:24:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=n0XoeVXJ9OXYqF4/2OlD6vvLvRdfl/Ul+GOaW6ua1NwFmmrRv3l95RTuOHoDlehVdr
         AcFKJn9MMg/0LeMASrq3DASyUZiBza0DZkKqheAP72FLpm7A0tUgui2kzTFv/fAfyia0
         vb13PsHFc5sJ7zxUd+aa+gRu8/eGCN2aIFJJg=
MIME-Version: 1.0
In-Reply-To: <4D2EEEAA.7040200@suse.cz>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>
	<alpine.LFD.2.02.1101121257580.18873@x980>
	<20110112131800.d64c1a86.akpm@linux-foundation.org>
	<201101122224.54330.rjw@sisk.pl>
	<alpine.LFD.2.02.1101121654000.19754@x980>
	<4D2EEEAA.7040200@suse.cz>
Date: Sat, 15 Jan 2011 13:24:59 +0100
Message-ID: <AANLkTinpjHZgKhLN19kn=0o6aXbMAJEooEUtHSxGyotm@mail.gmail.com>
Subject: Re: on builds/randconfigs
From: Vegard Nossum <vegard.nossum@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-acpi@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Zhang Rui <rui.zhang@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Zimn@jasper.es,
        Arnaud Lacombe <lacombar@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13 January 2011 13:23, Michal Marek <mmarek@suse.cz> wrote:
> On 12.1.2011 22:58, Len Brown wrote:
>>>> These unusable config combinations should be prevented via Kconfig.
>>>> That prevents users from selecting them, which otherwise adds to
>>>> our workload and to theirs.  It also prevents false-positives
>>>> during our useful randconfig testing.
>>>
>>> But it is kind of difficult to achieve IMhO.  For example, there are options
>>> that are only SELECTed if something else is set, but randconfig doesn't seem
>>> to care.
>>
>> Kconfig select needs to be fixed so that it is not possible to
>> select something if that something's dependencies are not met.
>
> Right now, it issues a warning in such case. I think changing it to a
> fatal error would be too premature, not long ago there were a couple of
> annoying false positives.
>
> But from the rest of the thread, I conclude that you actually meant "not
> possible to select something if that something's dependencies CANNOT be
> met", i.e. automatically select dependencies if that is possible. That
> was actually one of the goals of Vegard Nossum's GSoC poject last year,
> but I haven't heard of any outcome yet. Vegard, is there something we
> could use, be it code or mistakes we could learn from?

Maybe I am wrong, but doesn't conf_write() actually take care of this
when it does that sym_calc_value() for all the symbols? Or maybe
that's the problem (i.e. that it doesn't).

Current satconfig code can be changed to produce random configs (that
nevertheless respect the user's choices) with a 1-line patch. But
there are some other issues to be worked out, mainly that conf_write()
doesn't respect all the choices that the SAT solver made. There could
be several reasons for that: 1. satconfig doesn't deal with
hex/int/string values and relies on conf_write() to fill in those
(this is a plain old bug), 2. the translation into boolean logic is
subtly wrong, perhaps a corner case or something like that, and/or 3.
conf_write() does something wrong.

I'll be happy to give a tour of the satconfig code if you or anybody
else would like to start hacking on it.


Vegard
