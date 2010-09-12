Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753171Ab0ILPlm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 11:41:42 -0400
Received: from mail.lncsa.com ([213.215.28.11]:57466 "EHLO sargon.lncsa.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751960Ab0ILPlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 11:41:40 -0400
Date: Sun, 12 Sep 2010 17:41:38 +0200
From: Louis-David Mitterrand <vindex+lists-linux-kernel@apartia.org>
To: linux-kernel@vger.kernel.org
Subject: Re: ksoftirqd/n permanently eating 60% of a CPU
Message-ID: <20100912154138.GA23554@apartia.fr>
Mail-Followup-To: linux-kernel@vger.kernel.org
References: <20100905173905.GA7387@apartia.fr>
 <20100912103130.GA21790@rhlx01.hs-esslingen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100912103130.GA21790@rhlx01.hs-esslingen.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 12, 2010 at 12:31:30PM +0200, Andreas Mohr wrote:
> Hi,
> 
> Since there hasn't been a reply in a week, let me try to provide at
> least a semi-useless one ;)

Hi and thanks for offering your help.

> Such high use probably means that something in the kernel keeps
> retriggering some
> tasklet(?) since it thinks that something hasn't been done yet
> (i.e., the tasklet that got triggered didn't manage to satisfy the success
> criteria of its owner),
> or it means that something "legitimately" uses obscene amounts of
> softirqd activity (perhaps some debug infrastructure such as memory tracing
> or logging or some such).
> 
> Thus:
> 1. boot with "single" or "init=/bin/bash" kernel commandline and check
>    whether the activity still happens

Booting 2.6.35.4 with init=/bin/bash doesn't fix the problem:
ksoftirqd/n keeps firing at 50/60% CPU. No daemons are running of
course.

Examining /proc/interrupts shows that "Local timer interrupts" are
mainly firing.

Strangely enough, the interrupt storm starts only 5 minutes or so after
bootup.

I'd like to get to the bottom of this. As it happens on several, very
different machines.
