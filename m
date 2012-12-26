Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab2LZIRT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 03:17:19 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:48380 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751189Ab2LZIRR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 03:17:17 -0500
Message-ID: <1356509836.28255.4.camel@joe-AO722>
Subject: Re: [PATCH 1/5] f2fs: Introduce some information prints in the
 mount path
From: Joe Perches <joe@perches.com>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: jaegeuk.kim@samsung.com, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Wed, 26 Dec 2012 00:17:16 -0800
In-Reply-To: <CAKYAXd_1VjQAVyGkvLKqy1ceE8rKCz1cRuoWg+RgSEF-M_OFEA@mail.gmail.com>
References: <1356145725-19940-1-git-send-email-linkinjeon@gmail.com>
	 <1356486933.16178.144.camel@kjgkr>
	 <CAKYAXd_-c4Mh0hQHBiNDVOrWmq=TVXEuoaWd1hzrA70t9p6=ag@mail.gmail.com>
	 <1356488089.28255.1.camel@joe-AO722>
	 <CAKYAXd_1VjQAVyGkvLKqy1ceE8rKCz1cRuoWg+RgSEF-M_OFEA@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-12-26 at 13:22 +0900, Namjae Jeon wrote:
> 2012/12/26, Joe Perches <joe@perches.com>:
> > On Wed, 2012-12-26 at 11:10 +0900, Namjae Jeon wrote:
> >> 2012/12/26, Jaegeuk Kim <jaegeuk.kim@samsung.com>:
> >> > Could you make them follow the file system convention?
> >> > Something like "F2FS: blah blah~".
> >> Yes,  I agree.
> >> > Otherwise, how about adding a debugging function to express the prefix?
> >> Okay, I will send you the patches included your suggestion.
> > Add
> > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > before any #include
> Hi Joe.

Hello Namjae

> I think we can have debugging message function for f2fs similar to
> ext4/fat like fat_msg, ext4_msg.
> It is one time change but in the future it will allow more convenience
> to use that way.
> What is your opinion ?
> 
> Or is that we have to to use pr_xxx function for error print instead
> of own print debug function ?

Sure, make your own f2fs_dbg function/macro when
and if you have an object you want to pass along
with the format and args

something like:

fs2fs_printk(struct fs2fs_handle *f2h, const char *fmt, ...)

Otherwise, just use pr_debug/pr_<level>(fmt, ...)

cheers, Joe

