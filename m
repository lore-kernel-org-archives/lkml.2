Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753559Ab2DWLt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 07:49:29 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:52662 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752889Ab2DWLt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 07:49:28 -0400
MIME-Version: 1.0
Date: Mon, 23 Apr 2012 13:49:26 +0200
Message-ID: <CAEiBgeAukAdZv1WNcJQ6DByP7Yy63gvRS0cY6q6yU27p+XRi4A@mail.gmail.com>
Subject: MIPS ASID type conflicts
From: Jean-Christophe PINCE <jcpince@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I am analyzing Linux MIPS tasks memory spaces and found out what I
think is a bug in the ASID management.

The structure "struct cpuinfo_mips" defined in
arch/mips/include/asm/cpu-info.h uses a "unsigned int" field for
asid_cache while the context field defined in
arch/mips/include/asm/mmu.h is a "unsigned long".

This is ok with 32bits kernel but leads to 4bytes vs 8bytes fields
with a 64bits kernel. And when the scheduler checks if the ASID is of
an older ASID_VERSION, the test will always return that the version
differs when the context bits above bit31 will be set.

I imagine this should be a quite rare issue but could likely happen on
devices running for very long and starting processes very often (or
running more than 256 processes per cpu). When this condition (bit 32
or above of asid_cache is set), the effect should be that the TLB will
be flushed on each context_switch required by the scheduler but there
shouldn't be any crash.

Hope this helps,
Thanks and regards,
JC
