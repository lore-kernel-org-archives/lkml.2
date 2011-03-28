Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab1C1P3U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:29:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:39636 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753269Ab1C1P3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:29:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=DmufBtr3cIyAmphPKJc8OIPpGtkhANfwwhebJLbrwQ7EyXhqtH/7hBt9lqa/dSu2/A
         G0ptMl5gIqQNUdcdrATqBDJDiYBgBkdppJ6ww0hk+IYh8LglFlPbFWsmS0YfqX2SPJBm
         mSKjJFOPcMHY75JRQkVXZEzt3vXq3DVlKxx4M=
From: Nai Xia <nai.xia@gmail.com>
Reply-To: nai.xia@gmail.com
Organization: Nanjing University
To: Izik Eidus <izik.eidus@ravellosystems.com>
Subject: Re: [PATCH 0/2] ksm: take dirty bit as reference to avoid volatile pages
Date: Mon, 28 Mar 2011 23:29:03 +0800
User-Agent: KMail/1.13.5 (Linux/2.6.38.1; KDE/4.5.5; i686; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        "linux-mm" <linux-mm@kvack.org>
References: <201103282214.19345.nai.xia@gmail.com> <4D90A236.9030200@ravellosystems.com>
In-Reply-To: <4D90A236.9030200@ravellosystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201103282329.04184.nai.xia@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 28 March 2011 22:59:02 Izik Eidus wrote:
> On 03/28/2011 04:14 PM, Nai Xia wrote:
> > Currently, ksm uses page checksum to detect volatile pages. Izik Eidus
> > suggested that we could use pte dirty bit to optimize. This patch series
> > adds this new logic.
> >
> 
> Hi,
> 
> One small note:
> When kvm will use ksm on intel cpu with extended page tables support, 
> the cpu won`t track
> dirty bit, therefore the calc_hash() logic should be used in such cases
> (untill intel will fadd this support in their cpus)...
> 
> Moreover I think that even though that AMD nested page tables does 
> update dirty bit, you still need
> to sync it with the host page table using mmu notifiers ?
> 
> (Not that on regular application use case of ksm any of this should be 
> an issue)
> 
> 

Hmm, I will consider these two issues in the next version. Thanks for
input!


Nai
