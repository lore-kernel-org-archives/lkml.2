Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156Ab0IBUu4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 16:50:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:65349 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752490Ab0IBUuy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 16:50:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=CHZVDzegdW/YcHH80gamLo7U7RWi2u6SzufiteTid/STx00RATOwZ6hnPVEiS0AP5G
         L7T64Bc3s1umJsXj+ydDElih0xwF2W0fbcO+ugTsTM9aHUoSiRcGjrRyxv20rTKiGVIL
         0AsoJdVpfDvxi7RTPNAkIo1+D0PDmxRUlLYjE=
MIME-Version: 1.0
In-Reply-To: <1283458331.5598.129.camel@haakon2.linux-iscsi.org>
References: <4C7FFB85.7000006@vlnb.net> <AANLkTikYgSrW-fSRNBMU2DWYk2x1xQSAqKhoW1Lijj4N@mail.gmail.com>
 <1283458331.5598.129.camel@haakon2.linux-iscsi.org>
From: Chris Weiss <cweiss@gmail.com>
Date: Thu, 2 Sep 2010 15:50:30 -0500
Message-ID: <AANLkTinf7OgOodts3dvpg99+PFwKtxM631MsLzrJx4mv@mail.gmail.com>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features between different
 SCSI targets (SCST, STGT, IET, LIO) updated
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        scst-devel <scst-devel@lists.sourceforge.net>,
        iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>,
        Mike Christie <michaelc@cs.wisc.edu>,
        Ross Walker <rswwalker@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 2, 2010 at 3:12 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>> as a user following the potential inclusion of a kernel-space target,
>> iscsi specifically, I would be very interested in seeing what other
>> pluses the other frameworks have over scst, because if this chart is
>> accurate, all the other targets have quite a ways to go to catch up.
>>
>
> Actually sorry, anyone who has spent more than 30 minutes looking at the
> TCM v4 code that has already been posted to linux-scsi on monday knows
> this list just more handwaving.  I suggest you start doing the same
> (actually discussion specific source file + line refrences) unless you
> actually want to trust this hopelessly out-of-date list on blind
> princaple.

I'm just an end user, I have no interesting in line-by-line
comparisons or specs details.  I do, however, have interest in bullet
points, and the lack of bullet points, that throw up red flags to 3rd
party support contracts.  So, did the kernel team, or some other
impartial source, compile a similar but not out of date list, and is
it available for viewing?

> First, understand that Vlad has been asked to produce a problem use case
> for his CRH=1 (Compatibility Reservation Handling) concerns using the
> SPC-3 RESERVE/RELEASE methods with the TCM v4 code.  He has been never
> been able to produce a use case, ever.  Also, just for reference, does
> SCST's SPC-3 persisent reservation handling actually properly support
> CRH=1 emulation from spc4r17..?  Last time I checked, it most certainly
> did *not*.

I haven't tested this specifically, and I'm not even sure that the use
case is right, but ESX (the only initiator i actually use) uses
reservations when expanding vmdk files for size, thin provisioning,
and snapshots.  If I'm running big expands on 2 separate ESX nodes on
the same iscsi or FC LUN, can you be sure that I won't have a
collision without reservations?  And I mean 100% absolute sure.

> Second, in terms of TM emulation / passthrough support in the TCM v4
> code, we follow what is implemented in drivers/scsi ML and LLDs,
> primarly to properly for Linux SCSI Initiators.  I honestly don't have
> alot of interesting currently in implementing all of the ancient TM
> emulation that none of the mainline SCSI LLDs in Linux implement today,
> or plan to do the future.  As for specific TM concerns, I am happy to
> address then on a case by case basis with the appropiate use case.

Vmware's ESX uses ABORT extensively with network errors and when the
targets backend goes belly up, and just plain goes nuts if it doens't
get the kind of response that completely makes sense to it, typically
requiring the ESX node to be rebooted to get out of a confused state.
Maybe this is a failure in ESX's initiator, but ESX is following the
specs, or at least they claim to be.

And a question that never got answered in another thread:  how many
OSS and commercial products are using LIO?  and how many of those are
certified and supported by other commercial products?  This is
directly related to impartial testing as well as standards
implementation, stability, and "plays nice with others".  Or in other
words, where I can look at an example implementation of LIO that's
considered by someone who is not you to be production ready?
