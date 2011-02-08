Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755758Ab1BHUfg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 15:35:36 -0500
Received: from mga09.intel.com ([134.134.136.24]:19965 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754851Ab1BHUff (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 15:35:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,443,1291622400"; 
   d="scan'208";a="705483475"
Message-ID: <58187.10.23.16.85.1297197335.squirrel@linux.intel.com>
In-Reply-To: <20110208200444.GA23329@infradead.org>
References: <james_p_freyensee@linux.intel.com>
    <1297193697-5417-1-git-send-email-james_p_freyensee@linux.intel.com>
    <1297193697-5417-2-git-send-email-james_p_freyensee@linux.intel.com>
    <20110208193857.GA8839@infradead.org>
    <45773.10.23.16.85.1297194256.squirrel@linux.intel.com>
    <20110208200444.GA23329@infradead.org>
Date: Tue, 8 Feb 2011 12:35:35 -0800 (PST)
Subject: Re: [PATCH 01/12] export kernel call get_task_comm()
From: james_p_freyensee@linux.intel.com
To: "Christoph Hellwig" <hch@infradead.org>
Cc: james_p_freyensee@linux.intel.com, "Christoph Hellwig" <hch@infradead.org>,
        gregkh@suse.de, linux-kernel@vger.kernel.org, suhail.ahmed@intel.com
User-Agent: SquirrelMail/1.4.8-5.el4.centos.8
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, Feb 08, 2011 at 11:44:16AM -0800,
> james_p_freyensee@linux.intel.com wrote:
>> That is originally what I did, but after talking with Greg KH, Arjan
>> vdv,
>> and Alan Cox I made this patch instead.
>
> Care to explain why exactly?
>
>

If I can jog my own memory as this was a while ago...

Well for starters, Arjan van de Ven first suggested it, and I trust his
judgement because of his Linux kernel experience.

But looking at the code, the kernel function get_task_comm() provides a
level of safety with a lock, so the global resource 'current' can be used
without someone else trying to use it at the same time.  And using this
function facilitates code reuse which is something Greg KH was trying to
point out to me at the time:

http://lists.meego.com/pipermail/meego-kernel/2010-October/000823.html

In fact, I remember finding existing, accepted drivers in the kernel that
wrote their own locks before accessing current (I quickly just now found
block/dfdb/drbd_main.c as an example), so Greg is making a valid point
about code reuse.  So not exporting get_task_comm() encourages code
locking re-write of every driver that wants to access 'current'.

In that email, Greg clearly reminded me my goal is to get my work into the
kernel.  Thus, I listened to their advice and made this patch.
