Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758606Ab0FJDaY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 23:30:24 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21664 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758228Ab0FJDaT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 23:30:19 -0400
MIME-Version: 1.0
Message-ID: <c773d65b-e107-428c-ba6f-04d4ca9f8361@default>
Date: Wed, 9 Jun 2010 20:28:21 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: ngupta@vflare.org
Cc: chris.mason@oracle.com, viro@zeniv.linux.org.uk, akpm@linux-foundation.org,
       adilger@sun.com, tytso@mit.edu, mfasheh@suse.com,
       joel.becker@oracle.com, matthew@wil.cx, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       linux-ext4@vger.kernel.org, ocfs2-devel@oss.oracle.com,
       linux-mm@kvack.org, jeremy@goop.org, JBeulich@novell.com,
       kurt.hackel@oracle.com, npiggin@suse.de, dave.mccracken@oracle.com,
       riel@redhat.com, avi@redhat.com, konrad.wilk@oracle.com
Subject: RE: [PATCH V2 2/7] Cleancache (was Transcendent Memory): core files
References: <20100528173550.GA12219@ca-server1.us.oracle.com
 4C1042E0.8080403@vflare.org>
In-Reply-To: <4C1042E0.8080403@vflare.org>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 1.5.1.5.2  (401224) [OL
 12.0.6514.5000]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4C105C2F.01D3:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I just finished a rough (but working) implementation of in-kernel
> page cache compression backend (called zcache). During this work,
> I found some issues with cleancache, mostly related to (lack of)
> comments/documentation:

Great to hear!  And excellent feedback on the missing
documentation... I am working on this right now so your
feedback is very timely.

(documentation and funcition return values comments deleted
as I will fix all of them)

> > +
> > +static inline int cleancache_init_fs(size_t pagesize)
> > +
> 
>  - It seems that returning pool_id of 0 is considered as error
> condition (as it appears from deactivate_locked_super() changes).
> This seems weird; I think only negative pool_id should considered
> as error. Anyway, please add function comments for these.

Hmmm... this is a bug.  0 is a valid pool_id.  I'll fix it
for the next rev.

> Page cache compression was a long-pending project. I'm glad its
> coming into shape with the help of cleancache :)

Thanks!
Dan
