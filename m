Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755751Ab0IAX53 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 19:57:29 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:57890 "HELO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751714Ab0IAX52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 19:57:28 -0400
MIME-Version: 1.0
In-Reply-To: <4C7E94F6.9050806@gmail.com>
References: <1283306184-28833-1-git-send-email-chase.douglas@canonical.com>
	<1283306184-28833-2-git-send-email-chase.douglas@canonical.com>
	<4C7E94F6.9050806@gmail.com>
Date: Wed, 1 Sep 2010 19:57:25 -0400
Message-ID: <AANLkTi=z5s8mbjG54930Lxj-O9Of2fXHE6kDJhijyOb7@mail.gmail.com>
Subject: Re: [PATCH 1/7 v3] HID: magicmouse: don't allow hidinput to
 initialize the device
From: Michael Poole <mdpoole@troilus.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Chase Douglas <chase.douglas@canonical.com>, Jiri Kosina <jkosina@suse.cz>,
        Henrik Rydberg <rydberg@euromail.se>, Tejun Heo <tj@kernel.org>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Slaby wrote:
> This looks weird. Is there any past discussion about why you cannot use
> hidinput and you have to do all the input bits yourself while cheating
> this very weird way?

(Resending because I didn't notice Gmail was in "rich text" mode, and
that kept my earlier message from reaching the vger lists.  Apologies
to the individuals who get a second copy of this message.)

The Magic Mouse and Magic Trackpad do not publish HID descriptors for
the multitouch reports.  Given the variable-length report packets --
and especially the Magic Trackpad's new, mutant DOUBLE_REPORT_ID
packets -- it would be non-trivial to write accurate descriptors that
the HID core can use.  (Someone wrote a patch to try that a few months
ago.  It ended up adding significantly more lines to hid-magicmouse.c
than it removed, and it was not obvious to me that it got the Report
Count fields correct.)

Michael Poole
