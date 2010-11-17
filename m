Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934447Ab0KQGaP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 01:30:15 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:47482 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934408Ab0KQGaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 01:30:12 -0500
Date: Wed, 17 Nov 2010 15:30:06 +0900
From: Norbert Preining <preining@logic.at>
To: Mattia Dongili <malattia@linux.it>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>
Subject: Re: regression since 2.6.36: backlight in sony-laptop not working
Message-ID: <20101117063006.GF29129@gamma.logic.tuwien.ac.at>
References: <20101104142915.GC7650@gamma.logic.tuwien.ac.at> <20101110035833.GB3029@kamineko.org> <20101111235000.GA6651@gamma.logic.tuwien.ac.at> <20101112034423.GA7407@srcf.ucam.org> <20101112035027.GD26742@gamma.logic.tuwien.ac.at> <20101112035732.GB7574@srcf.ucam.org> <20101112042243.GE2852@kamineko.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101112042243.GE2852@kamineko.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mattia, hi Dmitry,

On Fr, 12 Nov 2010, Mattia Dongili wrote:
> backlight (actually Fn+F[56]) is one of those keys the needs remapping
> these days, i.e. if xev doesn't get any event in X then you may need
> something like:

Ok, I have now done the fllowing:
- recompiled a input-kbd binary with a relaxed version check
	-	if (EV_VERSION != version) {
	+	if (EV_VERSION > version) {
  in input.c, line 104 of input-utils.

- created a vaio-kbd from the output of input-kbd and changed the
  keys that hat keycode 470 and 471 (those shown in evtest 8)
  to key_brightness:

$ diff -u <(./input-kbd 8) vaio-kbd
--- /dev/fd/63	2010-11-17 15:24:32.023696588 +0900
+++ vaio-kbd	2010-11-17 15:24:02.000000000 +0900
@@ -13,8 +13,8 @@
 0x0006 = 467  # KEY_FN_F2
 0x0007 = 468  # KEY_FN_F3
 0x0008 = 469  # KEY_FN_F4
-0x0009 = 470  # KEY_FN_F5
-0x000a = 471  # KEY_FN_F6
+0x0009 = 224  # KEY_BRIGHTNESSDOWN
+0x000a = 225  # KEY_BRIGHTNESSUP
 0x000b = 472  # KEY_FN_F7
 0x000c = 473  # KEY_FN_F8
 0x000d = 474  # KEY_FN_F9
$

remember:
evtest /dev/input/event8 reports code 470 and code 471 for the respective
Fn-F5 and Fn-F6 combinations.

> output to a file, edit it to change the keys you need remapped and run
> `input-kbd -f <file> <devNo>`.

Then I run
	$ ./input-kbd -f vaio-kbd 8
	/dev/input/event8
	map: 44 keys, size: 59/64
	parse error: /dev/input/event8
	$
with the effect that still brigthness is not working.

If someone can explain what is wrong here and how to get this fixed
that would be nice, because up to now on the sony-vaio mailing list
I heard many complains about disappearing brightness, I hope we can
fix that.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
SNITTERBY (n.)
Someone who pins snitters (q.v.) on to snitterfields (q.v.) and is
also suspected of being responsible for the extinction of virginstows
(q.v.)
			--- Douglas Adams, The Meaning of Liff
