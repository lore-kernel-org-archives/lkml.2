Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753255Ab1I0KOQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 06:14:16 -0400
Received: from smtp-out.google.com ([74.125.121.67]:8448 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752327Ab1I0KOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 06:14:15 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:x-system-of-record;
	b=sJnmJYN6bs3T8OYRDmSxauOUpO8culvLdho/AQ5GCydd7M0Oks93jaqZ6hdX01KYz
	QOgOrPz8KPEvLKfPm6f9A==
MIME-Version: 1.0
In-Reply-To: <CAKTCnzkzdQgut96NZf3Mi2kpOWW7N3qeybets5AHy7Gp8Wj_HQ@mail.gmail.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	<CAKTCnzkzdQgut96NZf3Mi2kpOWW7N3qeybets5AHy7Gp8Wj_HQ@mail.gmail.com>
Date: Tue, 27 Sep 2011 03:14:09 -0700
Message-ID: <CANN689G4Z21v6fcF1dt-10CpQp9V42_hGPcPP2d5FChfCon_9Q@mail.gmail.com>
Subject: Re: [PATCH 0/8] idle page tracking / working set estimation
From: Michel Lespinasse <walken@google.com>
To: Balbir Singh <bsingharora@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 27, 2011 at 3:03 AM, Balbir Singh <bsingharora@gmail.com> wrote:
> On Sat, Sep 17, 2011 at 9:09 AM, Michel Lespinasse <walken@google.com> wrote:
>> Patch 3 introduces page_referenced_kstaled(), which is similar to
>> page_referenced() but is used for idle page tracking rather than
>> for memory reclaimation. Since both functions clear the pte_young bits
>> and we don't want them to interfere with each other, two new page flags
>> are introduced that track when young pte references have been cleared by
>> each of the page_referenced variants.
>
> Sorry, I have trouble parsing this sentence, could you elaborate on "when"?

page_referenced() indicates if a page was accessed since the previous
page_referenced() call.

page_referenced_kstaled() indicates if a page was accessed since the
previous page_referenced_kstaled() call.

Both of the functions need to clear PTE young bits; however we don't
want the two functions to interfere with each other. To achieve this,
we add two page bits to indicate when a young PTE has been observed by
one of the functions but not by the other.

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.
