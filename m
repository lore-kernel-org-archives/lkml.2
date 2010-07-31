Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab0GaA71 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Jul 2010 20:59:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52807 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751102Ab0GaA70 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Jul 2010 20:59:26 -0400
Message-ID: <4C537514.9090109@zytor.com>
Date: Fri, 30 Jul 2010 17:57:56 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Fenghua Yu <fenghua.yu@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <lenb@kernel.org>,
        Guenter Roeck <guenter.roeck@ericsson.com>,
        Chen Gong <gong.chen@linux.intel.com>,
        Jean Delvare <khali@linux-fr.org>, Huaxu Wan <huaxu.wan@intel.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        lm-sensors <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH V3 2/5] Package Level Thermal Control and Power Limit
 Notification: pkgtemp hwmon driver
References: <1280448826-12004-1-git-send-email-fenghua.yu@intel.com> <1280448826-12004-3-git-send-email-fenghua.yu@intel.com>
In-Reply-To: <1280448826-12004-3-git-send-email-fenghua.yu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/29/2010 05:13 PM, Fenghua Yu wrote:
> +
> +enum { SHOW_TEMP, SHOW_TJMAX, SHOW_TTARGET, SHOW_LABEL, SHOW_NAME } SHOW;
> +

This conflicts with an equally poorly named global variable in
drivers/hwmon/via-cputemp.c, and the conflict is causing a build failure.

I think both these drivers have the same bug: a missing "typedef" before
the enum keyword, as present in coretemp.c.  Of course, one can question
if it should be given a typename at all since in none of these drivers
they are actually referenced by type, and instead the enumeration is
just used as a source of constants, which can perfectly well be handled
with an unnamed enum:

enum { SHOW_TEMP, SHOW_TJMAX, SHOW_TTARGET, SHOW_LABEL, SHOW_NAME };

	-hpa
