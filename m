Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752941Ab2GBNkr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 09:40:47 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:40502 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752321Ab2GBNke (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 09:40:34 -0400
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
Date: Mon, 02 Jul 2012 22:40:27 +0900
In-Reply-To: <1341234099.1695.13.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Mon, 02 Jul 2012 08:01:39 -0500")
Message-ID: <87fw9anuwk.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> On Sat, 2012-06-30 at 05:09 +0900, OGAWA Hirofumi wrote: 
>> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp> writes:
>> 
>> >
>> > 			if (is_vfat)
>> > 				ptname[i++] = fat_tolower(!nocase, c);
>> 
>> Of course, if (!is_vfat). Sorry.
>
> I agree that the nocase logic is confusing, but I'm pretty sure this
> change would break the code. 

I might be wrong here though, which place is broken with it?

> 'nocase' is always zero for vfat, which does not recognize that option.
> For msdos, it is zero by default, and 1 if the 'nocase' option was
> specified.
> In all cases it is necessary to copy *something* to ptname.

Looks like, we overwrite bufname by converted bufuname in is_vfat case?

	if (isvfat) {
		bufuname[j] = 0x0000;
		i = fat_uni_to_x8(sb, bufuname, bufname, sizeof(bufname));
	}

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
