Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab0F2BAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jun 2010 21:00:07 -0400
Received: from koto.vergenet.net ([210.128.90.7]:39895 "EHLO koto.vergenet.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751131Ab0F2BAF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jun 2010 21:00:05 -0400
Date: Tue, 29 Jun 2010 10:00:04 +0900
From: Simon Horman <horms@verge.net.au>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: trivial@kernel.org, Kernel Janitors <kernel-janitors@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Andrea Gelmini <andrea.gelmini@gelma.net>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 11/16] trivial: use ARRAY_SIZE
Message-ID: <20100629010004.GN10073@verge.net.au>
References: <1277726125-24765-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277726125-24765-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 28, 2010 at 03:55:24PM +0400, Kulikov Vasiliy wrote:
> Change sizeof(x) / sizeof(*x) to ARRAY_SIZE(x).
> 
> Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>

Looks good.

Acked-by: Simon Horman <horms@verge.net.au>

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
> -- 
> 1.7.0.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
