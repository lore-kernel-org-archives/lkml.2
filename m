Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753924Ab1L0NVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 08:21:21 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45162 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753783Ab1L0NVT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 08:21:19 -0500
MIME-Version: 1.0
In-Reply-To: <20111227125945.GH5344@tiehlicka.suse.cz>
References: <CAJd=RBCXTp0GrMGw+MBDdj0K15+L5v+O2t6EcDghFk34aNwt1g@mail.gmail.com>
	<20111227125945.GH5344@tiehlicka.suse.cz>
Date: Tue, 27 Dec 2011 21:21:18 +0800
Message-ID: <CAJd=RBA70k8pCoP26hoJua=h1DHgx7eLHU0qrukJRxwoaxB65Q@mail.gmail.com>
Subject: Re: [PATCH] mm: hugetlb: add might_sleep() for gigantic page
From: Hillf Danton <dhillf@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 27, 2011 at 8:59 PM, Michal Hocko <mhocko@suse.cz> wrote:
> On Fri 23-12-11 21:41:08, Hillf Danton wrote:
>> From: Hillf Danton <dhillf@gmail.com>
>> Subject: [PATCH] mm: hugetlb: add might_sleep() for gigantic page
>>
>> Like the case of huge page, might_sleep() is added for gigantic page, then
>> both are treated in same way.
>
> Why do we need to call might_sleep here? There is cond_resched in the
> loop...
>

IIUC it is the reason to add... and the comment says

/**
 * might_sleep - annotation for functions that can sleep
 *
 * this macro will print a stack trace if it is executed in an atomic
 * context (spinlock, irq-handler, ...).
 *
 * This is a useful debugging help to be able to catch problems early and not
 * be bitten later when the calling function happens to sleep when it is not
 * supposed to.
 */

Thanks
Hillf
