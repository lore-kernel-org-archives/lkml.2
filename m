Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab1DEObM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Apr 2011 10:31:12 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:33436 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049Ab1DEObL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Apr 2011 10:31:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=c7HJ5PHrJWZm0NyEJ3ogK3Gu5Z6PQhoexNkMgJJV01HrBy8e7c8FQSmswurRjS+xmA
         ndACYxg39ddNjs/KVJbOC9xgLeCRREvN5P7z73cDte6dEspTAoJiyKMWTx8OxXY8fprK
         sEX89mnSk+XyGe0KXxD2KgnYDMs4IrVPt2/Gs=
MIME-Version: 1.0
In-Reply-To: <1bdc18$k44m31@fmsmga002.fm.intel.com>
References: <AANLkTi=VqkYjdiDLJvM-OfmBSGx-EkRkt=4XCDEnvZsU@mail.gmail.com>
	<1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk>
	<20110401114429.GA3526@viiv.ffwll.ch>
	<AANLkTik6njOQTLGsB4KzPP-J=fE=p4CHopAyvsDzdDSF@mail.gmail.com>
	<BANLkTimUZY+2E=kXG-as8-moAAS4+F5bTg@mail.gmail.com>
	<b7da2f$qvoau5@fmsmga001.fm.intel.com>
	<BANLkTi=kXod21RUukrTuMzP5TFqgo4NxRw@mail.gmail.com>
	<BANLkTins76X1mOFepqXEQjMEh_hd4Vgw1Q@mail.gmail.com>
	<1bdc18$k44m31@fmsmga002.fm.intel.com>
Date: Tue, 5 Apr 2011 17:31:10 +0300
X-Google-Sender-Auth: 184Vf84AQW-SJF4H42TDURwcLIA
Message-ID: <BANLkTik-bAeJKw0GdTdxRYSP+Hes3ua9vw@mail.gmail.com>
Subject: Re: [Intel-gfx] [PATCH] drm/i915: Disable all outputs early, before
 KMS takeover
From: Pekka Enberg <penberg@kernel.org>
To: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tomas Winkler <tomasw@gmail.com>, intel-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, Daniel Vetter <daniel@ffwll.ch>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 5, 2011 at 5:27 PM, Chris Wilson <chris@chris-wilson.co.uk> wrote:
> On Tue, 5 Apr 2011 17:11:56 +0300, Pekka Enberg <penberg@kernel.org> wrote:
>> [    9.310010]  <IRQ>  [<ffffffff8168cd0c>] panic+0x91/0x19e
>> [    9.310010]  [<ffffffff816909ea>] oops_end+0xea/0xf0
>> [    9.310010]  [<ffffffff8106afbb>] no_context+0xfb/0x260
>> [    9.310010]  [<ffffffff8106b245>] __bad_area_nosemaphore+0x125/0x1e0
>> [    9.310010]  [<ffffffff8106b313>] bad_area_nosemaphore+0x13/0x20
>> [    9.310010]  [<ffffffff816930c0>] do_page_fault+0x310/0x4c0
>> [    9.310010]  [<ffffffff810ac06f>] ? up+0x2f/0x50
>> [    9.310010]  [<ffffffff8108652f>] ? console_unlock+0x17f/0x1d0
>> [    9.310010]  [<ffffffff8168fd25>] page_fault+0x25/0x30
>> [    9.310010]  [<ffffffffa0061628>] ? i915_handle_error+0x198/0xed0 [i915]
>> [    9.310010]  [<ffffffff8137d04a>] ? scsi_next_command+0x4a/0x60
>> [    9.310010]  [<ffffffff8137ddd6>] ? scsi_io_completion+0x2f6/0x630
>> [    9.310010]  [<ffffffffa0064c62>] i915_driver_irq_handler+0x472/0x17f0 [i915]
>>
>> This is the same pre-2.6.39-rc1 kernel with the two patches applied.
>> I'll try latest Linus master next to see if the same problem triggers.
>
> Hmm. Looks like we don't prevent the PGTBL_ER with those patches (or we
> provoke another), and trigger the error before we can handle it.

I'm guessing it's the same PGTBL_ER I've seen for the past two-three
kernel releases during boot. It seems to be harmless otherwise.
