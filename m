Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755376Ab0C2KzS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 06:55:18 -0400
Received: from one.firstfloor.org ([213.235.205.2]:44964 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755232Ab0C2KzQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 06:55:16 -0400
To: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, hpa@zytor.com,
       tglx@linutronix.de
Subject: Re: [PATCH] x86: mce: Xeon75xx specific interface to get corrected memory error information v2
From: Andi Kleen <andi@firstfloor.org>
References: <20100324054044.GA4307@basil.fritz.box>
	<87vdcf7ent.fsf@basil.nowhere.org> <4BB06500.5060105@jp.fujitsu.com>
	<20100329090156.GE20695@one.firstfloor.org>
	<4BB0851B.3000908@jp.fujitsu.com>
Date: Mon, 29 Mar 2010 12:55:14 +0200
In-Reply-To: <4BB0851B.3000908@jp.fujitsu.com> (Hidetoshi Seto's message of "Mon, 29 Mar 2010 19:46:51 +0900")
Message-ID: <87fx3j75yl.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com> writes:

> I have some questions: Is it impossible to get the address
> after polling handler have processed?  e.g. Is it possible to
> implement this module as mcelog's add-on that hooked & invoked
> immediately after reading /dev/mcelog?  I guess there are
> some limitation/restriction to call pfa_command().

You need to be in ring 0. In theory you could do it later, but then
you risk losing the address if there is another error.

> Are there any alternative way to get the address?

No.

> Polling like edac_i7 doesn't help this?

No.

>
> You pointed "This makes it impossible to do predictive failure
> analysis", but I guess we could do rough-but-enough analysis that
> requires coarse resolution like sockets.  Or we should not expect

The main predictive failure analysis interesting here is bad page
offlining and for that you need an address.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
