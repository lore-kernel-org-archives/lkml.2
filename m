Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754390Ab0F1MmO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 08:42:14 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:21499 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753966Ab0F1MmM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 08:42:12 -0400
Message-ID: <4C28989E.9010300@bfs.de>
Date: Mon, 28 Jun 2010 14:42:06 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Kulikov Vasiliy <segooon@gmail.com>
CC: trivial@kernel.org, Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Simon Horman <horms@verge.net.au>,
       Andrea Gelmini <andrea.gelmini@gelma.net>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/16] trivial: use ARRAY_SIZE
References: <1277726125-24765-1-git-send-email-segooon@gmail.com>
In-Reply-To: <1277726125-24765-1-git-send-email-segooon@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Kulikov Vasiliy schrieb:
> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
> ---
>  drivers/staging/otus/hal/hpreg.c |   17 +++++++----------
>  1 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/staging/otus/hal/hpreg.c b/drivers/staging/otus/hal/hpreg.c
> index da3b774..9b04653 100644
> --- a/drivers/staging/otus/hal/hpreg.c
> +++ b/drivers/staging/otus/hal/hpreg.c
> @@ -29,9 +29,6 @@
>  #include "hpreg.h"
>  #include "hpusb.h"
>  
> -/* used throughout this file... */
> -#define	N(a)	(sizeof(a) / sizeof(a[0]))
> -
>  #define HAL_MODE_11A_TURBO	HAL_MODE_108A
>  #define HAL_MODE_11G_TURBO	HAL_MODE_108G
>  
> @@ -1557,7 +1554,7 @@ u8_t GetWmRD(u16_t regionCode, u16_t channelFlag, REG_DOMAIN *rd)
>  	u64_t flags = NO_REQ;
>  	REG_DMN_PAIR_MAPPING *regPair = NULL;
>  
> -	for (i = 0, found = 0; (i < N(regDomainPairs)) && (!found); i++) {
> +	for (i = 0, found = 0; (i < ARRAY_SIZE(regDomainPairs)) && (!found); i++) {
>  		if (regDomainPairs[i].regDmnEnum == regionCode) {
>  			regPair = &regDomainPairs[i];
>  			found = 1;



This looks odd, i do not see the rest of the code but perhaps a break would help
to eleminate the "found" ??

just my two cents,
 wh


> @@ -1581,7 +1578,7 @@ u8_t GetWmRD(u16_t regionCode, u16_t channelFlag, REG_DOMAIN *rd)
>  	 * unitary reg domain of the pair
>  	 */
>  
> -	for (i = 0 ; i < N(regDomains) ; i++) {
> +	for (i = 0 ; i < ARRAY_SIZE(regDomains) ; i++) {
>  		if (regDomains[i].regDmnEnum == regDmn) {
>  			if (rd != NULL) {
>  					zfMemoryCopy((u8_t *)rd, (u8_t *)&regDomains[i],
> @@ -1653,7 +1650,7 @@ void zfHpGetRegulationTable(zdev_t *dev, u16_t regionCode, u16_t c_lo, u16_t c_h
>  
>  	zmw_enter_critical_section(dev);
>  
> -	for (cm = modes; cm < &modes[N(modes)]; cm++) {
> +	for (cm = modes; cm < &modes[ARRAY_SIZE(modes)]; cm++) {
>  		u16_t c;
>  		u64_t *channelBM = NULL;
>  		REG_DOMAIN *rd = NULL;
> @@ -1846,7 +1843,7 @@ void zfHpGetRegulationTablefromCountry(zdev_t *dev, u16_t CountryCode)
>  
>  	zmw_declare_for_critical_section();
>  
> -	for (i = 0; i < N(allCountries); i++) {
> +	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
>  		if (CountryCode == allCountries[i].countryCode) {
>  			RegDomain = allCountries[i].regDmnEnum;
>  
> @@ -1881,7 +1878,7 @@ u8_t zfHpGetRegulationTablefromISO(zdev_t *dev, u8_t *countryInfo, u8_t length)
>  		strLen = 3; */
>  	}
>  	/* zm_debug_msg_s("Desired iso name = ", isoName); */
> -	for (i = 0; i < N(allCountries); i++) {
> +	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
>  		/* zm_debug_msg_s("Current iso name = ", allCountries[i].isoName); */
>  		if (zfMemoryIsEqual((u8_t *)allCountries[i].isoName, (u8_t *)&countryInfo[2], length-1)) {
>  			/* DbgPrint("Set current iso name = %s\n", allCountries[i].isoName); */
> @@ -1937,7 +1934,7 @@ const char *zfHpGetisoNamefromregionCode(zdev_t *dev, u16_t regionCode)
>  {
>  	u16_t i;
>  
> -	for (i = 0; i < N(allCountries); i++) {
> +	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
>  		if (allCountries[i].regDmnEnum == regionCode)
>  			return allCountries[i].isoName;
>  	}
> @@ -1953,7 +1950,7 @@ u16_t zfHpGetRegionCodeFromIsoName(zdev_t *dev, u8_t *countryIsoName)
>  	/* if no matching item, return default */
>  	regionCode = DEF_REGDMN;
>  
> -	for (i = 0; i < N(allCountries); i++) {
> +	for (i = 0; i < ARRAY_SIZE(allCountries); i++) {
>  		if (zfMemoryIsEqual((u8_t *)allCountries[i].isoName, countryIsoName, 2)) {
>  			regionCode = allCountries[i].regDmnEnum;
>  		break;
