Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756486Ab0HaBAO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 21:00:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:17669 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756364Ab0HaBAM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 21:00:12 -0400
MIME-Version: 1.0
Message-ID: <91408f0c-0135-427f-b148-446f54b232eb@default>
Date: Mon, 30 Aug 2010 17:57:04 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Chris Mason <chris.mason@oracle.com>, viro@zeniv.linux.org.uk,
        akpm@linux-foundation.org, adilger@sun.com, tytso@mit.edu,
        mfasheh@suse.com, Joel Becker <joel.becker@oracle.com>, matthew@wil.cx,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org, ngupta@vflare.org,
        JBeulich@novell.com, Kurt Hackel <kurt.hackel@oracle.com>,
        npiggin@kernel.dk, Dave Mccracken <dave.mccracken@oracle.com>,
        riel@redhat.com, avi@redhat.com, Konrad Wilk <konrad.wilk@oracle.com>,
        mel@csn.ul.ie, yinghan@google.com, gthelen@google.com
Subject: RE: [PATCH V4 5/8] Cleancache: ext3 hook for cleancache
References: <20100830223233.GA1317@ca-server1.us.oracle.com
 4C7C3666.2080601@goop.org>
In-Reply-To: <4C7C3666.2080601@goop.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.2.1.2  (406224) [OL
 12.0.6535.5005]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > @@ -1349,6 +1350,7 @@ static int ext3_setup_super(struct super
> >  	} else {
> >  		ext3_msg(sb, KERN_INFO, "using internal journal");
> >  	}
> > +	sb->cleancache_poolid = cleancache_init_fs(PAGE_SIZE);
> 
> Do you really need to pass in the page size?  What about just
> "cleancache_init_fs(sb)" rather than exposing the
> "sb->cleancache_poolid"?  In other words, what if you want to do
> more/other per-filesystem init at some point?

IIRC, I think I was trying to stay away from including
fs.h in cleancache.h (or one of its predecessors).  I
agree that that no longer makes sense and it is cleaner
as you suggest.  Will change.

Thanks,
Dan
