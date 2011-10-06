Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1JFBmr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 21:42:47 -0400
Received: from na3sys009aog124.obsmtp.com ([74.125.149.151]:57738 "EHLO
	na3sys009aog124.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755775Ab1JFBmq convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 21:42:46 -0400
From: Philip Rakity <prakity@marvell.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Liam Girdwood <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "patches@opensource.wolfsonmicro.com" 
	<patches@opensource.wolfsonmicro.com>
Date: Wed, 5 Oct 2011 18:40:18 -0700
Subject: Re: [PATCH 2/2] regulator: Clarify documentation for
 regulator-regulator supplies
Thread-Topic: [PATCH 2/2] regulator: Clarify documentation for
 regulator-regulator supplies
Thread-Index: AcyDyOgbTrZbk0DUSGOY+1kRMY0HNg==
Message-ID: <D885B58A-D78D-43DC-A91D-6E98A2C9E3B2@marvell.com>
References: <1315503693-3785-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <1315503693-3785-2-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1315503693-3785-2-git-send-email-broonie@opensource.wolfsonmicro.com>
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


Resend.

Did not yet make it into linux next.

On Sep 8, 2011, at 10:41 AM, Mark Brown wrote:

> The mechanism used for connecting regulators together when one regulator
> supplies another wasn't clear as the names being used weren't really tied
> together well.
> 
> Reported-by: Philip Rakity <prakity@marvell.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> ---
> Documentation/power/regulator/machine.txt |   11 +++++++++--
> 1 files changed, 9 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/power/regulator/machine.txt b/Documentation/power/regulator/machine.txt
> index 311c61f..ce63af0 100644
> --- a/Documentation/power/regulator/machine.txt
> +++ b/Documentation/power/regulator/machine.txt
> @@ -43,6 +43,7 @@ to their supply regulator :-
> 
> static struct regulator_init_data regulator1_data = {
> 	.constraints = {
> +		.name = "Regulator-1",
> 		.min_uV = 3300000,
> 		.max_uV = 3300000,
> 		.valid_modes_mask = REGULATOR_MODE_NORMAL,
> @@ -51,13 +52,19 @@ static struct regulator_init_data regulator1_data = {
> 	.consumer_supplies = regulator1_consumers,
> };
> 
> +The name field should be set to something that is usefully descriptive
> +for the board for configuration of supplies for other regulators and
> +for use in logging and other diagnostic output.  Normally the name
> +used for the supply rail in the schematic is a good choice.  If no
> +name is provided then the subsystem will choose one.
> +
> Regulator-1 supplies power to Regulator-2. This relationship must be registered
> with the core so that Regulator-1 is also enabled when Consumer A enables its
> supply (Regulator-2). The supply regulator is set by the supply_regulator
> -field below:-
> +field below and co:-
> 
> static struct regulator_init_data regulator2_data = {
> -	.supply_regulator = "regulator_name",
> +	.supply_regulator = "Regulator-1",
> 	.constraints = {
> 		.min_uV = 1800000,
> 		.max_uV = 2000000,
> -- 
> 1.7.5.4
> 

