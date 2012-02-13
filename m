Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267Ab2BMJUW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 04:20:22 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:11543 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752529Ab2BMJUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 04:20:21 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 13 Feb 2012 01:20:20 -0800
Message-ID: <4F38D55A.5020208@nvidia.com>
Date: Mon, 13 Feb 2012 14:48:18 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Regulator enable/disable delay based on board design: How to handle?
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
We observed that some of the rail enable/disable settling time depends 
on the board design specially based on external capacitor connected on
rails.  This is observed mainly on VBUS regulator rail where difference 
on the capacitance value which is connected on rail makes the on/off
time to vary.
Currently none of regulator driver support such board related delay.
My question is:

- Should we add board delay as part of platform data for regulator and 
handle in regulator driver? Or,
- Push this delay parameter to respective client driver and let them to 
handle. Not a good idea as it is mainly related to rail on/off. Or,
- Should we add one more parameter in regulator_init_data as rail_delay 
and push this change to core driver of regulator i.e. if it is non-zero 
then take this value from this field otherwise take from <xxx>-regulator 
driver?


I can also work towards If there is any other good options and 
acceptable to linux community.

Thanks,
Laxman

