Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759034Ab1LPMbn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 07:31:43 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:31410 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756212Ab1LPMbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 07:31:36 -0500
Date: Fri, 16 Dec 2011 15:31:26 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: NeilBrown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org
Subject: leds: leds-tca6507: off by one in choose_times()
Message-ID: <20111216123125.GA2721@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4EEB3A23.0070,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Neil,

Smatch complains about 7a9244d89523 "leds: add driver for TCA6507 LED
controller"

drivers/leds/leds-tca6507.c +185 choose_times(16)
	error: buffer overflow 'time_codes' 16 <= 16

   184          for (c1 = 1; c1 <= TIMECODES; c1++) {
   185                  int t = time_codes[c1];
                                ^^^^^^^^^^^^^
We're reading 1 past the end of the array here.

   186                  if (t*2 < tmin)
   187                          continue;

regards,
dan carpenter
