Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755601Ab2DESPP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 14:15:15 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49551 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754043Ab2DESPN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 14:15:13 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6670"; a="179247927"
Date: Thu, 5 Apr 2012 11:15:09 -0700
From: David Brown <davidb@codeaurora.org>
To: devicetree-discuss@lists.ozlabs.org
Cc: linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Point-to-point bus in device tree
Message-ID: <20120405181509.GA28693@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some MSM SoCs have a small serial-type "bus" that is used to
communicate with the PMIC devices.  This interface is always
point-to-point.  I'm doing a device-tree conversion of the driver that
Ken Heitke posted last year <https://lkml.org/lkml/2011/2/17/503>.

A naive conversion to device tree, would result in something like
this:

	qcom,ssbi@500000 {
		compatible = "qcom,ssbi";
		reg = <0x500000 0x1000>;
		qcom,controller-type = "ssbi";

		qcom,pmic8058@0 {
			reg = <0x0 0x01>;
			...
		}
	}

There would end up being an extraneous register for the device on the
other end (there are no addresses), and there would need to be code in
the ssbi driver to traverse this small tree to find these nodes.

Another approach would be to make the pmic driver the actual device,
and just have it use the ssbi code as a library.  Something like:

	qcom,pmic8058@500000 {
		compatible = "qcom,pmic8058";
		reg = <0x500000 0x1000>;
		qcom,ssbi-type = "ssbi";
		...
	}

This is a lot cleaner, takes less code, but doesn't technically
represent how the hardware is really structured.

Does anyone have strong (or weak) feelings about this?

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
