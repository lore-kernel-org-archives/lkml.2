Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab0JUQyz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Oct 2010 12:54:55 -0400
Received: from silver.sucs.swan.ac.uk ([137.44.10.1]:56548 "EHLO
	silver.sucs.swan.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752340Ab0JUQyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Oct 2010 12:54:53 -0400
Date: Thu, 21 Oct 2010 17:54:20 +0100
From: Sitsofe Wheeler <sitsofe@yahoo.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
        Matthew Garrett <mjg59@srcf.ucam.org>, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, David Zeuthen <davidz@redhat.com>,
        Richard Hughes <richard@hughsie.com>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ACPI / Battery: Return -ENODATA for unknown values in
	get_property()
Message-ID: <20101021165420.GA8718@sucs.org>
References: <20101016141321.GA11054@sucs.org> <20101017131016.GB13015@khazad-dum.debian.net> <20101017145025.GA32599@sucs.org> <201010172032.43206.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010172032.43206.rjw@sisk.pl>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 08:32:42PM +0200, Rafael J. Wysocki wrote:
> 
> Still, if user space has problems with failing reads from the sysfs
> attributes, it may be better to simply put -1 in there.  Patch is
> appended, please test.

This patch does what it says on the tin (returns -1 in sysfs on my EeePC
900). So:

Tested-by: Sitsofe Wheeler <sitsofe@yahoo.com>

It's a shame the previous changes didn't work as they stopped a buggy
upower using the -1 value (and producing a nonsense rate like 8.4e-06)
but it's not clear which part of the stack can't handle -ENODATA
perhaps it is another part of the kernel?

Richard, any chance of upower being changed to test for -1 before doing
doing anything with current_now (
http://cgit.freedesktop.org/DeviceKit/upower/tree/src/linux/up-device-supply.c?id=5387183d53c16a987a0737c1bdec1b62edf3daa6#n561)?
I guess there are a whole bunch of other attributes that could
theoretically be -1 and shouldn't be used if they return it...

-- 
Sitsofe | http://sucs.org/~sits/
