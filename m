Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756479Ab1CGVol (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:44:41 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:5957 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754736Ab1CGVok (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:44:40 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AsIGAG/gdE2rR7H+/2dsb2JhbACmVQJ0okCcAoViBIUchxSDSYIbgxQ
X-IronPort-AV: E=Sophos;i="4.62,279,1297036800"; 
   d="scan'208";a="272092789"
User-Agent: Microsoft-Entourage/12.28.0.101117
Date: Mon, 07 Mar 2011 13:44:43 -0800
Subject: Re: [PATCH] hwmon: (pmbus) More stringent checking of VOUT_MODE
 register
From: Greg Schnorr <gschnorr@cisco.com>
To: Guenter Roeck <guenter.roeck@ericsson.com>,
        Jean Delvare <khali@linux-fr.org>
CC: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>, <lm-sensors@lm-sensors.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Message-ID: <C99A91CB.5A89D%gschnorr@cisco.com>
Thread-Topic: [PATCH] hwmon: (pmbus) More stringent checking of VOUT_MODE
 register
Thread-Index: AcvdEN5c15Vyi7Qi6EOW+Iz7WDM3Qw==
In-Reply-To: <1299043940-22798-1-git-send-email-guenter.roeck@ericsson.com>
Mime-version: 1.0
Content-type: text/plain;
	charset="US-ASCII"
Content-transfer-encoding: 7bit
X-OriginalArrivalTime: 07 Mar 2011 21:44:37.0442 (UTC) FILETIME=[DB0C4220:01CBDD10]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good, tested and works on one such VOUT_MODE poor design...

On 3/1/11 9:32 PM, "Guenter Roeck" <guenter.roeck@ericsson.com> wrote:

> Some PMBus chips do not support the VOUT_MODE register. To make matters worse,
> such chips may not return an error when reading the register either, but
> instead
> return 0xff.
> 
> Check if the register exists using pmbus_check_byte_register() before reading
> its value. In addition, validate the returned value and ignore it if it is
> 0xff
> (which is invalid).
> 
> Reported-by: Greg Schnorr <gschnorr@cisco.com>
> Signed-off-by: Guenter Roeck <guenter.roeck@ericsson.com>
Acked-by: Greg Schnorr <gschnorr@cisco.com>

