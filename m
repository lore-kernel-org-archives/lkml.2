Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758157Ab2DJACK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 20:02:10 -0400
Received: from forward6.mail.yandex.net ([77.88.60.125]:56932 "EHLO
	forward6.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750858Ab2DJACJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 20:02:09 -0400
X-Greylist: delayed 673 seconds by postgrey-1.27 at vger.kernel.org; Mon, 09 Apr 2012 20:02:09 EDT
From: Alexey Ivanov <rbtz@yandex-team.ru>
To: Rik van Riel <riel@redhat.com>
Cc: "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>, yinghan@google.com
In-Reply-To: <4F8326FD.8020507@redhat.com>
References: <37371333672160@webcorp7.yandex-team.ru> <4F7E9854.1020904@gmail.com> <12701333991475@webcorp7.yandex-team.ru> <4F8326FD.8020507@redhat.com>
Subject: Re: mapped pagecache pages vs unmapped pages
MIME-Version: 1.0
Message-Id: <8041334015453@webcorp4.yandex-team.ru>
Date: Tue, 10 Apr 2012 03:50:53 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did you consider making this ratio tunable, at least manually(i.e. via sysctl)?
I suppose we are not the only ones with almost-whole-ram-mmaped workload.

09.04.2012, 22:56, "Rik van Riel" <riel@redhat.com>:
> On 04/09/2012 01:11 PM, Alexey Ivanov wrote:
>
>> šThanks for the hint!
>>
>> šCan anyone clarify the reason of not using zone->inactive_ratio in inactive_file_is_low_global()?
>
> New anonymous pages start out on the active anon list, and
> are always referenced. šIf memory fills up, they may end
> up getting moved to the inactive anon list; being referenced
> while on the inactive anon list is enough to get them promoted
> back to the active list.
>
> New file pages start out on the INACTIVE file list, and
> start their lives not referenced at all. Due to readahead
> extra reads, many file pages may never be referenced.
>
> Only file pages that are referenced twice make it onto
> the active list.
>
> This means the inactive file list has to be large enough
> for all the readahead buffers, and give pages enough time
> on the list that frequently accessed ones can get accessed
> twice and promoted.
>
> http://linux-mm.org/PageReplacementDesign
>
> --
> All rights reversed

-- 
Alexey Ivanov
Yandex Search Admin Team
