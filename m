Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755385Ab2DIRLU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 13:11:20 -0400
Received: from forward17.mail.yandex.net ([95.108.253.142]:59498 "EHLO
	forward17.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab2DIRLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 13:11:19 -0400
From: Alexey Ivanov <rbtz@yandex-team.ru>
To: "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
In-Reply-To: <4F7E9854.1020904@gmail.com>
References: <37371333672160@webcorp7.yandex-team.ru> <4F7E9854.1020904@gmail.com>
Subject: Re: mapped pagecache pages vs unmapped pages
MIME-Version: 1.0
Message-Id: <12701333991475@webcorp7.yandex-team.ru>
Date: Mon, 09 Apr 2012 21:11:14 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=koi8-r
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the hint!

Can anyone clarify the reason of not using zone->inactive_ratio in inactive_file_is_low_global()?

06.04.2012, 11:16, "gnehzuil.lzheng@gmail.com" <gnehzuil.lzheng@gmail.com>:
> On 04/06/2012 08:29 AM, Alexey Ivanov wrote:
>
>> šIn progress of migration from FreeBSD to Linux and we found some strange behavior: periodically running tasks (like rsync/p2p deployment) evict mapped pages from memory.
>>
>> šFrom my little research I've found following lkml thread:
>> šhttps://lkml.org/lkml/2008/6/11/278
>> šAnd more precisely this commit: https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4f98a2fee8acdb4ac84545df98cccecfd130f8db
>> šwhich along with splitting LRU into "anon" and "file" removed support of reclaim_mapped.
>>
>> šIs there a knob to prioritize mapped memory over unmapped (without modifying all apps to use O_DIRECT/fadvise/madvise or mlocking our data in memory) or at least some way to change proportion of Active(file)/Inactive(file)?
>
> Hi Alexey,
>
> Cc to linux-mm mailing list.
>
> I have met the similar problem and I have sent a mail to discuss it.
> Maybe it can help you
> (http://marc.info/?l=linux-mm&m=132947026019538&w=2).
>
> Now Konstantin has sent a patch set to try to expand vm_flags from 32
> bit to 64 bit. šThen we can add the new flag into vm_flags and
> prioritize mmaped pages in madvise(2).
>
> Regards,
> Zheng
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at šhttp://vger.kernel.org/majordomo-info.html
> Please read the FAQ at šhttp://www.tux.org/lkml/

-- 
Alexey Ivanov
Yandex Search Admin Team
*************
tel.: +7 (985) 120-35-83 (int. 7176)
http://staff.yandex-team.ru/rbtz
*************
