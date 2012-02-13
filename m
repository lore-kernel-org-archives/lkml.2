Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757448Ab2BMR75 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:59:57 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:5894 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755537Ab2BMR74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:59:56 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 13 Feb 2012 09:59:55 -0800
Message-ID: <4F394F28.70709@nvidia.com>
Date: Mon, 13 Feb 2012 23:28:00 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regulator enable/disable delay based on board design: How to
 handle?
References: <4F38D55A.5020208@nvidia.com> <20120213163711.GD3494@opensource.wolfsonmicro.com>
In-Reply-To: <20120213163711.GD3494@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 13 February 2012 10:07 PM, Mark Brown wrote:
> * PGP Signed by an unknown key
>
> On Mon, Feb 13, 2012 at 02:48:18PM +0530, Laxman Dewangan wrote:
>
>> We observed that some of the rail enable/disable settling time
>> depends on the board design specially based on external capacitor
>> connected on
>> rails.  This is observed mainly on VBUS regulator rail where
>> difference on the capacitance value which is connected on rail makes
>> the on/off
>> time to vary.
> Usually this would be handled via regulator driver platform data as the
> regulator will typically be designed with particular external components
> in mind and (especially in the case of DCDC convertors) may need to be
> configured differently depending on the choice of passive components.
> Many regulators also have some software control for the ramp rate,
> mainly intended to limit inrush currents on system startup, which can be
> varied at runtime if desired.
>

Interesting, Many regulator driver is written like it just take the 
regulator_init_data as the platform data and does not leave any option 
to add any new platform parameters.
Not sure how can we add platform data without too much tempering on the 
existing user, but if we can add parameter of delay(settling time) in 
struct regulator_init_data then almost all driver can support such 
platform specific delay.

