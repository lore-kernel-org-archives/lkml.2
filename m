Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712Ab2GZPPm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 11:15:42 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35631 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752349Ab2GZPPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 11:15:40 -0400
MIME-Version: 1.0
In-Reply-To: <20120725161539.GM11152@aftab.osrc.amd.com>
References: <1343149213-10160-1-git-send-email-ming.lei@canonical.com>
	<1343149213-10160-10-git-send-email-ming.lei@canonical.com>
	<20120725161539.GM11152@aftab.osrc.amd.com>
Date: Thu, 26 Jul 2012 23:15:37 +0800
Message-ID: <CACVXFVMKzYbELKYsQSV55kqCTTVtez8SDKSrwJn55iszmjXrOw@mail.gmail.com>
Subject: Re: [RFC PATCH 09/13] driver core: firmware loader: store firmware
 name into devres list
From: Ming Lei <ming.lei@canonical.com>
To: Borislav Petkov <bp@amd64.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 12:15 AM, Borislav Petkov <bp@amd64.org> wrote:
> On Wed, Jul 25, 2012 at 01:00:09AM +0800, Ming Lei wrote:
>> This patch will store firmware name into devres list of the device
>> which is requesting firmware loading, so that we can implement
>> auto cache firmware for devices in need.
>
> Stupid question: does this mean that once the firmware name is in the
> devres list, it is being cached automatically and device drivers which
> don't want that need to explicitly uncache it?

Both the auto cache and auto uncache actions are not triggered by device
driver, and will be triggered by some system state, for example, in 13/13,
you will find the cache is done before system suspend and the uncache is
done after system resume.

If device drivers want to cache its firmware explicitly, they have to uncache
it explicitly too, see cache_firmware/uncache_firmware in 7/13.

Thanks
--
Ming Lei
