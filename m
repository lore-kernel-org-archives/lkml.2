Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab0DBB5C (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 21:57:02 -0400
Received: from lo.gmane.org ([80.91.229.12]:48181 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752731Ab0DBB47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 21:56:59 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Andres Salomon <dilinger@queued.net>
Subject: Re: [PATCH] printk.c: remove duplicate const
Date: Thu, 1 Apr 2010 22:02:40 -0400
Message-ID: <20100401220240.2b3c2c3b@debian>
References: <0D753D10438DA54287A00B0270842697636A7E956D@AUSP01VMBX24.collaborationhost.net>
	<20100401.182004.197314081.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: H Hartley Sweeten <hartleys@visionengravers.com>
X-Gmane-NNTP-Posting-Host: wireless.queued.net
In-Reply-To: <20100401.182004.197314081.davem@davemloft.net>
X-Newsreader: Claws Mail 3.7.5 (GTK+ 2.18.9; i486-pc-linux-gnu)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Apr 2010 18:20:04 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

> From: H Hartley Sweeten <hartleys@visionengravers.com>
> Date: Thu, 1 Apr 2010 20:13:27 -0500
> 
> > Noticed during a sparse build.
> > 
> > Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
> 
> Isn't it intentional?  The two consts mark different aspects
> of the declaration const, both the pointers as well as the
> contents pointed to.


I believe that'd be -

static const char *const kmsg_reasons[]

rather than what was originally in the code -

static const char const *kmsg_reasons[]

Read right-to-left, the first is a constant pointer to a char constant;
the second is a pointer to a constant character constant.   I suspect
the first is what was intended.

