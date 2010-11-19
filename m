Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755871Ab0KSQjc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 11:39:32 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45795 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755329Ab0KSQj3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 11:39:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=tHZ4rhng/Gp4n9Fo2KNDzwq1X6Qb62zK0UPxSOP6syx7SJCi9gtVnGzoz1azZsdoiN
         6I/9HdbdAmh7U/YZIaj12BmvNsFHeHEFR9S5Oc0DwBGK67UddyTlNWQl2GInhMaAImT+
         csou9TmhCpayYCm421kzccYN9vaTTmL/WigzE=
MIME-Version: 1.0
In-Reply-To: <4CE5C919.7090504@teksavvy.com>
References: <tTUH_XeInOH.A.dMF.c3b5MB@chimera>
	<4CE5C919.7090504@teksavvy.com>
Date: Fri, 19 Nov 2010 11:39:26 -0500
Message-ID: <AANLkTi=8G7pNA7QTxaXDWKrWrCERPfmKU+nLJWCA=JUH@mail.gmail.com>
Subject: Re: 2.6.37-rc2-git4: Reported regressions 2.6.35 -> 2.6.36
From: Alex Deucher <alexdeucher@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 18, 2010 at 7:47 PM, Mark Lord <kernel@teksavvy.com> wrote:
> On 10-11-18 06:50 PM, Rafael J. Wysocki wrote:
>>
>> This message contains a list of some post-2.6.35 regressions introduced
>> before
>> 2.6.36, for which there are no fixes in the mainline known to the tracking
>> team.
>> If any of them have been fixed already, please let us know.
>>
>> If you know of any other unresolved post-2.6.35 regressions, please let us
>> know
>> either and we'll add them to the list.  Also, please let us know if any
>> of the entries below are invalid.
>
>> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=21652
>> Subject         : several problems with intel graphics since 2.6.36
>> Submitter       : Norbert Preining<preining@logic.at>
>> Date            : 2010-10-27 14:32 (23 days old)
>> Message-ID      :<20101027143252.GA8676@gamma.logic.tuwien.ac.at>
>> References      : http://marc.info/?l=linux-kernel&m=128818998630241&w=2
>
> That one is interesting to me.. I suspect it may be the same cause
> as for https://bugzilla.kernel.org/show_bug.cgi?id=21952
>
> I have one of those Samsung (N210) Netbooks here: works fine with 2.6.34 and
> earlier,
> but fails to come out of suspend on 2.6.35/2.6.36 (haven't tried 2.6.37).
>
> So perhaps add 21952 to the list, or link it to the 21652
> (kind of amusing how similar the bug numbers are..).
>
>
> My non-Intel graphics notebook (has ATI X1400 graphics) also has a resume
> regression with 2.6.36.  But it does work fine with 2.6.35 (and earlier,
> back many years).  As a result, I'm stuck with 2.6.35 for the time being,
> and lack the time for a concerted debug effort on 2.6.36+ right now.
>

Can you bisect?  Does this patch help?

diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
index 8e421f6..05efb5b 100644
--- a/drivers/gpu/drm/radeon/atom.c
+++ b/drivers/gpu/drm/radeon/atom.c
@@ -112,6 +112,7 @@ static uint32_t atom_iio_execute(struct
atom_context *ctx, int base,
                        base += 3;
                        break;
                case ATOM_IIO_WRITE:
+                       (void)ctx->card->ioreg_read(ctx->card, CU16(base + 1));
                        ctx->card->ioreg_write(ctx->card, CU16(base + 1), temp);
                        base += 3;
                        break;


Alex

> Cheers
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
