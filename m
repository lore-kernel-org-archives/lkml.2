Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754195Ab2KZG2G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 01:28:06 -0500
Received: from mga01.intel.com ([192.55.52.88]:13538 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751893Ab2KZG2C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 01:28:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,318,1352102400"; 
   d="scan'208";a="252421272"
Date: Mon, 26 Nov 2012 08:31:18 +0200
From: Mika Westerberg <mika.westerberg@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, "Svahn, Kai" <kai.svahn@intel.com>,
        Huang Ying <ying.huang@intel.com>,
        "Lan, Tianyu" <tianyu.lan@intel.com>, "Zheng, Lv" <lv.zheng@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 0/2] ACPI / platform: Put devices enumerated via ACPI
 into D0 before probing drivers
Message-ID: <20121126063118.GF3867@intel.com>
References: <1672179.qgDUs0YdYu@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1672179.qgDUs0YdYu@vostro.rjw.lan>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 25, 2012 at 03:54:14PM +0100, Rafael J. Wysocki wrote:
> The following two patches are meant to work around a problem where some
> devices may be in the ACPI D3cold power state (power off) before their
> drivers' .probe() routines are called, but those routines assume devices
> to be operational.  They also allow ACPI PM to be used going forward with
> the devices in question.

We have such machines here. I've tested the series on one of them and it
solves the problem - drivers can now access device registers right from the
start.

> [1/2] - Allow ACPI PM attach/detach routines to change device power states.
> [2/2] - Call the ACPI PM attach/detach routines in the platform probe and
>         remove/shutdown callbacks (and change power states of devices as
>         necessary).

Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Tested-by: Mika Westerberg <mika.westerberg@linux.intel.com>
