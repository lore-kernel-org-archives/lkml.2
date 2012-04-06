Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757408Ab2DFPQN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 11:16:13 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:54066 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754728Ab2DFPQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 11:16:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6671"; a="179487948"
Date: Fri, 6 Apr 2012 08:16:10 -0700
From: David Brown <davidb@codeaurora.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: devicetree-discuss@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Point-to-point bus in device tree
Message-ID: <20120406151610.GA12888@codeaurora.org>
References: <20120405181509.GA28693@codeaurora.org>
 <4F7DF142.5050601@wwwdotorg.org>
 <20120405200829.GA29747@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120405200829.GA29747@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 05, 2012 at 01:08:29PM -0700, David Brown wrote:
> On Thu, Apr 05, 2012 at 01:23:46PM -0600, Stephen Warren wrote:
> > On 04/05/2012 12:15 PM, David Brown wrote:
> > > Some MSM SoCs have a small serial-type "bus" that is used to
> > > communicate with the PMIC devices.  This interface is always
> > > point-to-point.  I'm doing a device-tree conversion of the driver that
> > > Ken Heitke posted last year <https://lkml.org/lkml/2011/2/17/503>.
> > > 
> > > A naive conversion to device tree, would result in something like
> > > this:
> > > 
> > > 	qcom,ssbi@500000 {
> > > 		compatible = "qcom,ssbi";
> > > 		reg = <0x500000 0x1000>;
> > > 		qcom,controller-type = "ssbi";
> > > 
> > > 		qcom,pmic8058@0 {
> > > 			reg = <0x0 0x01>;
> > > 			...
> > > 		}
> > > 	}
> > > 
> > > There would end up being an extraneous register for the device on the
> > > other end (there are no addresses), and there would need to be code in
> > > the ssbi driver to traverse this small tree to find these nodes.
> > 
> > Isn't that extra code simply:
> > 
> > of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);
> > 
> > That seems like pretty low overhead.
> 
> True, but it still bothers me to have to have a bogus register.

Ok, not sure where I got that idea, but I don't appear to actually
need a register in the pmic8058 node for of_platform_populate to
create a platform device.  It only needs a compatible field.  So, it
look like that matches just what I need.

Thanks,
David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
