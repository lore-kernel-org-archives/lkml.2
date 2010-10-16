Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0JPBof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:44:35 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:58426 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404Ab0JPBoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:44:34 -0400
Date: Sat, 16 Oct 2010 02:44:30 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        takata@linux-m32r.org, linux-m32r@ml.linux-m32r.org
Subject: Re: [PATCH 2/4] m32r: get_user takes an lvalue, not a pointer
Message-ID: <20101016014430.GS19804@ZenIV.linux.org.uk>
References: <20101016010952.GQ8332@bombadil.infradead.org>
 <20101016011709.GT8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101016011709.GT8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 09:17:09PM -0400, Kyle McMartin wrote:
>  static int prev_insn(struct pt_regs *regs)
>  {
>  	u16 inst;
> -	if (get_user(&inst, (u16 __user *)(regs->bpc - 2)))
> +	if (get_user(inst, (u16 __user *)(regs->bpc - 2)))

Ouch...  ACKed, my fuckup.
