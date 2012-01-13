Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab2AMWTu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 17:19:50 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:47642 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754142Ab2AMWTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 17:19:49 -0500
Message-ID: <4F10AE01.4090707@gmail.com>
Date: Fri, 13 Jan 2012 23:19:45 +0100
From: Enrico Mattea <ocirne94@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111124 Thunderbird/8.0
MIME-Version: 1.0
To: el es <el.es.cr@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: HID device calibration - how to override mapping?
References: <4F1051CA.4090007@gmail.com> <loom.20120113T175122-168@post.gmane.org>
In-Reply-To: <loom.20120113T175122-168@post.gmane.org>
Content-Type: multipart/mixed;
 boundary="------------050907030002050203060901"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050907030002050203060901
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Hi el es, thank you for your answer.

Il 13/01/2012 18:09, el es ha scritto:
>
> released - halfway - pressed
> 0 - (-32767)<->  (32767) - 0
> but does it happen in reverse order when releasing pedal ?

Yes, it does - perfect reverse order.
> seems the interpretation of this is up to the application really,
> but /if/ the -32767 to 32767 change happens all around the 'halfway'
> spot, maybe it is (in the app. engine) interpreted as 'change'
> and it's effect applied to 'car engine' not directly, but integrated
> (time-integral function applied) first ?
I don't think that the change is interpreted, because the clutch value 
seems to be computed directly, i.e. applying the app. calibration value 
on the the axis value received from the kernel;
even if I'm not completely familiar with the app.'s code, the attached 
code snippet is the interested part of the clutch handler of the app, 
and it doesn't seem to have any other function applied.
> I'd say, for the clutch simulation it's the /change-in-time/ that
> matters, not the /exact/ value; so no 'static' calibration is
> ever going to be relevant (bar maybe the device telling us when the
> pedal is fully pressed or fully released - in case app is not tracking
> it)
I agree, but trying to calibrate the axis produces the 'jump' effect 
also on the clutch value, so that either the first half of the axis 
isn't taken into account, or it produces full clutch already at halfway, 
and then value 0 after the halfway spot.

Thank you for your support,
Ocirne

--------------050907030002050203060901
Content-Type: text/x-c++src;
 name="clutch.cpp"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="clutch.cpp"

CQljYXNlIEdGQ1RSTF9UWVBFX0pPWV9BWElTOgoJCQljbHV0Y2ggPSBqb3lJbmZvLT5heFtj
bWRbQ01EX0NMVVRDSF0udmFsXTsKCQkJaWYgKGNsdXRjaCA+IGNtZFtDTURfQ0xVVENIXS5t
YXgpIHsKCQkJCWNsdXRjaCA9IGNtZFtDTURfQ0xVVENIXS5tYXg7CgkJCX0gZWxzZSBpZiAo
Y2x1dGNoIDwgY21kW0NNRF9DTFVUQ0hdLm1pbikgewoJCQkJY2x1dGNoID0gY21kW0NNRF9D
TFVUQ0hdLm1pbjsKCQkJfQoJCQljYXItPl9jbHV0Y2hDbWQgPSBmYWJzKGNtZFtDTURfQ0xV
VENIXS5wb3cgKgoJCQkJCQlwb3coZmFicygoY2x1dGNoIC0gY21kW0NNRF9DTFVUQ0hdLm1p
blZhbCkgLwoJCQkJCQkJKGNtZFtDTURfQ0xVVENIXS5tYXggLSBjbWRbQ01EX0NMVVRDSF0u
bWluKSksCgkJCQkJCTEuMGYgLyBjbWRbQ01EX0NMVVRDSF0uc2VucykpOwoJCQlicmVhazs=
--------------050907030002050203060901--
