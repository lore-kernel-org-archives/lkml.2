Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab0ESPid (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 11:38:33 -0400
Received: from smtp.nokia.com ([192.100.105.134]:23383 "EHLO
	mgw-mx09.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753252Ab0ESPia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 11:38:30 -0400
Date: Wed, 19 May 2010 18:36:05 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext John Masinter <johnmasinter@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: More than 1M open file descriptors
Message-ID: <20100519153605.GA5221@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <AANLkTim5Yuvga5kwOFUaUgxbxzvkD9gyqiEUCN6nTs5b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <AANLkTim5Yuvga5kwOFUaUgxbxzvkD9gyqiEUCN6nTs5b@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 19 May 2010 15:38:09.0324 (UTC) FILETIME=[487CB6C0:01CAF769]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 19, 2010 at 04:52:56PM +0200, ext John Masinter wrote:
>I'm a software engineer and work with a fortune-500 company. We have a
>line of linux-powered network security appliances and I am responsible
>for Linux / OS development.
>Our multi-core appliance handles a large number of low-bandwith tcp
>connections, and after years of performance streamlining, we have hit
>the kernel's million tcp connection limit.
>Is there a kernel hack to increase the file descriptor limit beyond 1M
>to that we may have more than 1M open tcp connections? If this is
>discussed elsewhere, please point me in the right direction. Many
>thanks to everyone that contributes to open source.

look into fs/file.c
increasing sysctl_nr_open like below should help:

diff --git a/fs/file.c b/fs/file.c
index 87e1290..23c83df 100644
--- a/fs/file.c
+++ b/fs/file.c
@@ -27,9 +27,9 @@ struct fdtable_defer {
  	struct fdtable *next;
  };
  
-int sysctl_nr_open __read_mostly = 1024*1024;
+int sysctl_nr_open __read_mostly = 4*1024*1024;
  int sysctl_nr_open_min = BITS_PER_LONG;
-int sysctl_nr_open_max = 1024 * 1024; /* raised later */
+int sysctl_nr_open_max = 4 * 1024 * 1024; /* raised later */
  
  /*
   * We use this list to defer free fdtables that have vmalloced

you can also do it via /proc AFAICT.

-- 
balbi

DefectiveByDesign.org
