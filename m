Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758065Ab2CVXDj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 19:03:39 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:33212 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab2CVXDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 19:03:38 -0400
Date: Thu, 22 Mar 2012 16:03:36 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= <uwe@kleine-koenig.org>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] telephony/ixj: Fix warning about sequence points
Message-Id: <20120322160336.66e9a88b.akpm@linux-foundation.org>
In-Reply-To: <1332154664-10968-1-git-send-email-uwe@kleine-koenig.org>
References: <1332154664-10968-1-git-send-email-uwe@kleine-koenig.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 Mar 2012 11:57:44 +0100
Uwe Kleine-K__nig <uwe@kleine-koenig.org> wrote:

> In the statement
> 
> 	j->caplist[j->caps].handle = j->caps++;
> 
> there is no sequence point between the usage of j->caps on the LHS of the
> assignment and the incrementation on its RHS. So it's not defined in Standard C
> if j->caps is already incremented when used on the LHS even though the postfix
> ++ operator is used. To properly fix that the incrementation has to be done in
> a seperate expression.
> 
> This fixes:
> 	drivers/telephony/ixj.c: In function ___add_caps___:
> 	drivers/telephony/ixj.c:5930:38: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:5950:38: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:5954:38: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:5965:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:5976:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:5988:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:5998:38: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6003:38: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6008:38: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6013:38: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6019:38: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6026:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6031:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6036:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6041:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6049:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6057:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6065:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 	drivers/telephony/ixj.c:6071:39: warning: operation on ___j->caps___ may be undefined [-Wsequence-point]
> 
> Signed-off-by: Uwe Kleine-K__nig <uwe@kleine-koenig.org>
> ---
>  drivers/telephony/ixj.c |   57 +++++++++++++++++++++++++++++++---------------

fyi, ixj.c has been moved into staging/, with a view to removing it
altogether.

It will be sad to see it go - it has stood as a great example of what not
to do ;)  And no, I don't now how to find out if anyone is using it either.
