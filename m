Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab0FAUoK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jun 2010 16:44:10 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:42039 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754245Ab0FAUoG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jun 2010 16:44:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=BX9GbQlOs3EZh1BneRU606sSejKSufTjCdw20AWJTo3uTxdNX6UPitCgcvwnhZAQjn
         EwVV/H6YGm4rg89hqqiHnFOw6RADxrARRFuuMEnAWOGX/jpXxCZ6jvzzyN7u5FCclVBA
         FhTPZxlNc2hDzfAfzR7cdsr3VKTHclK6CPIb4=
MIME-Version: 1.0
In-Reply-To: <201005311006.15282.br1@einfach.org>
References: <20100528100901.14580.1322.stgit@fate.lan> <20100528212523.213125g8t0an4mn4@hayate.sektori.org> 
	<1275078476.18152.10.camel@mj> <201005311006.15282.br1@einfach.org>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Tue, 1 Jun 2010 13:43:46 -0700
Message-ID: <AANLkTinIVgZTXlgecPSBJferexZ9CGr_F2jZWAimAmlf@mail.gmail.com>
Subject: Re: [ath5k-devel] [PATCH] ath5k: disable ASPM
To: Bruno Randolf <br1@einfach.org>
Cc: ath5k-devel@venema.h4ckr.net, Pavel Roskin <proski@gnu.org>,
       Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
       linux-wireless@vger.kernel.org,
       Stephen Hemminger <shemminger@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, bkuhn@softwarefreedom.org,
       linux-kernel@vger.kernel.org, BrianK.Lee@atheros.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: this e-mail thread is on a public mailing list.

Adding a few folks just for their information or in case they have
anything to add and It is also good to remind ourselves about best
practices for this stuff.

On Sun, May 30, 2010 at 6:06 PM, Bruno Randolf <br1@einfach.org> wrote:
> On Saturday 29 May 2010 05:27:56 Pavel Roskin wrote:
>> If we need to add GPL code to ath5k, it could go to a separate file.
>> But if that separation becomes inconvenient, we could drop BSD
>> compatibility from ath5k.  I don't see any benefit from dual licensing,
>> unless some existing ath5k contributors are BSD developers who would
>> stop working on the code in case of relicensing, but I don't think it's
>> the case.
>
> afaik, one of the reasons for the dual license is that *BSDs (our ancestors
> from a ath5k point of view) should be able to benefit from improvements we
> make.

Some clarifications on this.

Dual licensing GPL/BSD is typically done for the purpose of sharing
code between GPL codebases and permissive licensed codebases but I
should note that dual licensing GPL/BSD with this intention is legally
equivalent to just licensing under the BSD license. Also the
"Alternative" or "or" language used in dual licensing can sometimes be
left up to interpretation and confusion and for this same reason
SFLC's guidelines advise against this practice and instead recommend a
simple clear permissive license [1].

In ath9k's case all files are permissive licensed on purpose,
following SFLC's latest advice on this matter [1]. In ath5k only the
hardware files were *only* permissive licensed since those were the
files under review for sharing with OpenBSD. The other core driver
files have the dual license just because of historical purposes but
with the same intentions.

I should note though that when sharing permissive licensed files on a
larger GPL project it is also important to have in process a tag
mechanism to annotate when contributions made to a permissive licensed
file are indeed being kept under that same permissive licensed file.
In Linux this is accomplished by the Signed-off-by tag, which has as a
purpose stated under the 'Developer's Certificate of Origin 1.1':

------------------------------------------------------------------------------------------
        By making a contribution to this project, I certify that:

        (a) The contribution was created in whole or in part by me and I
            have the right to submit it under the open source license
            indicated in the file; or
------------------------------------------------------------------------------------------

For ath5k initially we used to use a more implicit
Changes-licensed-under tag but after a while this practice faded off
in favor for educating more on the meaning behind the Singed-off-by
tag, as stated above. There are more subsystems where this code
sharing happens with permissive licensed code bases and sticking to
the simple SOB makes it easier.

> this applies mostly to atheros chipset related things, and is irrelevant
> for linux-only implementation specifics.

Actually the Linux kernel has other places where we care to share with
the other BSD families, another example I am aware of is ACPI code.
There may be others, but I am not too sure.

> also we can mix BSD and GPL in one file - see debug.c

No, once you have GPL a file the entire driver becomes GPL as a whole,
the final binary that is. The ath5k/debug.c file is GPL, and future
contributions would be made only as GPL then. If you want to separate
permissive licensed changes from GPL changes that technically is
possible but its just a pain in the ass and silly. For this reason I
recommend to keep GPL files separate from permissive files. But yes,
it is also possible to keep some GPL files and some permissive
licensed files for a driver and ath5k is good example of such a case:

  * GPL files (debug.c)
  * Dual licensing for historical purposes (core driver)
  * Clean simple permissive license (ISC license, on hardware code)

[1] http://www.softwarefreedom.org/resources/2007/gpl-non-gpl-collaboration.html

  Luis
