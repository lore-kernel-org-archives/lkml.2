Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab2DCUJX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:09:23 -0400
Received: from mga09.intel.com ([134.134.136.24]:59167 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753286Ab2DCUJV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:09:21 -0400
MIME-Version: 1.0
In-Reply-To: <4F7B52D8.101@fb.com>
References: <4F7B52D8.101@fb.com>
Date: Tue, 3 Apr 2012 13:09:20 -0700
Message-ID: <CABE8wwsdA7cXG=3rFYxa6v9g1jYpNg8Mq3+JyboRyTcBSvJVNA@mail.gmail.com>
Subject: Re: [PATCH 1/2] 8250_pci: Replace commits 448ac154 and e86ff4a
From: "Williams, Dan J" <dan.j.williams@intel.com>
To: sudhakar <sudhakar@fb.com>
Cc: linux-serial@vger.kernel.org, alan@linux.intel.com,
        gregkh@linuxfoundation.org, nhan.h.mai@intel.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 3, 2012 at 12:43 PM, sudhakar <sudhakar@fb.com> wrote:
>
> From: Sudhakar Mamillapalli <sudhakar@fb.com>
>
>
> The following commits don't completely fix the KT serial missing
> interrupt problems.  So they have been replaced instead by
> enabling serial backup timer.  The iir-once + msi tried approach tried
> to enforce one read of the iir per THRE event, but its defeated by any
> other event occurring at the wrong time, particularly MSR events.
>
> 448ac15 serial/8250_pci: setup-quirk workaround for the kt serial controller
> e86ff4a serial/8250_pci: init-quirk msi support for kt serial controller
>
> Signed-off-by: Sudhakar Mamillapalli <sudhakar@fb.com>
> Acked-by: Dan Williams <dan.j.williams@intel.com>
> Acked-by: Nhan H Mai <nhan.h.mai@intel.com>

Just a note that this should also be tagged for 3.3-stable since the
msi setup hack in e86ff4a breaks suspend/resume like this:

[  365.250523] sysfs: cannot create duplicate filename
'/devices/pci0000:00/0000:00:16.3/msi_irqs'
