Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2GBQ7J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 12:59:09 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:40558 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445Ab2GBQ7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 12:59:07 -0400
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
	<871ukunqp3.fsf@devron.myhome.or.jp>
	<1341244281.1695.28.camel@iscandar.digidescorp.com>
Date: Tue, 03 Jul 2012 01:59:01 +0900
In-Reply-To: <1341244281.1695.28.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Mon, 02 Jul 2012 10:51:21 -0500")
Message-ID: <87txxqm756.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

>> Hm, the primary case is vfat. fat_tolower()/hidden is required only for
>> msdos, and ptname too. So, my suggestion is trying to keep vfat case
>> clean.
>
> It's not clear to me where you want to go with this. 
>
> 1. Split fat_parse_short() into msdos and vfat versions. This may
> improve clarity, but there would be some replication of code.

This is not a option. We are better to not change.

> 2. Sprinkle "if (!isvfat)" throughout the already-proposed version of
> fat_parse_short()
>   A. Everywhere
>   B. Only in the places you've proposed

I'm not sure what (A) means though. Probably, I will not care.

> 3. Retain the already-proposed version of fat_parse_short(), but add a
> comment that the uni_name overrides the msdos "ptname", and separate out
> the decision to lowercase from fat_tolower() [i.e., the trigraph].

The trigraph change doesn't cleanup anything. Because it is using
needless ptname on vfat path.

vfat always uses the uni_name and doesn't use ptname, right?  And msdos
path doesn't use the uni_name and use ptname always.  So, I'm saying,
let's make clear those difference and usage, by annotating with isvfat.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
