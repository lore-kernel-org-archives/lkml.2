Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758296Ab2CHQsr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:48:47 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60081 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756731Ab2CHQso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:48:44 -0500
Date: Fri, 9 Mar 2012 00:54:03 +0800
From: Zheng Liu <gnehzuil.liu@gmail.com>
To: Minchan Kim <minchan@kernel.org>
Cc: linux-mm <linux-mm@kvack.org>, linux-kernel <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>, riel@redhat.com,
        kosaki.motohiro@jp.fujitsu.com
Subject: Re: Control page reclaim granularity
Message-ID: <20120308165403.GA10005@gmail.com>
Mail-Followup-To: Minchan Kim <minchan@kernel.org>,
	linux-mm <linux-mm@kvack.org>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	Konstantin Khlebnikov <khlebnikov@openvz.org>, riel@redhat.com,
	kosaki.motohiro@jp.fujitsu.com
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120308093514.GA28856@barrios>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Minchan,

Sorry, I forgot to say that I don't subscribe linux-mm and linux-kernel
mailing list.  So please Cc me.

IMHO, maybe we should re-think about how does user use mmap(2).  I
describe the cases I known in our product system.  They can be
categorized into two cases.  One is mmaped all data files into memory
and sometime it uses write(2) to append some data, and another uses
mmap(2)/munmap(2) and read(2)/write(2) to manipulate the files.  In the
second case,  the application wants to keep mmaped page into memory and
let file pages to be reclaimed firstly.  So, IMO, when application uses
mmap(2) to manipulate files, it is possible to imply that it wants keep
these mmaped pages into memory and do not be reclaimed.  At least these
pages do not be reclaimed early than file pages.  I think that maybe we
can recover that routine and provide a sysctl parameter to let the user
to set this ratio between mmaped pages and file pages.

Regards,
Zheng
