Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759196Ab2J3QP3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 12:15:29 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49184 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab2J3QP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 12:15:27 -0400
MIME-Version: 1.0
In-Reply-To: <CACVXFVO5-UPNrWsySzDE5AfOv1TMqbyitQX9ViidSJPM36fqAQ@mail.gmail.com>
References: <CACVXFVOPDu6wVgPmvtTkokn7VV41x3XVvL4g_E0pz0mikUbvUg@mail.gmail.com>
	<Pine.LNX.4.44L0.1210301112270.1363-100000@iolanthe.rowland.org>
	<CACVXFVO5-UPNrWsySzDE5AfOv1TMqbyitQX9ViidSJPM36fqAQ@mail.gmail.com>
Date: Wed, 31 Oct 2012 00:15:26 +0800
Message-ID: <CACVXFVP+QkzXg1v+x2juOe3X0bib8pCZXi=0VyvBOuTp6bxr4Q@mail.gmail.com>
Subject: Re: [PATCH v3 2/6] PM / Runtime: introduce pm_runtime_set[get]_memalloc_noio()
From: Ming Lei <ming.lei@canonical.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, Oliver Neukum <oneukum@suse.de>,
        Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Jens Axboe <axboe@kernel.dk>,
        "David S. Miller" <davem@davemloft.net>,
        Andrew Morton <akpm@linux-foundation.org>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 12:00 AM, Ming Lei <ming.lei@canonical.com> wrote:
>
> Looks the simplest approach is to handle the noio flag thing at the start and
> end of rpm_resume.

Sorry, that doesn't work, runtime_suspend need that too because memory
allocation with block I/O might deadlock when doing I/O on the same device.

Thanks,
--
Ming Lei
