Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab1C2Hde (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:33:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64257 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179Ab1C2Hdd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:33:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=C4rw2yjzx6b5CLHLJBc25LHf4wbYMbRKXw+Oll6svEcDjgtJO+32HRa+t/zpCPw5SD
         3weU+ZZqz6FAZz5aeqM2+57h/9Yqfek46N5KkA3fUyF0B16pHmYBiYp2kPHU3H5kHfmE
         ymRLz+vmgoHqi6pweoBsJknT/AHt7F9CU07w8=
MIME-Version: 1.0
In-Reply-To: <20110329115546.C08C.A69D9226@jp.fujitsu.com>
References: <20110328215344.GC3008@dastard>
	<BANLkTimHPFMUOCFAruF5J4OMHSkZsMsAgA@mail.gmail.com>
	<20110329115546.C08C.A69D9226@jp.fujitsu.com>
Date: Tue, 29 Mar 2011 11:33:32 +0400
Message-ID: <AANLkTinvo6tZo8GtWohHpu5a0=EQvGz85zU55X5RTUxQ@mail.gmail.com>
Subject: Re: Very aggressive memory reclaim
From: John Lepikhin <johnlepikhin@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Minchan Kim <minchan.kim@gmail.com>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, xfs@oss.sgi.com, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/3/29 KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>:

> If my remember is correct, 2.6.38 is included Mel's anti agressive
> reclaim patch. And original report seems to be using 2.6.37.x.
>
> John, can you try 2.6.38?

I'll ask my boss about it. Unfortunately we found opposite issue with
memory management + XFS (100M of inodes) on 2.6.38: some objects in
xfs_inode and dentry slabs are seems to be never cleared (at least
without "sync && echo 2 >.../drop_caches"). But this is not a
production machine working 24x7, so we don't care about it right now.
