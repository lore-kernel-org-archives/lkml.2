Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754114Ab0CWUBY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Mar 2010 16:01:24 -0400
Received: from 2605ds1-ynoe.0.fullrate.dk ([90.184.12.24]:41563 "EHLO
	shrek.krogh.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753894Ab0CWUBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Mar 2010 16:01:23 -0400
X-Greylist: delayed 568 seconds by postgrey-1.27 at vger.kernel.org; Tue, 23 Mar 2010 16:01:22 EDT
Message-ID: <4BA91BD2.2010700@krogh.cc>
Date: Tue, 23 Mar 2010 20:51:46 +0100
From: Jesper Krogh <jesper@krogh.cc>
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Ben Gamari <bgamari.foss@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Poor interactive performance with I/O loads with fsync()ing
References: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
In-Reply-To: <4b9fa440.12135e0a.7fc8.ffffe745@mx.google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ben Gamari wrote:
> Hey all,
> 
> Recently I started using the Xapian-based notmuch mail client for everyday
> use.  One of the things I was quite surprised by after the switch was the
> incredible hit in interactive performance that is observed during database
> updates. Things are particularly bad during runs of 'notmuch new,' which scans
> the file system looking for new messages and adds them to the database.
> Specifically, the worst of the performance hit appears to occur when the
> database is being updated.

I would suggest that you include a 2.6.31 kernel in your testing. I have
seen something that seems like "huge" stalls in 2.6.32 but I havent been
able to "dig into it" to find more.

In 2.6.32 I have seen IO-wait numbers around 80% on a 16 core machine
with 128GB of memory and load-numbers over 120 under workloads that
didn't make 2.6.31 sweat at all.

Filesystems are a mixture of ext3 and ext4 (so it could be the barriers)?

-- 
Jesper
