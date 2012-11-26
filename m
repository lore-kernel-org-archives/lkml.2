Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755098Ab2KZN14 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 08:27:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:55963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab2KZN1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 08:27:54 -0500
Date: Mon, 26 Nov 2012 14:27:00 +0100
From: Karel Zak <kzak@redhat.com>
To: NeilBrown <neilb@suse.de>
Cc: Jaegeuk Kim <jaegeuk.kim@gmail.com>, util-linux@vger.kernel.org,
        Vyacheslav Dubeyko <slava@dubeyko.com>,
        Martin Steigerwald <Martin@lichtvoll.de>, linux-kernel@vger.kernel.org,
        Jaegeuk Kim <jaegeuk.kim@samsung.com>, linux-fsdevel@vger.kernel.org,
        gregkh@linuxfoundation.org, viro@zeniv.linux.org.uk, arnd@arndb.de,
        tytso@mit.edu, chur.lee@samsung.com, cm224.lee@samsung.com,
        jooyoung.hwang@samsung.com
Subject: Re: util-linux bug: was Re: [PATCH 00/16 v3] f2fs: introduce
 flash-friendly file system
Message-ID: <20121126132700.GA28200@x2.net.home>
References: <003d01cdb74b$0c3fa420$24beec60$%kim@samsung.com>
 <201211021439.02797.Martin@lichtvoll.de>
 <CAOtxgye-sqJFe17EyfJQ0RrMwQqsPbDv5m+4cJT0BjnRnGv56w@mail.gmail.com>
 <201211101933.38434.Martin@lichtvoll.de>
 <8A3372F6-6294-404E-909B-3FDE0C2368B7@dubeyko.com>
 <1352634168.1893.9.camel@kjgkr>
 <20121123112309.52429ceb@notabene.brown>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121123112309.52429ceb@notabene.brown>
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 23, 2012 at 11:23:09AM +1100, NeilBrown wrote:
> This is a bug in util-linux.
> 
> If 'blkid' doesn't recognise the filesystem, mount reads /etc/filesystems
> and tries everything listed there.  If that file ends with a '*', it should
> read /proc/filesystems and try everything else listed that (that doesn't
> start with 'nodev').
> 
> However it currently ignores the '*' and just adds everything

 Fixed. Thanks for the report!

> The following patch (against git://github.com/karelzak/util-linux.git) fixes
> it for me,  though I suspect it should possible ignore 'ENODEV' too -
> otherwise if /etc/filesystems contains an invalid filesystem name, it will
> silently ignore all others.

 Good idea, implemented.

 ... all will be fixed in stable v2.22.2 release.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
