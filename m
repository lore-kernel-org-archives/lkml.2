Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab2FVKqq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 06:46:46 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:44885 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757828Ab2FVKqp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 06:46:45 -0400
Date: Fri, 22 Jun 2012 06:46:39 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@oneiric
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
cc: ysato@users.sourceforge.jp
Subject: finding unused header files
Message-ID: <alpine.DEB.2.02.1206220641150.6493@oneiric>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  inspired by that last post that located an unused header file under
arch/h8300, i ran my "find_unused_headers.sh" script on the same
sub-directory to see what would show up.

  the script is stupidly conservative and didn't identify that shm.h
header since *somewhere* in the entire kernel source tree, someone was
including a file called "shm.h" -- not even for the same architecture.
like i said, stupidly conservative.

  but it did find this:

$ ../s/find_unused_headers.sh arch/h8300
===== target_time.h =====
./arch/h8300/include/asm/target_time.h
$

and i see nothing anywhere in the entire tree that includes a
target_time.h header under any circumstances.

  i should probably do another run of these scripts some day, just to
see what turns up.

rday

-- 

========================================================================
Robert P. J. Day                                 Ottawa, Ontario, CANADA
                        http://crashcourse.ca

Twitter:                                       http://twitter.com/rpjday
LinkedIn:                               http://ca.linkedin.com/in/rpjday
========================================================================
