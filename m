Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab0HWUkV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 16:40:21 -0400
Received: from smtp-out.google.com ([74.125.121.35]:17440 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753949Ab0HWUkS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 16:40:18 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id:
	references:user-agent:mime-version:content-type:x-system-of-record;
	b=WELnbfLSJ8MnSa1A4gAxaGp7hrNk6EKpQjGiWpoQJI5dqMahIW7ttLBxs/v5wHRGE
	L5QwU+4w9mCoaw7R+CQYg==
Date: Mon, 23 Aug 2010 13:40:11 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Pekka Enberg <penberg@kernel.org>
cc: Andrew Morton <akpm@linux-foundation.org>, Neil Brown <neilb@suse.de>,
        Alasdair G Kergon <agk@redhat.com>, linux-raid@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/6] md: remove dependency on __GFP_NOFAIL
In-Reply-To: <AANLkTi=HxY6w2iJme3qW_J_sbXedu7JSSECBEFPM1d_c@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1008231339300.20535@chino.kir.corp.google.com>
References: <alpine.DEB.2.00.1008161953430.17924@chino.kir.corp.google.com> <alpine.DEB.2.00.1008161954310.17924@chino.kir.corp.google.com> <20100823122606.47524cef.akpm@linux-foundation.org> <alpine.DEB.2.00.1008231229410.14622@chino.kir.corp.google.com>
 <20100823130109.6da43a58.akpm@linux-foundation.org> <AANLkTikpTZfUE-XFCXJV6FdZy0ZTWeoPLF_qErvvjGOy@mail.gmail.com> <alpine.DEB.2.00.1008231310100.17716@chino.kir.corp.google.com> <AANLkTi=HxY6w2iJme3qW_J_sbXedu7JSSECBEFPM1d_c@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010, Pekka Enberg wrote:

> My point is that I don't think Andrew's helper will change all that
> much. Fixing the actual callers is the hard part and I don't see your
> patches helping that either. Hiding the looping in filesystem code is
> only going to make problematic callers harder to find (e.g
> kmem_alloc() in XFS code).
> 

Nothing is getting hidden in the callers here, all of the patches in this 
series are using __GFP_NOFAIL unnecessarily.
