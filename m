Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab1E0NuJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 09:50:09 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46294 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755732Ab1E0NuG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 09:50:06 -0400
Subject: Cleancache and shared filesystems
From: Steven Whitehouse <swhiteho@redhat.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Fri, 27 May 2011 14:51:40 +0100
Message-ID: <1306504300.2857.14.camel@menhir>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm trying to figure out what I would need to do in order to get GFS2 to
work with cleancache. Looking at the OCFS2 implementation leaves me with
some questions about how this is supposed to work. The docs say that the
cleancache_init_shared_fs() function is supposed to take a 128 bit UUID
plus the sb.

In OCFS2 it is passed a pointer to a 32 bit little endian quantity as
the UUID:

__le32 uuid_net_key;

...

memcpy(&uuid_net_key, di->id2.i_super.s_uuid, sizeof(uuid_net_key));

...

cleancache_init_shared_fs((char *)&uuid_net_key, sb);

and in the Xen backend driver this then appears to be dereferenced as if
its two 64 bit values, which doesn't look right to me.

Also, since the sb has a UUID field in it anyway, is there some reason
why that cannot be used directly rather than passing the uuid as a
separate variable?

Steve.


