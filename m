Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751699Ab2JNGwG (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 02:52:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48920 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751435Ab2JNGwF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 02:52:05 -0400
Message-ID: <1350197514.1915.222.camel@kjgkr>
Subject: Re: [PATCH 11/16] f2fs: add inode operations for special inodes
From: Jaegeuk Kim <jaegeuk.kim@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: =?euc-kr?Q?=B1=E8=C0=E7=B1=D8?= <jaegeuk.kim@samsung.com>,
        viro@zeniv.linux.org.uk, "'Theodore Ts'o'" <tytso@mit.edu>,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Date: Sun, 14 Oct 2012 15:51:54 +0900
In-Reply-To: <201210132052.09835.arnd@arndb.de>
References: <001201cda2f1$633db960$29b92c20$%kim@samsung.com>
	 <201210132052.09835.arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 8bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-10-13 (토), 20:52 +0000, Arnd Bergmann:
> On Friday 05 October 2012, 김재극 wrote:
> > +const char *media_ext_lists[] = {
> > +       "jpg",
> > +       "gif",
> > +       "png",
> > +       "avi",
> > +       "divx",
> > +       "mp4",
> > +       "mp3",
> > ...
> 
> > + * Set multimedia files as cold files for hot/cold data separation
> > + */
> > +static inline void set_cold_file(struct inode *inode, const unsigned char *name)
> > +{
> > +       const char **extlist = media_ext_lists;
> > +
> > +       while (*extlist) {
> > +               if (!is_multimedia_file(name, *extlist)) {
> > +                       F2FS_I(inode)->is_cold = 1;
> > +                       break;
> > +               }
> > +               extlist++;
> > +       }
> > +}
> 
> This is a very clever way of categorizing files by their name, but I wonder if hardcoding
> the list of file name extensions at in the kernel source is the best strategy. Generally
> I would consider this to be a policy that should be configurable by the user.
> 
> Unfortunately I can't think of a good interface to configure this, but maybe someone
> else has a useful idea. Maybe the list can be stored in the superblock and get written
> at mkfs time from the same defaults, but with the option of overriding it using
> a debugfs tool.
> 

Good point!
I'll think about a user-made list.
Thanks,

> 	Arnd
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
Jaegeuk Kim
Samsung

