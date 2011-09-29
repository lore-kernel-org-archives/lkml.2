Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab1I2AJh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 20:09:37 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8867 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753937Ab1I2AJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 20:09:35 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=BIWiwiz07VncQNLSaqEagqxLcRHltjdmET0fPGY3JCfP4kbVBXf6O7UoeMQyAyA7K
	Co5m8fZE7LMRr2N1vLKuA==
MIME-Version: 1.0
In-Reply-To: <20110928161805.8acb33c5.kamezawa.hiroyu@jp.fujitsu.com>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<1317170947-17074-4-git-send-email-walken@google.com>
	<20110928161805.8acb33c5.kamezawa.hiroyu@jp.fujitsu.com>
Date: Wed, 28 Sep 2011 17:09:32 -0700
Message-ID: <CANN689GuZHzCa4Xr-YwPrpvy8Fcff4pQLrDQ+a+G_56mvBMwMQ@mail.gmail.com>
Subject: Re: [PATCH 3/9] kstaled: page_referenced_kstaled() and supporting infrastructure.
From: Michel Lespinasse <walken@google.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 12:18 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> 2 questions.
>
> What happens at Transparent HugeTLB pages are splitted/collapsed ?

Nothing special - at the next scan, pages are counted again
considering their new size.

> Does this feature can ignore page migration i.e. flags should not be copied ?

We're not doing it currently. As I understand, the migrate code does
not copy the PTE young bits either, nor does it try to preserve page
order in the LRU lists. So it's not transparent to the LRU algorithms,
but it does not cause incorrect behavior either.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
