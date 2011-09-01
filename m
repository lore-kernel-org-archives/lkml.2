Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757282Ab1IABML (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 21:12:11 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44429 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752307Ab1IABMH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 21:12:07 -0400
MIME-Version: 1.0
In-Reply-To: <4E5ED2D5.8040302@linux.vnet.ibm.com>
References: <4E5ED2D5.8040302@linux.vnet.ibm.com>
Date: Thu, 1 Sep 2011 09:10:06 +0800
Message-ID: <CAGBYx2ZKn89qeGR-mbNyF6--DEtRjsm5ijRU9TW1zEVQAh+DoQ@mail.gmail.com>
Subject: Re: lock i_mutex for fallocate?
From: Yongqiang Yang <xiaoqiangnk@gmail.com>
To: Allison Henderson <achender@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org,
        Ext4 Developers List <linux-ext4@vger.kernel.org>,
        Andreas Dilger <adilger@dilger.ca>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Allison,

there are races between read and punch hole too.  After pages are
released and before punch hole hold i_data_sem, a page can be mapped
by read, then write can be done on the page.

Maybe we should separate punch hole from fallocate, and solve the
races in vfs layer.

Yongqiang.
On Thu, Sep 1, 2011 at 8:33 AM, Allison Henderson
<achender@linux.vnet.ibm.com> wrote:
> Hi All,
>
> In ext4 punch hole, we realized that the punch hole operation needs to be
> done under i_mutex just like truncate.  i_mutex for truncate is held in the
> vfs layer, so we dont need to lock it at the file system layer, but vfs does
> not lock i_mutex for fallocate.  We can lock i_mutex for fallocate at the fs
> layer, but question was raised then: should i_mutex for fallocate be held in
> the vfs layer instead?  I do not know if other file systems need i_mutex to
> be locked for fallocate, or if they might be locking it already, so I am
> doing some investigating on this idea, and also the appropriate use of
> i_mutex in general.  Can someone provide some insight this topic?  Thx!
>
> Allison Henderson
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Best Wishes
Yongqiang Yang
