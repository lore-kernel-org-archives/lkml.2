Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754605Ab0JNNXU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 09:23:20 -0400
Received: from canuck.infradead.org ([134.117.69.58]:33086 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754435Ab0JNNXT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 09:23:19 -0400
Subject: Re: [tip:timers/urgent] hrtimer: Preserve timer state in
 remove_hrtimer()
From: Peter Zijlstra <peterz@infradead.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        sqazi@google.com, tglx@linutronix.de
Cc: linux-tip-commits@vger.kernel.org
In-Reply-To: <tip-f13d4f979c518119bba5439dd2364d76d31dcd3f@git.kernel.org>
References: <20101012142351.8485.21823.stgit@dungbeetle.mtv.corp.google.com>
	 <tip-f13d4f979c518119bba5439dd2364d76d31dcd3f@git.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 14 Oct 2010 15:23:03 +0200
Message-ID: <1287062583.29097.194.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-14 at 11:34 +0000, tip-bot for Salman Qazi wrote:
> The bug was introduced with commit ca109491f (hrtimer: removing all ur
> callback modes) in 2.6.29 

Not actually sure about that,. afaict its due to unlocking the base lock
over the callback, which comes from 2d44ae4d7 (hrtimer: clean up
cpu->base locking tricks), and existed before that in the special case
of the scheduler tick (for which this problem is very unlikely to have
ever triggered because we simply don't call start on it when its
running).

Anyway, the patch does look good, so

Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>

