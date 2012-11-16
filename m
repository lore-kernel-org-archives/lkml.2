Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751204Ab2KPHvm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 02:51:42 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:57639 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765Ab2KPHvl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:51:41 -0500
MIME-Version: 1.0
In-Reply-To: <50A5DFA4.2030700@gmail.com>
References: <5094E4A3.8020409@gmail.com>
	<50A5DFA4.2030700@gmail.com>
Date: Fri, 16 Nov 2012 08:45:25 +0100
Message-ID: <CANGUGtAF0CRzYOkjqCXvxukw99Y9G02Ht=DZ8viRHqThGHLSSQ@mail.gmail.com>
Subject: Re: [PATCH 20/21] mm: drop vmtruncate
From: Marco Stornelli <marco.stornelli@gmail.com>
To: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
Cc: Linux FS Devel <linux-fsdevel@vger.kernel.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/16 Jaegeuk Hanse <jaegeuk.hanse@gmail.com>:
> On 11/03/2012 05:32 PM, Marco Stornelli wrote:
>>
>> Removed vmtruncate
>
>
> Hi Marco,
>
> Could you explain me why vmtruncate need remove? What's the problem and how
> to substitute it?
>
> Regards,
> Jaegeuk
>

vmtruncate is a deprecated function so it'd be better to remove it.
The truncate sequence is changed for several reasons. The
documentation is clear: "This function is deprecated and
truncate_setsize or truncate_pagecache should be used instead,
together with filesystem specific block truncation." In addition, we
can remove the truncate callback from the inode struct saving 4/8
bytes.

Marco
