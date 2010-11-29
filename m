Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753691Ab0K2MId (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:08:33 -0500
Received: from casper.infradead.org ([85.118.1.10]:50778 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab0K2MIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:08:32 -0500
Subject: Re: [PATCH 1/3] lib: percpu counter add unless less than
 functionality
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Dave Chinner <david@fromorbit.com>
Cc: xfs@oss.sgi.com, linux-kernel@vger.kernel.org
In-Reply-To: <1290991002-18680-2-git-send-email-david@fromorbit.com>
References: <1290991002-18680-1-git-send-email-david@fromorbit.com>
	 <1290991002-18680-2-git-send-email-david@fromorbit.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Mon, 29 Nov 2010 13:08:50 +0100
Message-ID: <1291032530.32004.26.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 11:36 +1100, Dave Chinner wrote:
> +int percpu_counter_add_unless_lt(struct percpu_counter *fbc, s64 amount,
> +                                                       s64 threshold);

It might make sense to implement that as;

  __percpu_counter_add_unless_lt(struct percpu_counter *fbc,
				 s64 amount,
				 s64 threshold,
				 s32 batch);

That way its consistent with the __percpu_counter_add() implementation
where you can also specify the batch value.


