Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab2GFN6M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2012 09:58:12 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:33293 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751168Ab2GFN6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2012 09:58:10 -0400
MIME-Version: 1.0
Reply-To: hanwen@xs4all.nl
In-Reply-To: <4FF67D6A.8060707@gmail.com>
References: <20120705105017.17812.95542.stgit@ltc137.sdl.hitachi.co.jp>
	<4FF67D6A.8060707@gmail.com>
Date: Fri, 6 Jul 2012 10:58:07 -0300
Message-ID: <CAOw_e7ZGdSVrNfPe8iE8BtmNWU+BrvbaMFVsUP+g+3MR0Pegqw@mail.gmail.com>
Subject: Re: [fuse-devel] [RFC PATCH 0/5] fuse: make maximum read/write
 request size tunable
From: Han-Wen Nienhuys <hanwenn@gmail.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>,
        fuse-devel@lists.sourceforge.net, yrl.pp-manager.tt@hitachi.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Miklos Szeredi <miklos@szeredi.hu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 6, 2012 at 2:53 AM, Liu Yuan <namei.unix@gmail.com> wrote:
> On 07/05/2012 06:50 PM, Mitsuo Hayasaka wrote:
>> One of the ways to solve this is to make them tunable.
>> In this series, the new sysfs parameter max_pages_per_req is introduced.
>> It limits the maximum read/write size in fuse request and it can be
>> changed from 32 to 256 pages in current implementations. When the
>> max_read/max_write mount option is specified, FUSE request size is set
>> per mount. (The size is rounded-up to page size and limited up to
>> max_pages_per_req.)
>
> Why maxim 256 pages? If we are here, we can go further: most of object
> storage system has object size of multiple to dozens of megabytes. So I
> think probably 1M is too small. Our distribution storage system has 4M
> per object, so I think at least maxim size could be bigger than 4M.

The maximum pipe size on my system is 1M, so if you go beyond that,
splicing from the FD won't work.

Also, the userspace client must reserve a buffer this size so it can
receive a write, which is a waste since most requests are much
smaller.

-- 
Han-Wen Nienhuys - hanwen@xs4all.nl - http://www.xs4all.nl/~hanwen
