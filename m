Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757157Ab0KKVeM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 16:34:12 -0500
Received: from smtp-out.google.com ([216.239.44.51]:16985 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090Ab0KKVeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 16:34:10 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=oO6rqkGag83c0s8PSg+gkvVOvw1Yw3i/O4i/IMPXZQTw0YNhKH3Y94LayOBZWVvcJ9
         EQXkPb5A+1fJUS0CAjoQ==
Date: Thu, 11 Nov 2010 13:34:05 -0800 (PST)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Vasiliy Kulikov <segooon@gmail.com>
cc: Andrew Morton <akpm@linux-foundation.org>, kernel-janitors@vger.kernel.org,
        =?UTF-8?Q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>,
        Joe Perches <joe@perches.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] lib: vsprintf: fix invalid arg check
In-Reply-To: <20101111210251.GA26283@albatros>
Message-ID: <alpine.DEB.2.00.1011111319110.25829@chino.kir.corp.google.com>
References: <1289421490-23950-1-git-send-email-segooon@gmail.com> <20101110130834.02496b48.akpm@linux-foundation.org> <alpine.DEB.2.00.1011101335410.7756@chino.kir.corp.google.com> <20101111083408.GA3471@albatros> <alpine.DEB.2.00.1011111224161.25829@chino.kir.corp.google.com>
 <20101111210251.GA26283@albatros>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Nov 2010, Vasiliy Kulikov wrote:

> OK, if the main reason here is return value type, then the correct
> handling should be:
> 
> 	/* Reject out-of-range values early.  Large positive sizes are
> 	   used for unknown buffer sizes. */
> -	if (WARN_ON_ONCE((int) size < 0))
> +	if (WARN_ON_ONCE(size > INT_MAX)
> 		return 0;
> 
> This should catch all underflows and too big integers.
> 

That is equivalent since size_t is always unsigned; if you'd like to 
change it, it should be presented only as a style change.  More important 
would be writing a less cryptic comment :)
