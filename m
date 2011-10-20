Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab1JTR7B (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 13:59:01 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35478 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab1JTR7A convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 13:59:00 -0400
MIME-Version: 1.0
Date: Thu, 20 Oct 2011 12:58:58 -0500
Message-ID: <CAH2r5msNR2OZRdAtt_V5Z56RiSbyCguTte_XCF1LFj+dNMdrvQ@mail.gmail.com>
Subject: Current cifs code doubles file copy speed from server to Linux client
 - due to Jeff Layton's async read patch set
From: Steve French <smfrench@gmail.com>
To: linux-cifs@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        samba-technical <samba-technical@lists.samba.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did a quick check of the current cifs-2.6.git tree (in linux-next,
which I will be requesting to be merged into 3.2-pre).  Thanks to Jeff
Layton's async read patch set, as expected the file copy performance
from server to Linux client is dramatically faster.

In a quick test copying a directory containing 144MB of movie trailers
from a typical Windows Vista desktop system (as desktop) using the
Linux cifs kernel client the speed more than doubled.   Performance
should be even better to Linux/Samba servers due to Samba's larger
maximum i/o sizes.

When you also consider that Pavel's byte range lock queueing and lock
batching patches should help some workloads a lot, and that his SMB2
code will allow oplock (lease) upgrades - the performance of 3.2 cifs
kernel client should be much better.

--
Thanks,

Steve
