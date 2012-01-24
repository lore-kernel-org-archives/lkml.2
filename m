Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab2AXQ0L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 11:26:11 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:49263 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755204Ab2AXQ0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 11:26:08 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [RFC 1/3] /dev/low_mem_notify
Date: Tue, 24 Jan 2012 16:25:55 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc7; KDE/4.3.2; x86_64; ; )
Cc: Marcelo Tosatti <mtosatti@redhat.com>, Rik van Riel <riel@redhat.com>,
        Minchan Kim <minchan@kernel.org>, "linux-mm" <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>, leonid.moiseichuk@nokia.com,
        kamezawa.hiroyu@jp.fujitsu.com, mel@csn.ul.ie, rientjes@google.com,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ronen Hod <rhod@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
References: <1326788038-29141-1-git-send-email-minchan@kernel.org> <20120124154001.GB10990@amt.cnet> <1327420880.13624.24.camel@jaguar>
In-Reply-To: <1327420880.13624.24.camel@jaguar>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201201241625.55295.arnd@arndb.de>
X-Provags-ID: V02:K0:jytNgZkXFiyyQ0+HID3nBpRdCqrSWxTR4ekwO7kDCMY
 OJAqY+dwEB9q7vVlJKW0XcZDO/0mHEzmIa7Ijc1MCPkXjLE8Fp
 ij1lLDJ2xmxhPqFmXR+ahnHk6AirCo70rQ/I1wijgDcBINn3/x
 S/2EM5s2gAvVfLsz5g2bgeg44vKXr+YFtarltDx398cQN169s5
 xqHBKTpYps/6Q5BtcoL5fR4yWXu8BwxUVHH/SJIamyKo4m6/bn
 70pkYVA74RCDqXpVYJMUbcYZceBNc+f/FiuHWjVwLscmIBn4yr
 jZPWsxX6ny/ybv+bA0Crxxe7R0cRJB/c6fLmaFs943j5EvcjP8
 i2KldNiEa1yaC3r3BFOo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 January 2012, Pekka Enberg wrote:
> On Tue, 2012-01-24 at 13:40 -0200, Marcelo Tosatti wrote:
> > What is the practical advantage of a syscall, again?
> 
> Why do you ask? The advantage for this particular case is not needing to
> add ioctls() for configuration and keeping the file read/write ABI
> simple.

The two are obviously equivalent and there is no reason to avoid
ioctl in general. However I agree that the syscall would be better
in this case, because that is what we tend to use for core kernel
functionality, while character devices tend to be used for I/O device
drivers that need stuff like enumeration and permission management.

	Arnd
