Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756373Ab1KHT7m (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 14:59:42 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63871 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969Ab1KHT7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 14:59:41 -0500
MIME-Version: 1.0
Date: Tue, 8 Nov 2011 13:59:40 -0600
X-Google-Sender-Auth: gI5UlBLxTCHHba0b-MPnnmcfw8g
Message-ID: <CAMLZHHTSuHZoPbm_YfB8G05JA+xKCE4+Jmj4NW8mnZUHogQSBA@mail.gmail.com>
Subject: Geode LX boot fails after x86 microcode revision change
From: Daniel Drake <dsd@laptop.org>
To: borislav.petkov@amd.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Linux-3.1 works fine on OLPC XO-1 (Geode LX) but latest linus master
fails to boot. It hangs so early on that we don't even receive any
output over serial.

git bisect tracked it down to:


commit bcb80e53877c2045d9e52f4a71372c3fe6501f6f
Author: Borislav Petkov <borislav.petkov@amd.com>
Date:   Mon Oct 17 16:34:36 2011 +0200

    x86, microcode, AMD: Add microcode revision to /proc/cpuinfo

    Enable microcode revision output for AMD after 506ed6b53e00 ("x86,
    intel: Output microcode revision in /proc/cpuinfo") did it for Intel.

    Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>


Any thoughts?

Thanks,
Daniel
