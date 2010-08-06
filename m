Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933945Ab0HFHT0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 03:19:26 -0400
Received: from smtp-out.google.com ([216.239.44.51]:8385 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933221Ab0HFHTY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 03:19:24 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:from:date:message-id:
	subject:to:cc:content-type:x-system-of-record;
	b=j/VbvtlYX6/ya4McDuw8ET0rBuXwIWLk79/oUkUcgJY3t47Nb8AoqfeLcxM+reix2
	V4956yU6F8MAKMKSNybbg==
MIME-Version: 1.0
In-Reply-To: <AANLkTik9AMf1pmsguB843UC9Qq6KxBcWiN_qyeiDPp1O@mail.gmail.com>
References: <1280969004-29530-1-git-send-email-mrubin@google.com> 
	<1280969004-29530-3-git-send-email-mrubin@google.com> <20100805132433.d1d7927b.akpm@linux-foundation.org> 
	<AANLkTik9AMf1pmsguB843UC9Qq6KxBcWiN_qyeiDPp1O@mail.gmail.com>
From: Michael Rubin <mrubin@google.com>
Date: Fri, 6 Aug 2010 00:19:00 -0700
Message-ID: <AANLkTikFM9J9On85N9k6hKPfUz0w4LxZai6xfsHQz+-D@mail.gmail.com>
Subject: Re: [PATCH 2/2] writeback: Adding pages_dirtied and 
	pages_entered_writeback
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, jack@suse.cz, david@fromorbit.com, hch@lst.de,
        axboe@kernel.dk
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 5, 2010 at 1:24 PM, Andrew Morton <akpm@linux-foundation.org> wrote:
> Wait.  These counters appear in /proc/vmstat.  So why create standalone
> /proc/sys/vm files as well?

Andrew I was thinking about this today. And I think there is a case
for keeping the proc files.
Christoph was the one who pointed out to me that is their proper home
and I think he's right. Most if not all the tunables for writeback are
there. When one is trying to find the state of the system's writeback
activity that's the directory. Only having these variables in
/proc/vmstat to me feels like a way to make sure that users who would
need them won't find them unless they are reading source. And these
are folks who aren't reading source.

/proc/vmstat _does_ look like a good place to put the thresholds as it
already has similar values as the thresholds suck as
kswapd_low_wmark_hit_quickly.

mrubin
