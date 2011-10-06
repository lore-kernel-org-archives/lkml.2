Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab1JFBl7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 21:41:59 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:52416 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751906Ab1JFBl6 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 21:41:58 -0400
From: Philip Rakity <prakity@marvell.com>
To: Liam Girdwood <lrg@ti.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Date: Wed, 5 Oct 2011 18:39:56 -0700
Subject: Re: [PATCH 1/2] regulator: Fix some bitrot in the machine driver
 documentation
Thread-Topic: [PATCH 1/2] regulator: Fix some bitrot in the machine driver
 documentation
Thread-Index: AcyDyNqmkMEv+lB6SV2aoyqcBhd9qA==
Message-ID: <94C474E6-A373-476B-935A-E675A5F57AED@marvell.com>
References: <1315503693-3785-1-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1315503693-3785-1-git-send-email-broonie@opensource.wolfsonmicro.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Resend

Did not make it yet into linux next.


On Sep 8, 2011, at 10:41 AM, Mark Brown wrote:

> The documentation for the machine driver was rather badly bitrotted,
> using pointers to struct device rather than dev_name() to hook up the
> consumers. Update to use dev_name().
> 
> Reported-by: Philip Rakity <prakity@marvell.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> Documentation/power/regulator/machine.txt |    8 ++++----
> 1 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.txt
> index b42419b..311c61f 100644
> --- a/Documentation/power/regulator/machine.txt
> +++ b/Documentation/power/regulator/machine.txt
> @@ -16,7 +16,7 @@ initialisation code by creating a struct regulator_consumer_supply for
> each regulator.
> 
> struct regulator_consumer_supply {
> -	struct device *dev;	/* consumer */
> +	const char *dev_name;	/* consumer dev_name() */
> 	const char *supply;	/* consumer supply - e.g. "vcc" */
> };
> 
> @@ -24,13 +24,13 @@ e.g. for the machine above
> 
> static struct regulator_consumer_supply regulator1_consumers[] = {
> {
> -	.dev	= &platform_consumerB_device.dev,
> -	.supply	= "Vcc",
> +	.dev_name	= "dev_name(consumer B)",
> +	.supply		= "Vcc",
> },};
> 
> static struct regulator_consumer_supply regulator2_consumers[] = {
> {
> -	.dev	= &platform_consumerA_device.dev,
> +	.dev	= "dev_name(consumer A"),
> 	.supply	= "Vcc",
> },};
> 
> -- 
> 1.7.5.4
> 

