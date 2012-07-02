Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753818Ab2GBPL0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 11:11:26 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:40535 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752897Ab2GBPLY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 11:11:24 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fat: Refactor shortname parsing
References: <1340993528-12111-1-git-send-email-steve@digidescorp.com>
	<87r4syrl4y.fsf@devron.myhome.or.jp>
	<1340997235.9826.7.camel@iscandar.digidescorp.com>
	<87bok1sx6j.fsf@devron.myhome.or.jp>
	<87zk7lribe.fsf@devron.myhome.or.jp>
	<1341234099.1695.13.camel@iscandar.digidescorp.com>
	<87fw9anuwk.fsf@devron.myhome.or.jp>
	<1341237638.1695.16.camel@iscandar.digidescorp.com>
	<8762a6nsao.fsf@devron.myhome.or.jp>
	<1341240342.1695.20.camel@iscandar.digidescorp.com>
Date: Tue, 03 Jul 2012 00:11:20 +0900
In-Reply-To: <1341240342.1695.20.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Mon, 02 Jul 2012 09:45:42 -0500")
Message-ID: <871ukunqp3.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> On Mon, 2012-07-02 at 23:36 +0900, OGAWA Hirofumi wrote: 
>> "Steven J. Magnani" <steve@digidescorp.com> writes:
>> 
>> > True, but with the change you suggest we lose the incrementing of 'i',
>> > which likely would cause an infinite loop for 1:1 Unicode conversions.
>> 
>> You meant, we just have to do
>> 
>> 	if (!is_vfat)
>>         	ptname[i] = ...;
>> 	i++;
>> 
>> or something? I still feel this looks better to indicate, we don't use
>> ptname in the case of vfat.
>
> I can change it, but there are other places in that function where
> ptname is used that are not qualified with !is_vfat, so I don't know
> whether this improves clarity or reduces it.
>
> I do think fat_tolower() should not be making decisions. IMHO the
> trigraph and a comment, perhaps before the vfat-only reassignment of
> 'name', would be clearer. 

Hm, the primary case is vfat. fat_tolower()/hidden is required only for
msdos, and ptname too. So, my suggestion is trying to keep vfat case
clean.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
