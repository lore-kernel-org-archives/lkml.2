Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752558Ab0GWIRL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 04:17:11 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:48433 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab0GWIRH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 04:17:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pOfzotXoU+D7R2G9QyPYFggPrpi074ynWUBCWk8U7pnngOWCgtOX3IX3XRJjbUWAb9
         J0WDEGJtFvKs/m96oyfp7BQ3wNgwOo+vvKHaaSCyOaGncICm1zH1ZVS3BgJK2ziy8CZa
         mom+D2YscYL5uucsNkcqrqP3zJXFa7qzWPRX8=
MIME-Version: 1.0
In-Reply-To: <4C49468B.40307@vflare.org>
References: <20100621231809.GA11111@ca-server1.us.oracle.com>
	<4C49468B.40307@vflare.org>
Date: Fri, 23 Jul 2010 17:16:47 +0900
Message-ID: <AANLkTikV6nypnLHjaidOyJPsP9xDawQ9ABOoRWKB-2+B@mail.gmail.com>
Subject: Re: [PATCH V3 0/8] Cleancache: overview
From: Minchan Kim <minchan.kim@gmail.com>
To: ngupta@vflare.org
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, chris.mason@oracle.com,
        viro@zeniv.linux.org.uk, akpm@linux-foundation.org, adilger@sun.com,
        tytso@mit.edu, mfasheh@suse.com, joel.becker@oracle.com,
        matthew@wil.cx, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        linux-mm@kvack.org, jeremy@goop.org, JBeulich@novell.com,
        kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com,
        riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 23, 2010 at 4:36 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>
> 2. I think change in btrfs can be avoided by moving cleancache_get_page()
> from do_mpage_reapage() to filemap_fault() and this should work for all
> filesystems. See:
>
> handle_pte_fault() -> do_(non)linear_fault() -> __do_fault()
>                                                -> vma->vm_ops->fault()
>
> which is defined as filemap_fault() for all filesystems. If some future
> filesystem uses its own custom function (why?) then it will have to arrange for
> call to cleancache_get_page(), if it wants this feature.


filemap fault works only in case of file-backed page which is mapped
but don't work not-mapped cache page.  So we could miss cache page by
read system call if we move it into filemap_fault.


-- 
Kind regards,
Minchan Kim
