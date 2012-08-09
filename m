Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab2HIQRV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 12:17:21 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39360 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab2HIQRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 12:17:20 -0400
Message-ID: <5023E28D.1000208@wwwdotorg.org>
Date: Thu, 09 Aug 2012 10:17:17 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: core: Use list_voltage() to read single voltage
 regulators
References: <1344527111-29611-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1344527111-29611-1-git-send-email-broonie@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 09:45 AM, Mark Brown wrote:
> If the regulator doesn't supply a way of reading back the voltage but does
> provide a list_voltage() operation then use that with a selector of zero
> to read the voltage.

Ah, this makes sense. The only issue is:

static int add_regulator_attributes(struct regulator_dev *rdev)
...
	if ((ops->get_voltage && ops->get_voltage(rdev) >= 0) ||
	    (ops->get_voltage_sel && ops->get_voltage_sel(rdev) >= 0)) {
		status = device_create_file(dev, &dev_attr_microvolts);

so the microvolts file doesn't get created.

