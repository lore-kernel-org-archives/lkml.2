Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab1JQXzk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 19:55:40 -0400
Received: from smtp-out.google.com ([74.125.121.67]:5236 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407Ab1JQXzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 19:55:39 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=wyScLpF/NpQ4yoGEcFBvi8W0t2m/9oDnHCC6CjM0H7GJGoGikPR/yw1fQJbyh4gFp
	isNYbAGj3RYbp3u4Uw0fw==
Date: Mon, 17 Oct 2011 16:55:32 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Knut Petersen <Knut_Petersen@t-online.de>
cc: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: __cpuinit early_init_intel() called twice
In-Reply-To: <4E9C5959.1050404@t-online.de>
Message-ID: <alpine.DEB.2.00.1110171650030.13515@chino.kir.corp.google.com>
References: <4E9C5959.1050404@t-online.de>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Oct 2011, Knut Petersen wrote:

> Well, I just realized that there are two "Disabled fast string operations"
> entries in the boot log - that means early_init_intel() is called _twice_.
> I had expected something else. Is this the expected behaviour or shall
> I have a look at the call trees?
> 

I suspect it should only be called twice for the boot processor, once via 
early_identify_cpu() and once via init_intel() for each cpu.
