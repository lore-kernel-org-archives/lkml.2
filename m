Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756180Ab2JJNGV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 09:06:21 -0400
Received: from mx1.etf.rs ([147.91.14.169]:51380 "EHLO mx1.etf.bg.ac.rs"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756026Ab2JJNGK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 09:06:10 -0400
X-Greylist: delayed 1636 seconds by postgrey-1.27 at vger.kernel.org; Wed, 10 Oct 2012 09:06:10 EDT
MIME-Version: 1.0
Reply-To: igorm@etf.rs
Date: Wed, 10 Oct 2012 14:38:48 +0200
Message-ID: <CAFdo_mV4bUWvH7v4e1612i7K321+5QzYb=CQspo7ydUZWpxd+A@mail.gmail.com>
Subject: Regresion from 3.5.0-rc4 in 3.6-rc5
From: =?ISO-8859-2?Q?Igor_Maravi=E6?= <igorm@etf.rs>
To: linux-kernel@vger.kernel.org
Cc: mjg@redhat.com, holger@homac.de, ming.m.lin@intel.com, jgarzik@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I can't boot up my machine, with the latest kernel, that I've cloned
from git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git.

It just hangs. Last message that I see is

powernow-k8: this CPU is not supported anymore, using acpi-cpufreq instead

My CPU is AMD Athlon II X2 240.

In linux 3.5 it worked, although it complained that

"No compatible ACPI _PSS objects found"

This is what I've found with bisect:
---
30dcf76acc695cbd2fa919e294670fe9552e16e7 is the first bad commit
commit 30dcf76acc695cbd2fa919e294670fe9552e16e7
Author: Matthew Garrett <mjg@redhat.com>
Date:   Mon Jun 25 16:13:04 2012 +0800

    libata: migrate ACPI code over to new bindings

    Now that we have the ability to directly glue the ACPI namespace to the
    driver model in libata, we don't need the custom code to handle the same
    thing. Remove it and migrate the functions over to the new code.

    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Signed-off-by: Holger Macht <holger@homac.de>
    Signed-off-by: Lin Ming <ming.m.lin@intel.com>
    Signed-off-by: Jeff Garzik <jgarzik@redhat.com>

:040000 040000 6a659a9d4a92b2085f6d0b58484cb2f82cd12cfa
125fe5d5fa8b208a08792b03e752571d825465d2 M	drivers
:040000 040000 b7c3819be4e82ae6e2ac9688055aeb2bc1bc4ebd
9cbc8fd15b147a178f723bcdb9e7c34f9868400f M	include
---

BR
Igor
