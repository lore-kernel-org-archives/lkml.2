Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932152Ab2JZISf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 04:18:35 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:58228 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757275Ab2JZIS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:18:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Subject: Re: [PATCH 02/16 v2] f2fs: add on-disk layout
Date: Fri, 26 Oct 2012 08:18:17 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: "'Vyacheslav Dubeyko'" <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, tytso@mit.edu, chur.lee@samsung.com,
        cm224.lee@samsung.com, jooyoung.hwang@samsung.com
References: <001001cdb0c5$2ac96520$805c2f60$%kim@samsung.com> <1351077945.2097.9.camel@slavad-ubuntu> <00e601cdb32a$59fbe090$0df3a1b0$%kim@samsung.com>
In-Reply-To: <00e601cdb32a$59fbe090$0df3a1b0$%kim@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201210260818.18155.arnd@arndb.de>
X-Provags-ID: V02:K0:I14LHdh+DVP1WZi9PpCgq6wIGuk3vS0Xl9jqjxvl9Uu
 OVODKOlNwVPXUKVhD3slS2yxDD3kyloEeuJu2GLezCN482I5Uq
 wns/T7gYqx43J3OnqVnZeNpumTWKo+sDk/OAoXVZAUS1GuTN22
 JD1gYnDGkkOhHFqSOHTaLANNK8f2xvAx1lutKfU+zGxdv2si7N
 kOUlThHgNcdQbVU8sz25MHSybHtFIj8e1ccIBG39QatTzNvYHd
 4sLy3O+2h8fOO7r21kD2lRb+phH+SV/T/kuq9S2+jQon+WJWY1
 zcszxFm0lGIDrCrMHsGfKy9llIAgoE6xyhqRtp2y6LKc3otwIr
 OCAlZFg2ZcY3q8F9GlsY=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2012, Jaegeuk Kim wrote:

> > > +
> > > +#define F2FS_ROOT_INO(sbi)	(sbi->root_ino_num)
> > > +#define F2FS_NODE_INO(sbi)	(sbi->node_ino_num)
> > > +#define F2FS_META_INO(sbi)	(sbi->meta_ino_num)
> > > +
> > > +#define GFP_F2FS_MOVABLE	(__GFP_WAIT | __GFP_IO | __GFP_ZERO)
> > > +
> > > +#define MAX_ACTIVE_LOGS	16
> > > +#define MAX_ACTIVE_NODE_LOGS	8
> > > +#define MAX_ACTIVE_DATA_LOGS	8
> > 
> > I think that it makes sense to comment the reasons of such limitations
> > in MAX_ACTIVE_LOGS, MAX_ACTIVE_NODE_LOGS, MAX_ACTIVE_DATA_LOGS.
> 
> The maximum number of logs is suggested by arnd before.
> As I understood, why he suggested such a quite large number is for further
> optimization of multiple logs without any on-disk layout changes.
> And, I think it is quite enough.

I agree. I think Vyacheslav was just asking you to add a comment
explaining how we got to these numbers, like

/*
 * The file format supports up to 16 active logs, which should be
 * more than enough for future optimizations. The implementation
 * currently uses no more than 6 logs.
 * Half the logs are used for nodes, the other half are used for data.
 */


	Arnd
