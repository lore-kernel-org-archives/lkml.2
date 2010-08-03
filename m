Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755932Ab0HCKMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 06:12:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:36813 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755758Ab0HCKL7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 06:11:59 -0400
Date: Tue, 3 Aug 2010 12:11:57 +0200
From: Matthias Hopf <mhopf@suse.de>
To: Zhang Rui <rui.zhang@intel.com>, Len Brown <lenb@kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Julia Lawall <julia@diku.dk>, Oliver Neukum <oneukum@suse.de>
Cc: linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / PM: Traverse video_device_list for backlight
	restoration
Message-ID: <20100803101157.GA29721@suse.de>
Mail-Followup-To: Zhang Rui <rui.zhang@intel.com>,
	Len Brown <lenb@kernel.org>, Matthew Garrett <mjg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Julia Lawall <julia@diku.dk>, Oliver Neukum <oneukum@suse.de>,
	linux-acpi@vger.kernel.org, linux-pm@lists.linux-foundation.org,
	linux-kernel@vger.kernel.org
References: <20100803100505.GA26948@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100803100505.GA26948@suse.de>
Organization: SUSE LINUX Products GmbH, =?iso-8859-1?Q?G?=
	=?iso-8859-1?Q?F=3A_Markus_Rex=2C_HRB_16746_=28AG_N=FCrnberg=29?=
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A bit of background about this patch:


acpi_video_bus_get_devices() explicitly calls acpi_video_device_enumerate()
before acpi_video_bus_get_one_device(), which does acpi_video_device_bind().

In _enumerate(), active_list[] is created, with .bind_info explicitly set to
NULL, while the related .bind_info entry in video_device_list is set to the
acpi_video_device ptr in _bind().

The .bind_info is later used in acpi_video_resume() to re-set the backlight
- but it's only evaluated on the active_list[], on which all .bind_info are
NULL by construction.  This results in backlight not being restored, if the
BIOS doesn't do this by itself already.


The patch resolves this by replacing the active_list[] traversal by a
video_device_list traversal, but due to the nature of the issue I'm unsure
whether the original issue isn't of more principal quality.  I don't understand
why the list is (partially) transformed into an array in the first place,
especially as both the array *and* the list are used in the code...


Thanks

Matthias

-- 
Matthias Hopf <mhopf@suse.de>      __        __   __
Maxfeldstr. 5 / 90409 Nuernberg   (_   | |  (_   |__          mat@mshopf.de
Phone +49-911-74053-715           __)  |_|  __)  |__  R & D   www.mshopf.de
