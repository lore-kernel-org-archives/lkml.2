Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755526Ab2D2BKE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 21:10:04 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:43731 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751748Ab2D2BKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 21:10:01 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/3] PM / QoS / Domains: Fixes and optimization, take 2
Date: Sun, 29 Apr 2012 03:08:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
References: <201204272346.44145.rjw@sisk.pl>
In-Reply-To: <201204272346.44145.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204290308.52416.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

On Friday, April 27, 2012, Rafael J. Wysocki wrote:
> 
> This series is on top of the PM domains governor functions fixup patches
> posted recently:
> 
> http://marc.info/?l=linux-pm&m=133538218801804&w=4
> http://marc.info/?l=linux-pm&m=133538220601826&w=4
> http://marc.info/?l=linux-pm&m=133538218801805&w=4
> 
> Patch [1/2] is a fix that I think should be applied anyway.  Patch [2/2],
> though, is an RFC.  It is a bit subtle, although perhaps that's not immediately
> visible at first sight.  Patch [2/2] hasn't been tested yet, but I have
> verified that it builds.

As it has happened to me for a couple of times recently, unfortunately,
I found a couple of issues with patch [2/2].

Most importantly, I forgot about the adaptive adjustments of device and domain
latency numbers, which obviously had to be taken into consideration in that
patch.  Also, it turned out during testig that there was a locking issue
in pm_genpd_remove_device() that wasn't very easy to address.  In the end,
I had to use an additional patch to help that, which is the current [2/3].

So, [1/3] is the previous [1/2] (with the Mark's ACK).  [2/3] is a new patch,
which is a pm_genpd_remove_device() cleanup that may be regarded as a fix too
and [3/3] is the one that makes the default PM domain governors cache their
results if possible (that's even more subtle than before, but hopefully
I didn't break anything this time).

Thanks,
Rafael

