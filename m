Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422758Ab2LGQ1h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 11:27:37 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44567 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1422660Ab2LGQ1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 11:27:36 -0500
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1212071023090.1565-100000@iolanthe.rowland.org>
References: <CACVXFVMOxQEJ-nrvGQ-PkevqKkLnXu+QjHgeswkbzFjqOVYCdQ@mail.gmail.com>
	<Pine.LNX.4.44L0.1212071023090.1565-100000@iolanthe.rowland.org>
Date: Sat, 8 Dec 2012 00:27:34 +0800
Message-ID: <CACVXFVPLTHZkveghRc+sp6Fid=Mft5FKW1Yk1Stmj+EEpZwYwQ@mail.gmail.com>
Subject: Re: Race condition between driver_probe_device and device_shutdown
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Wedson Almeida Filho <wedsonaf@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Linux PM List <linux-pm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 11:25 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 7 Dec 2012, Ming Lei wrote:
>> device_pm_lock() can prevent device_move() from being running.
>
> That wouldn't prevent problems during unbinding.  Wedson is right; the

Right.

> places that lock dev->parent must save a local copy of dev->parent.

One simple fix is to remove acquiring/releasing dev->parent lock
and get/put the parent reference, because holding the device lock only
may avoid the race between probe/remove and shutdown.

But __driver_attach and __device_release_driver need
save the local copy of dev->parent.

Thanks,
--
Ming Lei
