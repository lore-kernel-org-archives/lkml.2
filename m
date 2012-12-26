Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754342Ab2LZK1b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 05:27:31 -0500
Received: from mail-oa0-f44.google.com ([209.85.219.44]:42882 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab2LZK12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 05:27:28 -0500
MIME-Version: 1.0
In-Reply-To: <CADpTngXfrV+DrgUjR2LEcesimieOT68Knv9jJGsR_2mRMd1w3g@mail.gmail.com>
References: <CADpTngXfrV+DrgUjR2LEcesimieOT68Knv9jJGsR_2mRMd1w3g@mail.gmail.com>
Date: Wed, 26 Dec 2012 11:27:27 +0100
Message-ID: <CADpTngXm=zWfBZJAZze6ze9iaDitdqBuy8rz9qDoCCVyLysH9A@mail.gmail.com>
Subject: Fwd: usb issues with 3.6.X and 3.7.X
From: Fabio Coatti <fabio.coatti@gmail.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        rydberg@euromail.se
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Forgot to CC: possibly interested people, sorry.


---------- Forwarded message ----------
From: Fabio Coatti <fabio.coatti@gmail.com>
Date: 2012/12/24
Subject: usb issues with 3.6.X and 3.7.X
To: linux-kernel@vger.kernel.org


Hi all,
I'm experiencing some usb-related issues with recent kernels (3.6.7
and 3.7.1 at least.)
Basically I have a V500 epson scanner that worked just fine with older
kernels; since last time I used it I've changed several kernels and
now the oldest that I have on my machine is 3.6.7.
Recently I tried to use the usb scanner without success.
I've read the 3.6.4 changelog because there seems to be a very similar
issue patched,

============
commit e4e29779ec498f4905461a13b6ba58ba4f60152b
Author: Henrik Rydberg <rydberg@euromail.se>
Date:   Sat Oct 13 12:20:36 2012 +0200
    usbdevfs: Fix broken scatter-gather transfer

    commit 014639003c77a51fc319c9fdf225e7747cb6e18d upstream.

    The handling of large output bulk transfers is broken; the same user
    page is read over and over again. Fixed with this patch.

============

But probably it is not the same issue, as I've tried with 3.7.1 and
3.6.7; the scanner works just fine if connected to a Mac, so I can
exclude hardware issues.

I've tried to look at usb traffic with usbmon, but honestly it's not
my ground :)

Basically, the scanner takes a lot of time to be identified by iscan
and once identified iscan claims to be unable to speak with the
scanner.

If this can be useful, here comes the usbmon capture with 3.7.1:
(it seems that some dialog happens only after 90 seconds from start,
andh at that moment the device is recognized. Of course, on other
laptops the scanner is identified at once)


09edf540 0.506456 S Co:2:009:0 s 00 09 0001 0000 0000 0
09edf540 0.506697 C Co:2:009:0 0 0
09edf540 0.506733 S Bo:2:009:2 - 2 =
    1b66
     . f
09edf540 0.507442 C Bo:2:009:2 0 2 >
09edf540 0.507456 S Bi:2:009:1 - 4 <
09edf540 0.508442 C Bi:2:009:1 0 1 =
    15
09edf540 0.508450 S Bi:2:009:1 - 42 <
09edf540 30.508543 C Bi:2:009:1 -2 0
08706a80 30.508563 S Bi:2:009:1 - 42 <
08706a80 60.509511 C Bi:2:009:1 -2 0
08706a80 60.509529 S Bi:2:009:1 - 42 <
08706a80 90.509970 C Bi:2:009:1 -2 0
087dd840 90.510030 S Co:2:009:0 s 02 01 0000 0081 0000 0
087dd840 90.510591 C Co:2:009:0 0 0
087dd840 90.510599 S Co:2:009:0 s 02 01 0000 0081 0000 0
087dd840 90.510840 C Co:2:009:0 0 0
087dd840 90.510845 S Co:2:009:0 s 02 01 0000 0002 0000 0
087dd840 90.511092 C Co:2:009:0 0 0
087ddb40 90.511159 S Co:2:009:0 s 00 09 0001 0000 0000 0
087ddb40 90.511341 C Co:2:009:0 0 0
087ddb40 90.511356 S Co:2:009:0 s 02 01 0000 0081 0000 0
087ddb40 90.511591 C Co:2:009:0 0 0
087ddb40 90.511597 S Co:2:009:0 s 02 01 0000 0002 0000 0
087ddb40 90.511841 C Co:2:009:0 0 0
087ddb40 90.511950 S Co:2:009:0 s 00 09 0001 0000 0000 0
087ddb40 90.512215 C Co:2:009:0 0 0
087ddb40 90.512225 S Co:2:009:0 s 02 01 0000 0081 0000 0
087ddb40 90.512465 C Co:2:009:0 0 0
087ddb40 90.512470 S Co:2:009:0 s 02 01 0000 0002 0000 0
087ddb40 90.512717 C Co:2:009:0 0 0
087ddb40 90.512761 S Co:2:009:0 s 00 09 0001 0000 0000 0
087ddb40 90.513091 C Co:2:009:0 0 0
087ddb40 90.513101 S Co:2:009:0 s 02 01 0000 0081 0000 0
087ddb40 90.513341 C Co:2:009:0 0 0
087ddb40 90.513346 S Co:2:009:0 s 02 01 0000 0002 0000 0
087ddb40 90.513591 C Co:2:009:0 0 0
087ddb40 90.513630 S Co:2:009:0 s 00 09 0001 0000 0000 0
087ddb40 90.513841 C Co:2:009:0 0 0
087ddb40 90.513850 S Co:2:009:0 s 02 01 0000 0081 0000 0
087ddb40 90.514090 C Co:2:009:0 0 0
087ddb40 90.514096 S Co:2:009:0 s 02 01 0000 0002 0000 0
087ddb40 90.514342 C Co:2:009:0 0 0

