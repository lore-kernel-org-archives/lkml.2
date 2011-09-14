Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933345Ab1INVCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 17:02:47 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:43562 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933305Ab1INVCq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 17:02:46 -0400
MIME-Version: 1.0
In-Reply-To: <CAC9WiBjbWTRBkRN6pKSqJLVJXzcx89j7oFpCf0dzVeHAJM8zyw@mail.gmail.com>
References: <1315941562-25422-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<a7d17e7e-c6a1-448e-b60f-b79a4ae0c3ba@default>
	<CAC9WiBjbWTRBkRN6pKSqJLVJXzcx89j7oFpCf0dzVeHAJM8zyw@mail.gmail.com>
Date: Wed, 14 Sep 2011 23:02:45 +0200
Message-ID: <CAC9WiBiHZ8jSBRaFQdsk-DwaNLFyR=e0zWUgrNEu6mE0ZoS0vQ@mail.gmail.com>
Subject: Re: [PATCH] staging: zcache: fix cleancache crash
From: Francis Moreau <francis.moro@gmail.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, gregkh@suse.de,
        devel@driverdev.osuosl.org, linux-mm@kvack.org, ngupta@vflare.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 11:26 AM, Francis Moreau <francis.moro@gmail.com> wrote:
> On Tue, Sep 13, 2011 at 10:56 PM, Dan Magenheimer
> <dan.magenheimer@oracle.com> wrote:
>>> From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
>>> Sent: Tuesday, September 13, 2011 1:19 PM
>>> To: gregkh@suse.de
>>> Cc: devel@driverdev.osuosl.org; linux-mm@kvack.org; ngupta@vflare.org; linux-kernel@vger.kernel.org;
>>> francis.moro@gmail.com; Dan Magenheimer; Seth Jennings
>>> Subject: [PATCH] staging: zcache: fix cleancache crash
>>>
>>> After commit, c5f5c4db, cleancache crashes on the first
>>> successful get. This was caused by a remaining virt_to_page()
>>> call in zcache_pampd_get_data_and_free() that only gets
>>> run in the cleancache path.
>>>
>>> The patch converts the virt_to_page() to struct page
>>> casting like was done for other instances in c5f5c4db.
>>>
>>> Based on 3.1-rc4
>>>
>>> Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
>>
>> Yep, this appears to fix it!  Hopefully Francis can confirm.
>
> Ok I can give this a try and let you know.

This patch has fixed the issue I was hitting with qemu.

Thanks
-- 
Francis
