Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753394Ab1DOQlG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 12:41:06 -0400
Received: from lo.gmane.org ([80.91.229.12]:48412 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752947Ab1DOQlE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 12:41:04 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Holger Hoffstaette" <holger.hoffstaette@googlemail.com>
Subject: 2.6.38.3 leaking disk space of files created via NFS
Date: Fri, 15 Apr 2011 18:40:43 +0200
Organization: The Fists of the White Lotus
Message-ID: <pan.2011.04.15.16.40.43.665250@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: p5086ddb6.dip.t-dialin.net
User-Agent: Pan/0.13.91 (Before we let euphoria convince us we are free)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


It seems that 2.6.38.3 is still having pretty severe problems with NFS.
Files that were created/written (or only read?) via NFS can be deleted
from the server (after unmounting the client), but the disk space is not
freed. More precisely it's Gentoo's /usr/portage/distfiles on ext4 and
clients save downloaded package tarballs there.

There are no stale .nfsXX files or open file handles; the disk space is
returned after a reboot of the server, which is obviously not really an
option. I do get a message about deleted orphan inodes on reboot.

Is this a known problem? Sorry if this is a bit vague but I can't
constantly reboot the server for experiments. Anyone else who can observe
this problem?

thanks,
Holger


