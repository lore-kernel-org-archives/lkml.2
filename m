Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752957Ab2FKSgM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 14:36:12 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:42164 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751821Ab2FKSgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 14:36:10 -0400
Message-ID: <4FD63A55.3090505@linaro.org>
Date: Mon, 11 Jun 2012 11:35:01 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Rik van Riel <riel@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Dmitry Adamushko <dmitry.adamushko@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Andrea Righi <andrea@betterlinux.com>,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>,
        Taras Glek <tgek@mozilla.com>, Mike Hommey <mh@glandium.org>,
        Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 3/3] [RFC] tmpfs: Add FALLOC_FL_MARK_VOLATILE/UNMARK_VOLATILE
 handlers
References: <1338575387-26972-1-git-send-email-john.stultz@linaro.org> <1338575387-26972-4-git-send-email-john.stultz@linaro.org> <4FC9235F.5000402@gmail.com>	<4FC92E30.4000906@linaro.org> <4FC9360B.4020401@gmail.com>	<4FC937AD.8040201@linaro.org> <4FC9438B.1000403@gmail.com>	<4FC94F61.20305@linaro.org> <4FCFB4F6.6070308@gmail.com>	<4FCFEE36.3010902@linaro.org> <CAO6Zf6D++8hOz19BmUwQ8iwbQknQRNsF4npP4r-830j04vbj=g@mail.gmail.com> <4FD13C30.2030401@linux.vnet.ibm.com> <4FD16B6E.8000307@linaro.org> <4FD1848B.7040102@gmail.com> <4FD2C6C5.1070900@linaro.org> <4FD515FA.2020708@redhat.com>
In-Reply-To: <4FD515FA.2020708@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12061118-4242-0000-0000-000001EECF72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2012 02:47 PM, Rik van Riel wrote:
> On 06/08/2012 11:45 PM, John Stultz wrote:
>
>> I *think* ideally, the pages in a volatile range should be similar to
>> non-dirty file-backed pages. There is a cost to restore them, but
>> freeing them is very cheap. The trick is that volatile ranges introduces
>
> Easier to mark them dirty.
>
>> a new relationship between pages. Since the neighboring virtual pages in
>> a volatile range are in effect tied together, purging one effectively
>> ruins the value of keeping the others, regardless of which zone they are
>> physically.
>
> Then the volatile ->writepage function can zap the whole
> object.
>

What about the concern that if we don't have swap, we'll not call 
writepage on tmpfs files?

thanks
-john





