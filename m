Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757454Ab1DXB7t (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 21:59:49 -0400
Received: from imr4.ericy.com ([198.24.6.8]:39889 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757405Ab1DXB7r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 21:59:47 -0400
Date: Sat, 23 Apr 2011 18:58:53 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Jean Delvare <khali@linux-fr.org>
CC: Len Brown <len.brown@intel.com>, LM Sensors <lm-sensors@lm-sensors.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rene Herman <rene.herman@gmail.com>
Subject: Re: [lm-sensors] [PATCH] thermal: Drop CONFIG_THERMAL_HWMON
Message-ID: <20110424015853.GA8045@ericsson.com>
References: <20110423150703.78ba86db@endymion.delvare>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20110423150703.78ba86db@endymion.delvare>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 23, 2011 at 09:07:03AM -0400, Jean Delvare wrote:
> It's about time to revert 16d752397301b95abaa95cbaf9e785d221872311.
> Anybody running a kernel >= 2.6.40 would also be running a recent
> enough version of lm-sensors.
> 
> Signed-off-by: Jean Delvare <khali@linux-fr.org>
> Cc: Rene Herman <rene.herman@gmail.com>
> Cc: Len Brown <len.brown@intel.com>

Two other and less complex options:

- Add
	select THERMAL_HWMON if HWMON=y || HWMON=THERMAL
  to "menuconfig THERMAL", and keep THERMAL_HWMON as non-selectable bool
  [ I don't know what HWMON=THERMAL means, though ]
- Add
	select HWMON
  to "menuconfig THERMAL", and remove THERMAL_HWMON.

Guenter
