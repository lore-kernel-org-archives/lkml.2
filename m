Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753718Ab2IIJdL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 05:33:11 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:36793 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753473Ab2IIJcT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 05:32:19 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, Al Viro <viro@zeniv.linux.org.uk>,
        akpm@linux-foundation.org, bfields@fieldses.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v2 1/5] fat: allocate persistent inode numbers
References: <1346774264-8031-1-git-send-email-linkinjeon@gmail.com>
	<20120904161747.GJ23464@ZenIV.linux.org.uk>
	<CAKYAXd_wTxqbC-UxYimCkZtvSddx=f3FG0hoiEY_doMjoxkKog@mail.gmail.com>
	<87harc34d9.fsf@devron.myhome.or.jp>
	<CAKYAXd-8aztDe1QiFT=NSQX8J+h_FM+cAWwo+Q+fUQHpNGTctw@mail.gmail.com>
	<87y5knz6l5.fsf@devron.myhome.or.jp>
	<CAKYAXd_mxq26bhRYd-YM9OBjYMO12TD4wHxm6PqHBLjgGFHaZg@mail.gmail.com>
	<CAKYAXd-QtSYy4SQErVTXrxcv=YhFzhOm3PKpj=HoZKmpAG7vGQ@mail.gmail.com>
	<1347020137.2223.13.camel@iscandar.digidescorp.com>
Date: Sun, 09 Sep 2012 18:32:08 +0900
In-Reply-To: <1347020137.2223.13.camel@iscandar.digidescorp.com> (Steven
	J. Magnani's message of "Fri, 07 Sep 2012 07:15:37 -0500")
Message-ID: <87oblfpmnb.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> On Fri, 2012-09-07 at 16:01 +0900, Namjae Jeon wrote: 
>> Hi. OGAWA.
>> 
>> I checked read-only option for export on FAT.
>> I think that there are 3 approaches as mentioned below.
>> 
>> 1. As per the current scenario – user already has the option of
>> setting ‘ro’ in /etc/exports – so that can also be used to make it
>> read-only.
>> 	
>> 2. Forcefully set to “read-only” while executing FAT export operation.
>> -> As you know, we can set read-only(ro) export in /etc/exports.
>> If we set read-only export regardless of /etc/exports, This is "HACK"
>> and it will work regardless of user setting.
>> 
>> 3. When FAT is mounted with -onfs option,-> Make it ‘ro’ at the mount
>> time itself.
>> -> It is simple to implement, but VFAT of NFS Server will be set to
>> read-only as well as NFS client.
>
> I argue against (2) and (3). A change that drops any possibility of
> NFS-mounting VFAT filesystems read-write will break my use case. Where
> ESTALE is an issue, there are client-side solutions, either mounting
> with lookupcache=none (which admittedly has a severe performance impact)
> or the VFS patches to handle ESTALE that are working their way towards
> mainline. I recognize that not everyone can take advantage of
> client-side features, but options (2) and (3) make life worse for those
> who can.

What is your use case?  I'm assuming current NFS support of FAT is not
unstable behavior even with your patches. Is this true?

Well, this plan is to provide the stable/clean read-only behavior at
first.  After that, make it writable with some limitations (e.g. rename
may be unsupported).

If your patches in -mm is enough for now, we will not need to do those.
Namjae, were you tested it? or what are you thinking?
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
