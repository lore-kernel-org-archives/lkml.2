Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755100Ab2FNABn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 20:01:43 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:28837 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754859Ab2FNABm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 20:01:42 -0400
X-AuditID: cbfee61b-b7fcc6d000003a7a-4b-4fd929e4fe21
From: Sangbeom Kim <sbkim73@samsung.com>
To: "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, sbkim01@gmail.com
References: <042301cd493e$8d95d7e0$a8c187a0$@com>
 <20120613174620.GD7804@opensource.wolfsonmicro.com>
In-reply-to: <20120613174620.GD7804@opensource.wolfsonmicro.com>
Subject: RE: [PATCH 5/5] regulator: Support AP watchdog reset operation for
 s5m8767a
Date: Thu, 14 Jun 2012 09:01:39 +0900
Message-id: <04ad01cd49c0$df565d20$9e031760$@com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1JjHMqiACEO2FHTSaGq+PpzOk8qQAMID9w
Content-language: ko
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrNLMWRmVeSWpSXmKPExsVy+t9jAd0nmjf9DQ7t07K4vGsOmwOjx+dN
	cgGMUVw2Kak5mWWpRfp2CVwZU++vZSp4zFMxY9Zr9gbGpVxdjJwcEgImEmf6drND2GISF+6t
	Z+ti5OIQEljEKLH2z2EWCGcuk8Tx6XdZQarYBDQkVu5+C1TFwSEiYCbx8yAPSJhZIEvi6fTj
	YCVCAukSG/7tYQOxOQUcJK4/W8wMYgsLhEn8uv2ZEaSVRUBV4kunCEiYV8BQ4nLfCyYIW1Di
	x+R7LBAjtSTW7zzOBGHLS2xe85YZpFVCQF3i0V9dkLCIgJHEkc17WCFKRCT2vXjHOIFRaBaS
	SbOQTJqFZNIsJC0LGFlWMYqmFiQXFCel5xrpFSfmFpfmpesl5+duYgQH8TPpHYyrGiwOMQpw
	MCrx8F5QuekvxJpYVlyZe4hRgoNZSYT3mQJQiDclsbIqtSg/vqg0J7X4EKM0B4uSOG+T9QV/
	YJgklqRmp6YWpBbBZJk4OKUaGPulm9Z+qy1ef+fAtrokN8Ynje0MeXVdnXtUb9+3jNxbJ2Hz
	Tn/voaMta3bydjx21feYLBqVsTStxrxc7tfluWsPhsd5PN7ONHt62NbnN11kJBc/3dhsOzGh
	cYJz7bm1lXKM832as/r8Ve7cXVCYyTF7c/XEI/ssiuWK1Q9Wz77QGx8hKFcirsRSnJFoqMVc
	VJwIALGTEipeAgAA
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,
I'm sorry for insufficient explanation.
Basically, PMIC can't know status of ap reset.
Problem can be happened like below.

- AP Bootable lowest arm voltage: 0.9v
- AP arm voltage table for DVFS: 0.8v, 0.9v, 1.0v
- During AP works on 0.8v, watchdog reset is asserted
- AP can't boot, because vdd arm is still 0.8v

Solution
- Basic concept: After ap watchdog reset, GPIO configuration is changed by default value
- S5M8767A has function of voltage control with gpio (8 levels with 3 gpios)
- Set bootable voltage on level 0 -> can work with default gpio configuration
- In the probing, Change voltage control level from level 0 to level 1
- Execute normal dvfs operation on level 1
- After watchdog reset, ap gpio is set by default value
- PMIC operation mode is changed by ap reset (level1 -> level0)
- AP can execute normal boot

If you have any question, email me again.
Thanks,
Sangbeom.

> -----Original Message-----
> From: Mark Brown [mailto:broonie@opensource.wolfsonmicro.com]
> Sent: Thursday, June 14, 2012 2:46 AM
> To: Sangbeom Kim
> Cc: 'Liam Girdwood'; linux-kernel@vger.kernel.org; sameo@linux.intel.com; sbkim01@gmail.com
> Subject: Re: [PATCH 5/5] regulator: Support AP watchdog reset operation for s5m8767a
> 
> On Wed, Jun 13, 2012 at 05:28:47PM +0900, Sangbeom Kim wrote:
> > After AP watchdog reset, S5M8767A should be reset too.
> > If AP is set on lowest voltage, AP can't execute boot sequence.
> > This patch support watchdog reset of s5m8767.
> 
> It's really hard to see how this patch addresses the issue above - could you explain in more
> detail, please?

