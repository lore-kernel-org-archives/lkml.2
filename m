Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758757Ab2C1VWe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 17:22:34 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40736 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758641Ab2C1VWc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 17:22:32 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] firmware_class: Fix problems with usermodehelper test
Date: Wed, 28 Mar 2012 23:19:54 +0200
User-Agent: KMail/1.13.6 (Linux/3.3.0+; KDE/4.6.0; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Christian Lamparter <chunkeey@googlemail.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        alan@lxorguk.ukuu.org.uk,
        Linux PM mailing list <linux-pm@vger.kernel.org>
References: <201203032122.36745.chunkeey@googlemail.com> <201203200000.43316.rjw@sisk.pl> <201203260000.34377.rjw@sisk.pl>
In-Reply-To: <201203260000.34377.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201203282319.54708.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Monday, March 26, 2012, Rafael J. Wysocki wrote:
>
> The following series of patches fixes two problems with
> request_firmware() and request_firmware_nowait() resulting from commit
> a144c6a6c924aa1da04dd77fb84b89927354fdff
> 
>     PM: Print a warning if firmware is requested when tasks are frozen
> 
> The first problem is that request_firmware_nowait() may fail if it happens
> to run in parallel with system suspend.  It should't fail in such situations
> and that is addressed by the first three patches (that code has been discussed
> with Linus at al already).
> 
> The second issue is that request_firmware() may be called in a thread which
> isn't related to system suspend and if suspend happens exactly at that time,
> request_firmware() will fail (and print a scary warning), although it shouldn't.
> This problem is addressed by the remaining three patches, which are new.

The following series is a respin of this one including fixes of minor bugs
found by the reviewers in the previous version and two additional patches
from Stephen cleaning up things a bit more.

Since patches [1-6/8] fix regressions, I'd like the series to go into v3.4
if that's not too late.

[1/8] - Rework the usermodehelper check in _request_firmware().
[2/8] - Split _request_firmware() into three functions.
[3/8] - If firmware is to be loaded asynchronously, wait for usermodehelper_disabled
        to be unset instead of failing the operation.
[4/8] - Unify the hibernation/suspend code's usage of usermodehelper_disable().
[5/8] - Move usermodehelper_disable() into freeze_processes().
[6/8] - Make freezable threads calling request_firware() avoid the race with the
        freezer.
[7/8] - Split up fw_create_instance() to avoid casting out of const in it.
[8/8] - Use workqueues instead of kthreads in request_firmware_nowait().

Thanks,
Rafael