eb0f5780 103.718860 S Co:2:009:0 s 00 09 0001 0000 0000 0
eb0f5780 103.719113 C Co:2:009:0 0 0
eb0f5780 103.719144 S Bo:2:009:2 - 2 =
    1b66
     . f
eb0f5780 103.719612 C Bo:2:009:2 0 2 >
eb0f5780 103.719626 S Bi:2:009:1 - 4 <
eb0f5780 103.720612 C Bi:2:009:1 0 1 =
    15
31ff63c0 103.720653 S Bi:2:009:1 - 42 <
31ff63c0 133.721562 C Bi:2:009:1 -2 0
0861ca80 133.721579 S Bi:2:009:1 - 42 <
0861ca80 163.721714 C Bi:2:009:1 -2 0
eb054000 163.721733 S Bi:2:009:1 - 42 <
eb054000 193.722675 C Bi:2:009:1 -2 0
eb3d23c0 193.722707 S Co:2:009:0 s 02 01 0000 0081 0000 0
eb3d23c0 193.723171 C Co:2:009:0 0 0
eb3d23c0 193.723188 S Bo:2:009:2 - 2 =
    1b40
     . @
eb3d23c0 193.724046 C Bo:2:009:2 0 2 >
eb3d23c0 193.724055 S Bi:2:009:1 - 1 <
eb3d23c0 193.725044 C Bi:2:009:1 0 1 =
    15
eb3d23c0 193.725054 S Bo:2:009:2 - 2 =
    1b49
     . I
eb3d23c0 193.725169 C Bo:2:009:2 0 2 >
eb3d23c0 193.725176 S Bi:2:009:1 - 4 <
eb3d23c0 193.725294 C Bi:2:009:1 0 1 =
    15
eb3d23c0 193.725321 S Bo:2:009:2 - 2 =
    1c46
     . F
eb3d23c0 193.725421 C Bo:2:009:2 0 2 >
eb3d23c0 193.725428 S Bi:2:009:1 - 16 <
0868d300 253.727305 C Bi:2:009:1 -2 0
087d6a80 253.727321 S Bi:2:009:1 - 16 <
087d6a80 283.728362 C Bi:2:009:1 -2 0
08522240 283.728384 S Co:2:009:0 s 02 01 0000 0081 0000 0
08522240 283.729358 C Co:2:009:0 0 0
08522240 283.729369 S Bo:2:009:2 - 2 =
    1c49
     . I
08522240 283.730234 C Bo:2:009:2 0 2 >
08522240 283.730242 S Bi:2:009:1 - 80 <
08522240 313.730875 C Bi:2:009:1 -2 0
35ecc3c0 313.730896 S Bi:2:009:1 - 80 <
35ecc3c0 343.731089 C Bi:2:009:1 -2 0
0846d900 343.731111 S Bi:2:009:1 - 80 <
0846d900 373.731773 C Bi:2:009:1 -2 0
eb200180 373.731796 S Co:2:009:0 s 02 01 0000 0081 0000 0
eb200180 373.732147 C Co:2:009:0 0 0
eb200180 373.732160 S Bo:2:009:2 - 2 =
    1c46
     . F
eb200180 373.733020 C Bo:2:009:2 0 2 >
eb200180 373.733029 S Bi:2:009:1 - 16 <
eb200180 403.733182 C Bi:2:009:1 -2 0
eb054780 403.733200 S Bi:2:009:1 - 16 <
eb054780 433.733443 C Bi:2:009:1 -2 0
1dcbeb40 433.733463 S Bi:2:009:1 - 16 <
1dcbeb40 463.733936 C Bi:2:009:1 -2 0
08522240 463.733959 S Co:2:009:0 s 02 01 0000 0081 0000 0
08522240 463.734684 C Co:2:009:0 0 0

I'm available for any other information, just keep me cc'ed as I'm not
subscribed.

Many thanks for any answer.


--
Fabio


--
Fabio
