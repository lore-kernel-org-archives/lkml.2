Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab1E3SG1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 May 2011 14:06:27 -0400
Received: from casper.infradead.org ([85.118.1.10]:55948 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756569Ab1E3SG0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 May 2011 14:06:26 -0400
Subject: Re: Very high CPU values in top on idle system (3.0-rc1)
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Markus Trippelsdorf <markus@trippelsdorf.de>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20110530173916.GA1746@x4.trippels.de>
References: <20110530173916.GA1746@x4.trippels.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 30 May 2011 20:05:43 +0200
Message-ID: <1306778743.23844.5.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-05-30 at 19:39 +0200, Markus Trippelsdorf wrote:
> I get very high CPU values when I run 'top' on my (mostly) idle system
> with 3.0-rc1. For example mpd was always in the 1-2% range and is now
> constantly over 50%. 
> 
> This is caused by:
> 
> commit 317f394160e9beb97d19a84c39b7e5eb3d7815a8
> Author: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Date:   Tue Apr 5 17:23:58 2011 +0200
> 
>     sched: Move the second half of ttwu() to the remote cpu
> 
> When I revert the above I see sane CPU values again.

So: echo NO_TTWU_QUEUE > /debug/sched_features, also cures it?

What architecture, what .config, and can you see it with anything other
than mpd (yum search mpd, only seems to result in mpd clients not the
actual server).


