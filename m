Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756651Ab2JQLH3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:07:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50432 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751132Ab2JQLH1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:07:27 -0400
MIME-Version: 1.0
In-Reply-To: <6431373.tJcdR3m2Df@vostro.rjw.lan>
References: <1350403183-12650-1-git-send-email-ming.lei@canonical.com>
	<1350403183-12650-3-git-send-email-ming.lei@canonical.com>
	<6431373.tJcdR3m2Df@vostro.rjw.lan>
Date: Wed, 17 Oct 2012 19:07:25 +0800
Message-ID: <CACVXFVP-JerxiTU9Kr9Lrwe2XkKBU=EsZJUcEiPVCQWw6iiw2Q@mail.gmail.com>
Subject: Re: [RFC PATCH v1 2/3] PM / Runtime: force memory allocation with no
 I/O during runtime_resume callbcack
From: Ming Lei <ming.lei@canonical.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Oliver Neukum <oneukum@suse.de>, Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 17, 2012 at 1:43 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
>
> This appears to be a bit too heavy handed.  First of all, it seems to affect
> all memory allocations going in parallel with the resume callback.  Second,

No, the flag is per task, only memory allocation inside resume callback
is effected.

> it affects all resume callbacks, not only those where the problem really

We can do it only on block device, block device's ancestor and network
devices(iSCSI case), but that may introduce policy into PM core or add
one flag of memalloc_noio_resume into 'dev_pm_info', could you agree
on it?


Thanks,
--
Ming Lei
