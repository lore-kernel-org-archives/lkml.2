Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753774Ab0EKE5X (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 May 2010 00:57:23 -0400
Received: from gate.crashing.org ([63.228.1.57]:59079 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab0EKE5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 May 2010 00:57:07 -0400
Subject: Re: [PATCH 19/25] lmb: Add array resizing support
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Yinghai Lu <yhlu.kernel@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, tglx@linuxtronix.de,
       mingo@elte.hu, davem@davemloft.net, lethal@linux-sh.org
In-Reply-To: <AANLkTinOVSpCXdkkcCHMdN-HWsImE7_Gcbgg5plnNMss@mail.gmail.com>
References: <1273484339-28911-1-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-12-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-13-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-14-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-15-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-16-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-17-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-18-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-19-git-send-email-benh@kernel.crashing.org>
	 <1273484339-28911-20-git-send-email-benh@kernel.crashing.org>
	 <AANLkTinOVSpCXdkkcCHMdN-HWsImE7_Gcbgg5plnNMss@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 11 May 2010 14:56:05 +1000
Message-ID: <1273553765.21352.1.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-05-10 at 16:59 -0700, Yinghai Lu wrote:
> you need to pass base, base+size with lmb_double_array()
> 
> otherwise when you are using lmb_reserve(base, size), double_array()
> array could have chance to get
> new buffer that is overlapped with [base, base + size).
> 
> to keep it simple, should check_double_array() after lmb_reserve,
> lmb_add, lmb_free (yes, that need it too).
> that was suggested by Michael Ellerman.
> 

No. You may notice that I addressed this problem by moving the
call to lmb_double_array() to -after- we record the entry in
the array, so it shouldn't be able to pickup the same one.

I dislike the idea of sprinkling the check for resize everywhere at the
top level.

Cheers,
Ben.


