Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755949Ab1HRMwm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Aug 2011 08:52:42 -0400
Received: from tango.0pointer.de ([85.214.72.216]:51385 "EHLO
	tango.0pointer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216Ab1HRMwl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Aug 2011 08:52:41 -0400
X-Greylist: delayed 465 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Aug 2011 08:52:41 EDT
Date: Thu, 18 Aug 2011 14:43:53 +0200
From: Lennart Poettering <mzxreary@0pointer.de>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-man@vger.kernel.org,
        roland@hack.frob.com, torvalds@linux-foundation.org
Subject: Re: +
 	prctl-add-pr_setget_child_reaper-to-allow-simple-process-supervision
 	.patch added to -mm tree
Message-ID: <20110818124353.GA2839@tango.0pointer.de>
References: <201108162011.p7GKBcY0023134@imap1.linux-foundation.org>
 <20110817115543.GA8745@redhat.com>
 <CAPXgP12rYf2HmmsJAuJw=nrtcjTRR1WzDhLNM47eKhKA1UTfJQ@mail.gmail.com>
 <20110817134516.GA14136@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110817134516.GA14136@redhat.com>
Organization: Red Hat, Inc.
X-Campaign-1: ()  ASCII Ribbon Campaign
X-Campaign-2: /  Against HTML Email & vCards - Against Microsoft Attachments
User-Agent: Leviathan/19.8.0 [zh] (Cray 3; I; Solaris 4.711; Console)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17.08.11 15:45, Oleg Nesterov (oleg@redhat.com) wrote:

> You should mark the whole process as sub-reaper, not a single thread
> which does prctl(). The parent/child relationship is process-wide.

Hmm, how would we implement this best? Would it be sufficient to follow
group_leader pointer to set/get the flag, and to follow real_parent
instead of parent when looking for the reaper task (i.e. the one with
the flag set)?

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
