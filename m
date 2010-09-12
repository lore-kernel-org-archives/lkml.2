Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752554Ab0ILKgY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Sep 2010 06:36:24 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:41682 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0ILKgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Sep 2010 06:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=wfZRcPsmix+TxGxNS+eSqBm1CMQ5feT/Zi27BgO2zDIAaoKHq1jCmn8d9wpRDb6mU3
         TCfMOx/ZteaXGMLC4bFKEAYx+wz0p/Nu74rmCBLblAPwslwcVi0+gGfG82n+g+I8Op3Q
         houNwVbD30zWkVIDx8petgWReS6S1Lo76M5jE=
MIME-Version: 1.0
In-Reply-To: <1284129724.23418.27.camel@ubuntu1004pl>
References: <1284129724.23418.27.camel@ubuntu1004pl>
Date: Sun, 12 Sep 2010 13:36:21 +0300
Message-ID: <AANLkTimU2k6=GPgMsabqpv+uwTVWtSoOoUmwOBbSAT4K@mail.gmail.com>
Subject: Re: [PATCH] fs/btrfs/ordered-data.c: fixed compiler warnings for
 using uninitialized variable
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Frank Morales II <altf2o@gmail.com>
Cc: chris.mason@oracle.com, josef@redhat.com, zheng.yan@oracle.com,
        jens.axboe@oracle.com, tj@kernel.org, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 10, 2010 at 5:42 PM, Frank Morales II <altf2o@gmail.com> wrote:
> >From 1c304defc543738f82ccb18fe10b558dd2098d74 Mon Sep 17 00:00:00 2001
> From: Frank Morales II <altf2o@gmail.com>
> Date: Fri, 10 Sep 2010 07:34:23 -0700
> Subject: [PATCH] fs/btrfs/ordered-data.c: fixed compiler warnings for using uninitialized variable
>
> In the function tree_search, the variable prev was used without first
> being initialized, causing compiler warning messages. Initializing
> prev to NULL resolved the issue.
>
> Kernal patched against: 2.6.36-rc3 (df423dc7)

Signed-of-by: Felipe Contreras <felipe.contreras@gmail.com>

I came up with exactly this patch, but this is my commit message:

    Btrfs: fix compilation warning

    fs/btrfs/ordered-data.c: In function ‘tree_search’:
    fs/btrfs/ordered-data.c:144: warning: ‘prev’ may be used
uninitialized in this function
    fs/btrfs/ordered-data.c: In function ‘btrfs_lookup_first_ordered_extent’:
    fs/btrfs/ordered-data.c:144: warning: ‘prev’ may be used
uninitialized in this function
    fs/btrfs/ordered-data.c:144: note: ‘prev’ was declared here
    fs/btrfs/ordered-data.c: In function ‘btrfs_lookup_ordered_extent’:
    fs/btrfs/ordered-data.c:144: warning: ‘prev’ may be used
uninitialized in this function
    fs/btrfs/ordered-data.c:144: note: ‘prev’ was declared here
    fs/btrfs/ordered-data.c: In function ‘btrfs_lookup_ordered_range’:
    fs/btrfs/ordered-data.c:144: warning: ‘prev’ may be used
uninitialized in this function
    fs/btrfs/ordered-data.c:144: note: ‘prev’ was declared here
    fs/btrfs/ordered-data.c: In function ‘btrfs_dec_test_ordered_pending’:
    fs/btrfs/ordered-data.c:144: warning: ‘prev’ may be used
uninitialized in this function
    fs/btrfs/ordered-data.c:144: note: ‘prev’ was declared here

    __tree_search() might not set &prev.

-- 
Felipe Contreras
