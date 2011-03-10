Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753410Ab1CJWb4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 17:31:56 -0500
Received: from smtp.nokia.com ([147.243.1.48]:57849 "EHLO mgw-sa02.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab1CJWby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 17:31:54 -0500
From: Phil Carmody <ext-phil.2.carmody@nokia.com>
To: gregkh@suse.de
Cc: ext-phil.2.carmody@nokia.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: [PATCHv3 0/1] sysfs: add more info to the oops dump
Date: Fri, 11 Mar 2011 00:27:06 +0200
Message-Id: <1299796027-3343-1-git-send-email-ext-phil.2.carmody@nokia.com>
X-Mailer: git-send-email 1.7.2.rc1.37.gf8c40
In-Reply-To: <20110310212746.GA3361@suse.de>
References: <20110310212746.GA3361@suse.de>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> But would the trace-back also have shown you the problem?  If not, then
> that's a good reason to keep this feature, and to add your patch.

In this sample size of one, the write handler was so overloaded
the data written was very valuable compared to the backtrace.

> Looks nicer, but you forgot to address the "magic value" trick you used
> that I mentioned last time.  Please fix that up.

My bad, sorry. I also realised that I'd never actually tested the read
case, which highlighted a mixed-sign comparison issue. In a linux-2.6
context this hasn't been more than compile tested, my testing has been
done in our maemo tree.

cat /sys/module/vt/parameters/default_utf8; echo c > /proc/sysrq-trigger
[   13.489440] last sysfs file (r): /sys/module/vt/parameters/default_utf8

echo sesquipedalian > /sys/module/vt/parameters/default_utf8; echo c > /proc/sysrq-trigger
[   49.404632] last sysfs file (w): /sys/module/vt/parameters/default_utf8  written: sesquipedalian

echo sesquipedalianism > /sys/module/vt/parameters/default_utf8; echo c > /proc/sysrq-trigger  
[   33.172332] last sysfs file (w): /sys/module/vt/parameters/default_utf8  written: sesquipedaliani...(18 chars)

Sorry for the ping-pong.

Cheers,
Phil
