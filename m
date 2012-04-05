Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab2DETXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 15:23:50 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43611 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754128Ab2DETXt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 15:23:49 -0400
Message-ID: <4F7DF142.5050601@wwwdotorg.org>
Date: Thu, 05 Apr 2012 13:23:46 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: David Brown <davidb@codeaurora.org>
CC: devicetree-discuss@lists.ozlabs.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: Point-to-point bus in device tree
References: <20120405181509.GA28693@codeaurora.org>
In-Reply-To: <20120405181509.GA28693@codeaurora.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/05/2012 12:15 PM, David Brown wrote:
> Some MSM SoCs have a small serial-type "bus" that is used to
> communicate with the PMIC devices.  This interface is always
> point-to-point.  I'm doing a device-tree conversion of the driver that
> Ken Heitke posted last year <https://lkml.org/lkml/2011/2/17/503>.
> 
> A naive conversion to device tree, would result in something like
> this:
> 
> 	qcom,ssbi@500000 {
> 		compatible = "qcom,ssbi";
> 		reg = <0x500000 0x1000>;
> 		qcom,controller-type = "ssbi";
> 
> 		qcom,pmic8058@0 {
> 			reg = <0x0 0x01>;
> 			...
> 		}
> 	}
> 
> There would end up being an extraneous register for the device on the
> other end (there are no addresses), and there would need to be code in
> the ssbi driver to traverse this small tree to find these nodes.

Isn't that extra code simply:

of_platform_populate(pdev->dev.of_node, NULL, NULL, &pdev->dev);

That seems like pretty low overhead.
