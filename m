Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab2DIS4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 14:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45770 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754630Ab2DIS4L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 14:56:11 -0400
Message-ID: <4F8326FD.8020507@redhat.com>
Date: Mon, 09 Apr 2012 14:14:21 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Alexey Ivanov <rbtz@yandex-team.ru>
CC: "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: mapped pagecache pages vs unmapped pages
References: <37371333672160@webcorp7.yandex-team.ru> <4F7E9854.1020904@gmail.com> <12701333991475@webcorp7.yandex-team.ru>
In-Reply-To: <12701333991475@webcorp7.yandex-team.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 01:11 PM, Alexey Ivanov wrote:
> Thanks for the hint!
>
> Can anyone clarify the reason of not using zone->inactive_ratio in inactive_file_is_low_global()?

New anonymous pages start out on the active anon list, and
are always referenced.  If memory fills up, they may end
up getting moved to the inactive anon list; being referenced
while on the inactive anon list is enough to get them promoted
back to the active list.

New file pages start out on the INACTIVE file list, and
start their lives not referenced at all. Due to readahead
extra reads, many file pages may never be referenced.

Only file pages that are referenced twice make it onto
the active list.

This means the inactive file list has to be large enough
for all the readahead buffers, and give pages enough time
on the list that frequently accessed ones can get accessed
twice and promoted.

http://linux-mm.org/PageReplacementDesign

-- 
All rights reversed
