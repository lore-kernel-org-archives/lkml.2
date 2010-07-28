Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756381Ab0G1VXx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 17:23:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58186 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756364Ab0G1VXw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 17:23:52 -0400
Date: Wed, 28 Jul 2010 14:23:34 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, corbet@lwn.net,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [PATCH 1/4] timer: Added usleep[_range] timer
Message-Id: <20100728142334.a0453c20.akpm@linux-foundation.org>
In-Reply-To: <4C509BA3.7090403@codeaurora.org>
References: <1280345587-19725-1-git-send-email-ppannuto@codeaurora.org>
	<1280345587-19725-2-git-send-email-ppannuto@codeaurora.org>
	<20100728132314.29cd68c5.akpm@linux-foundation.org>
	<4C509772.1070407@codeaurora.org>
	<20100728135857.2a0ab8bd.akpm@linux-foundation.org>
	<4C509BA3.7090403@codeaurora.org>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.9; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 14:05:39 -0700
Patrick Pannuto <ppannuto@codeaurora.org> wrote:

> On 07/28/2010 01:58 PM, Andrew Morton wrote:
> > On Wed, 28 Jul 2010 13:47:46 -0700
> > Patrick Pannuto <ppannuto@codeaurora.org> wrote:
> > 
> >>> This is different from the patch I merged and I'm not seeing any
> >>> explanation for the change.
> >>>
> >>> The implementation of usleep() looks odd.  The longer we sleep, the
> >>> greater the possible inaccuracy.  A code comment which explains the
> >>> thinking and which warns people about the implications is needed.
> > 
> > I wanna code comment!
> > 
> 
> I understand -- will do (if this even survives, which is unlikely)
> 
> > My main concern is that someone will type usleep(50) and won't realise
> > that it goes and sleeps for 100 usecs and their code gets slow as a
> > result.  This sort of thing takes *years* to discover and fix.  If we'd
> > forced them to type usleep_range() instead, it would never have happened.
> 
> In that case, it would push me in the direction of only providing
> usleep_range, and thus forcing people to think about it that way;
> leave slack decisions to people who know what tolerances are acceptable.

Well, I _think_ that would be a good approach.  I'm 45%/55% on that one
and would be interested in other opinions ;)

