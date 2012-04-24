Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757867Ab2DXVrP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 17:47:15 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34999 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757026Ab2DXVrN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 17:47:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Linux PM list <linux-pm@vger.kernel.org>
Subject: [PATCH 0/3] PM / Domains: Fix device stop and domain power off governor functions
Date: Tue, 24 Apr 2012 23:49:26 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc4+; KDE/4.6.0; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>, Kevin Hilman <khilman@ti.com>,
        Magnus Damm <magnus.damm@gmail.com>, linux-sh@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        markgross@thegnar.org, Jean Pihet <j-pihet@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204242349.26288.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

It turns out that the PM domains device stop and domain power off governor
functions I invented some time ago don't really make sense, because they
should only decide whether or not the resulting low-power state will be
too deep and that only depends on latencies.  In particular, the time
when devices have been suspended doesn't really matter here, so the
results returned by those functions shouldn't depend on it either (as it
shouldn't depend on any "break even" values that only make sense when we
know how much time in advance the device is going to be used, but this
information is not related to the PM QoS latency constraint).

If this functions are fixed (patches [1/3] and [2/3]), then some ugly
computations can be removed from rpm_suspend() and other places and the
whole framework can be simplified quite a bit (patch [3/3]).

Thanks,
Rafael
