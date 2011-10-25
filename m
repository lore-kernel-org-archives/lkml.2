Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751811Ab1JYQYw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:24:52 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:38160 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375Ab1JYQYu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:24:50 -0400
MIME-Version: 1.0
Date: Tue, 25 Oct 2011 11:24:49 -0500
Message-ID: <CAH2r5mu39JJ+SH4EwrnLNuNDR81N-x7-x8AadooZ15ddzEWhwg@mail.gmail.com>
Subject: cifs dbench performance increased even over localhost mounts
From: Steve French <smfrench@gmail.com>
To: linux-cifs@vger.kernel.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In testing the cifs-2.6.git tree for 3.2-pre, I noticed that dbench
cifs dbench performance improved even over localhost mounts (to Samba)
by more than 5% (60 processes).   I don't know what part of that is
due to the improved byte range lock caching (Pavel's patch set) or
larger i/o sizes on read or better async read dispatch (Jeff's patch
set), but suspect that the latter helped more.   Relative performance
should improve even more with fewer dbench processes as better async
dispatch of large read requests helps utilize the Samba server more
efficiently.


-- 
Thanks,

Steve
