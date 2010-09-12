Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752521Ab0ILKbd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 06:31:33 -0400
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:58738 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0ILKbc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 06:31:32 -0400
Date: Sun, 12 Sep 2010 12:31:30 +0200
From: Andreas Mohr <andi@lisas.de>
To: Louis-David Mitterrand <vindex+lists-linux-kernel@apartia.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ksoftirqd/n permanently eating 60% of a CPU
Message-ID: <20100912103130.GA21790@rhlx01.hs-esslingen.de>
Mail-Followup-To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100905173905.GA7387@apartia.fr>
X-Priority: none
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Since there hasn't been a reply in a week, let me try to provide at
least a semi-useless one ;)

Such high use probably means that something in the kernel keeps retriggering some
tasklet(?) since it thinks that something hasn't been done yet
(i.e., the tasklet that got triggered didn't manage to satisfy the success
criteria of its owner),
or it means that something "legitimately" uses obscene amounts of
softirqd activity (perhaps some debug infrastructure such as memory tracing
or logging or some such).

Thus:
1. boot with "single" or "init=/bin/bash" kernel commandline and check
   whether the activity still happens
2. if not: boot normally, then remove kernel modules via rmmod one at a
   time, and try shutting down various daemons, to try to find out which
component exactly messes it up

And perhaps running powertop would provide some clues as to the origin
of this CPU hog, despite being a wakeup-specific tracer.

HTH,

Andreas Mohr
