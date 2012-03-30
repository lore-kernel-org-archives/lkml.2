Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934472Ab2C3Pym (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 11:54:42 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40230 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752195Ab2C3Pyd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 11:54:33 -0400
Message-ID: <4F75D734.3090109@wwwdotorg.org>
Date: Fri, 30 Mar 2012 09:54:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alok Chauhan <alokc@nvidia.com>
CC: khali@linux-fr.org, ben-linux@fluff.org, w.sang@pengutronix.de,
        swarren@nvidia.com, olof@lixom.net, bones@secretlab.ca,
        omaplinuxkernel@gmail.com, ccross@android.com, ldewangan@nvidia.com,
        linux-tegra@vger.kernel.org, linux-i2c@vger.kernel.org,
        dgreid@chromium.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: tegra: Add delay before reset the controller
References: <1333109179-12445-1-git-send-email-alokc@nvidia.com>
In-Reply-To: <1333109179-12445-1-git-send-email-alokc@nvidia.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2012 06:06 AM, Alok Chauhan wrote:
> In NACK error condition, I2C controller violates
> clock-to-data setup time before stop. In Software,
> because of this reset of controller is happening
> before I2C controller could complete STOP condition.

I'm not quite sure this description is correct. Surely what's happening
is simply that the controller raises the NACK interrupt as soon as it
detects a NACK condition. Then, the controller generates the STOP
condition on the bus correctly. The issue is that if software resets the
controller as soon as the NACK interrupt is raised, this will happen
before the controller has completely delivered the STOP condition onto
the bus, so we need to pause and wait for that?

I think the commit description and comment in the code should be
reworded to describe what I wrote above, assuming it's accurate.

Is there really no idle bit we can poll in the I2C controller to
determine when the STOP has completed, rather than just delaying a
"hard-coded" time? Can I2C SCL clock-stretching affect the amount of
time that must be delayed?
