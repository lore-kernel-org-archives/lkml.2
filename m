Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754526Ab0G1X5X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 19:57:23 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:58953 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750730Ab0G1X5U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 19:57:20 -0400
Date: Wed, 28 Jul 2010 19:57:16 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, czoccolo@gmail.com
Subject: Re: [RFC PATCH] cfq-iosched: IOPS mode for group scheduling and new
 group_idle tunable
Message-ID: <20100728235716.GA12945@infradead.org>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <20100723140343.GA8478@fancy-poultry.org>
 <20100723141303.GB13104@redhat.com>
 <20100723145631.GA8844@fancy-poultry.org>
 <20100723183720.GD13104@redhat.com>
 <20100724080613.GA6554@fancy-poultry.org>
 <20100728202212.GD16314@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100728202212.GD16314@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 28, 2010 at 04:22:12PM -0400, Vivek Goyal wrote:
> I also did "time firefox &" testing to see how long firefox takes to
> launch when linus torture test is running and without patch it took
> around 20 seconds and with patch it took around 17 seconds. 
> 
> So to me above test results suggest that this patch does not worsen
> the performance. In fact it helps. (at least on ext3 file system.)
> 
> Not sure why are you seeing different results with XFS.

So why didn't you test it with XFS to verify his results?  We all know
that different filesystems have different I/O patters, and we have
a history of really nasty regressions in one filesystem by good meaning
changes to the I/O scheduler.

ext3 in fact is a particularly bad test case as it not only doesn't have
I/O barriers enabled, but also has particularly bad I/O patterns
compared to modern filesystems.

