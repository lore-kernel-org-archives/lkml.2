Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755235Ab3ADUZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Jan 2013 15:25:33 -0500
Received: from mail-ia0-f175.google.com ([209.85.210.175]:56392 "EHLO
	mail-ia0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755211Ab3ADUZa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Jan 2013 15:25:30 -0500
MIME-Version: 1.0
In-Reply-To: <1357145621-3438-1-git-send-email-ngupta@vflare.org>
References: <1357145621-3438-1-git-send-email-ngupta@vflare.org>
Date: Fri, 4 Jan 2013 12:25:28 -0800
Message-ID: <CAPkvG_fGpjcVqeYgZnzNM6dpicB5YaJP9TA9bz2nUDJrHtJkGw@mail.gmail.com>
Subject: Re: [PATCH][RESEND] staging: zram: fix invalid memory references
 during disk write
From: Nitin Gupta <ngupta@vflare.org>
To: Greg KH <greg@kroah.com>
Cc: Jerome Marchand <jmarchan@redhat.com>, Minchan Kim <minchan.kim@gmail.com>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 2, 2013 at 8:53 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> Fixes a bug introduced by commit c8f2f0db1 ("zram: Fix handling
> of incompressible pages") which caused invalid memory references
> during disk write. Invalid references could occur in two cases:
>  - Incoming data expands on compression: In this case, reference was
> made to kunmap()'ed bio page.
>  - Partial (non PAGE_SIZE) write with incompressible data: In this
> case, reference was made to a kfree()'ed buffer.
>
> Fixes bug 50081:
> https://bugzilla.kernel.org/show_bug.cgi?id=50081
>

Greg: can you please add this to staging? It fixes an important issue
and is tested by many users.

Nitin
