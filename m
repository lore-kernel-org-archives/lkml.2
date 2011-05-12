Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932836Ab1ELWOh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 18:14:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:58358 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758857Ab1ELWOg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 18:14:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=oFcQZtAOwR2l/fVtgSJCEtES1oqSmoXB6jexljyCNFpxnYccoCrFboDVPWDui6uIzJ
         x9zQqx9JYkJqdg1CJ8qw==
Date: Thu, 12 May 2011 15:14:31 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: John Stultz <john.stultz@linaro.org>
cc: LKML <linux-kernel@vger.kernel.org>, "Ted Ts'o" <tytso@mit.edu>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
Subject: Re: [PATCH 3/3] comm: ext4: Protect task->comm access by using
 %ptc
In-Reply-To: <1305073386-4810-4-git-send-email-john.stultz@linaro.org>
Message-ID: <alpine.DEB.2.00.1105121513070.9130@chino.kir.corp.google.com>
References: <1305073386-4810-1-git-send-email-john.stultz@linaro.org> <1305073386-4810-4-git-send-email-john.stultz@linaro.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 May 2011, John Stultz wrote:

> Converts ext4 comm access to use the safe printk %ptc accessor.
> 
> CC: Ted Ts'o <tytso@mit.edu>
> CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> CC: David Rientjes <rientjes@google.com>
> CC: Dave Hansen <dave@linux.vnet.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: linux-mm@kvack.org
> Signed-off-by: John Stultz <john.stultz@linaro.org>

I like how this patch illustrates how easy it is to use the new method for 
printing a task's command, but it would probably be easier to get the 
first two patches in the series (those that add the seqlock and then %ptc) 
merged in mainline and then break out a series of conversions such as this 
that could go through the individual maintainer's trees.
