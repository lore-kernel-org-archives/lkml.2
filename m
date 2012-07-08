Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab2GHTcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 15:32:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46808 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752075Ab2GHTcK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 15:32:10 -0400
Date: Sun, 8 Jul 2012 14:32:05 -0500
From: Jonathan Nieder <jrnieder@gmail.com>
To: Octavio Alvarez <alvarezp@alvarezp.com>
Cc: Bob Moore <robert.moore@intel.com>,
        Adrian Knoth <adi@drcomp.erfurt.thur.de>, Shaohua Li <shli@kernel.org>,
        Len Brown <len.brown@intel.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI: Leave Bus Master Arbitration enabled for
 suspend/resume
Message-ID: <20120708193204.GF7328@burratino>
References: <op.wg3en6ij6g6bxc@localhost.localdomain>
 <Pine.LNX.4.44L0.1207072208270.508-100000@netrider.rowland.org>
 <20120708025730.GE2961@burratino>
 <op.wg30yabp6g6bxc@localhost.localdomain>
 <20120708090432.GF4625@burratino>
 <op.wg4f33nl6g6bxc@localhost.localdomain>
 <20120708190434.GD7328@burratino>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120708190434.GD7328@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi again,

Jonathan Nieder wrote:

> The bug snuck back in in commit 33620c5419e8 (ACPICA: Support for
> custom ACPICA build for ACPI 5 reduced hardware, 2012-02-14),
> presumably by copy/pasting from the wrong source for the legacy case.

Um, wrong commit.  Sorry, here's a fixed message.

ACPI: Leave Bus Master Arbitration enabled for suspend/resume

This is an old suspend/resume lockup fix:

	commit 2780cc4660e1
	Author: Len Brown <len.brown@intel.com>
	Date:   Thu Dec 23 13:43:30 2004 -0500

	    [ACPI] Fix suspend/resume lockup issue
	    by leaving Bus Master Arbitration enabled.
	    The ACPI spec mandates it be disabled only for C3.

	    http://bugzilla.kernel.org/show_bug.cgi?id=3599

	    Signed-off-by: David Shaohua Li <shaohua.li@intel.com>
	    Signed-off-by: Len Brown <len.brown@intel.com>

The bug snuck back in in commit 2feec47d4c5f (ACPICA: ACPI 5: Support
for new FADT SleepStatus, SleepControl registers, 2012-02-14),
presumably by copy/pasting a copy of the code without that fix for the
legacy case.

On affected machines, after that commit, the machine locks up hard
on resume from suspend.  The same fix as seven years ago still works.

Addresses <https://bugzilla.kernel.org/show_bug.cgi?id=43641>.

Reported-bisected-and-tested-by: Octavio Alvarez <alvarezp@alvarezp.com>
Reported-by: Adrian Knoth <adi@drcomp.erfurt.thur.de>
Signed-off-by: Jonathan Nieder <jrnieder@gmail.com>
Cc: <stable@vger.kernel.org> # 3.4
