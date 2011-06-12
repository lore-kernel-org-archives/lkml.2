Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1FLSHx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 14:07:53 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:63313 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751018Ab1FLSHv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 14:07:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=eyFApOrIyqsEJS1LqqgXSgTrRg+DG/pDMR4Ikt037VU3OUbsO3fRHdvfYyUcQwj/Ck
         QrUEjLNoM4DwSXLN9YkkyUSgi9zZKDqHIVoDkJgXff0rYBxLcU7tJejaEMH/tJppwiIM
         tIW5m1nfL282r37qtYzH8xzfhRyHnK7H2HSHI=
MIME-Version: 1.0
In-Reply-To: <20110612152915.GA18794@polaris.bitmath.org>
References: <1307859728-3446-1-git-send-email-benjamin.tissoires@enac.fr>
	<20110612152915.GA18794@polaris.bitmath.org>
Date: Sun, 12 Jun 2011 20:07:49 +0200
X-Google-Sender-Auth: KH0fUwPgLuMpssL2fueeAmqGgG4
Message-ID: <BANLkTikRPnNNVp=78BxvYZzp5A2HbBYEUg@mail.gmail.com>
Subject: Re: [PATCH] hid-multitouch: fix broken eGalax
From: Benjamin Tissoires <benjamin.tissoires@enac.fr>
To: Henrik Rydberg <rydberg@euromail.se>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@lii-enac.fr>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Henrik,

On Sun, Jun 12, 2011 at 17:29, Henrik Rydberg <rydberg@euromail.se> wrote:
> Hi Benjamin,
>
>> With this patch, the detection is made only when the field ContactID
>> has been detected inside the collection.
>
> The patch introduces an order dependence by relying on ContactID
> occuring early on, which seems unnecessary. How about checking for the
> presence of ContactID instead, and simply modify the logic which uses
> last_field_index and last_slot_field?

That's exactly what it does. A touch report has to contain the
contactID field. And each touch is at least in one collection (some
devices send one touch per collection, others only one collection for
the whole report).
The idea is when hardware makers introduce several input mode for
their device, they has to put them in different collections.

The logic behind the last_field_index and last_slot_field are only for
multitouch. So it does not matter if the contactID comes first or last
in the collection, it will set the right index/field.

Cheers,
Benjamin

>
> Thanks,
> Henrik
>
