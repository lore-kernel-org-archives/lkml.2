Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab1GESjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 14:39:16 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:38456 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751347Ab1GESjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 14:39:14 -0400
MIME-Version: 1.0
In-Reply-To: <20110705180712.GA29224@polaris.bitmath.org>
References: <1309324042-22943-1-git-send-email-djkurtz@chromium.org>
	<1309324042-22943-3-git-send-email-djkurtz@chromium.org>
	<20110704210838.GA23915@polaris.bitmath.org>
	<CAGS+omDXhiZz2i5eniu_eOCES1Eq_fKs4JVWU-+wz6ot7kyhSA@mail.gmail.com>
	<20110705180712.GA29224@polaris.bitmath.org>
Date: Tue, 5 Jul 2011 13:39:13 -0500
Message-ID: <CAGzDe_b52m1Fn0o8d17Aqwwif2k2i5PpqtbNqsOQ2ujf_6-Lsw@mail.gmail.com>
Subject: Re: [PATCH 02/12] Input: synaptics - do not invert y if 0
From: Chris Bagwell <chris@cnpbagwell.com>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Daniel Kurtz <djkurtz@chromium.org>, dmitry.torokhov@gmail.com,
        chase.douglas@canonical.com, rubini@cvml.unipv.it,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        derek.foreman@collabora.co.uk, daniel.stone@collabora.co.uk,
        olofj@chromium.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 5, 2011 at 1:07 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
>> > > In some cases, however, y = 0 is sent by the touchpad.
>> > > In these cases, the kernel driver should not invert, and just report 0.
>> > >
>> > > This patch also refactors the inversion into a macro, and moves it
>> > > into packet processing instead of during position reporting.
>> >
>> > The patch seems to invert the current output?
>>
>> By 'current' do you mean referenced from the previous implementation?
>> Or referenced from the raw input.
>> It does indeed invert the raw input.
>> This is the same as the previous implementation did.
>> The difference is that it does not also invert the special 'y=0' into
>> an arbitrarily large value.
>> Is this your concern?
>
> It would be clearer to just change the argument of the
> input_report_abs() instances, would it not? An explanation why zero,
> outside the value range, should be output also needs a rationale. It
> would seem such packets should be masked somehow.
>

When I saw this, thats what it looked like to me.  We already know
that hw.x == 1 is invalid and added to a list to filter out but maybe
hw.y == 0 is invalid as well and it wasn't as obvious because of the
inversion.

Sound the following pre-existing line be expanded to its filtered?

       if (hw.z > 0 && hw.x > 1) {

Chris
