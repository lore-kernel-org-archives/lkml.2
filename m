Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758783Ab1CaVUK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 17:20:10 -0400
Received: from mail132.messagelabs.com ([216.82.242.115]:46626 "EHLO
	mail132.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753668Ab1CaVUJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 17:20:09 -0400
X-VirusChecked: Checked
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-13.tower-132.messagelabs.com!1301606406!20897471!1
X-StarScan-Version: 6.2.9; banners=-,-,-
X-Originating-IP: [216.166.12.69]
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Grant Likely <grant.likely@secretlab.ca>
CC: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Thu, 31 Mar 2011 16:20:04 -0500
Subject: RE: gpio: pca953x: prevent freeing IRQ 0 on probe error
Thread-Topic: gpio: pca953x: prevent freeing IRQ 0 on probe error
Thread-Index: Acvv5QtmsVcSyTj1QDuYAQfp/6KW7wABEP8g
Message-ID: <0D753D10438DA54287A00B027084269764D1B0C9B0@AUSP01VMBX24.collaborationhost.net>
References: <201103251502.54348.hartleys@visionengravers.com>
 <20110331204833.GA32522@ponder.secretlab.ca>
In-Reply-To: <20110331204833.GA32522@ponder.secretlab.ca>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, March 31, 2011 1:49 PM, Grant Likely wrote:
> On Fri, Mar 25, 2011 at 03:02:54PM -0700, H Hartley Sweeten wrote:
>> If CONFIG_GPIO_PCA953X_IRQ is enabled and an error occurs in the probe
>> before pca953x_irq_setup() is called chip->client->irq will be 0 due to
>> the kmalloc.  pca953x_irq_teardown() will then try to free_irq(0, chip)
>> which will produce a:
>> 
>> 	WARN(1, "Trying to free already-free IRQ %d\n", irq);
>> 
>> Add an error path to prevent this.
>> 
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Grant Likely <grant.likely@secretlab.ca>
>
> Thanks for catching this Hartley.
>
> Ben also submitted a patch for this and I ended up looking at his patch 
> first, so that is what's applied.  :-)

Not a problem. Thanks!
Hartley