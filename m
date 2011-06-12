Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752873Ab1FLPOI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Jun 2011 11:14:08 -0400
Received: from mga02.intel.com ([134.134.136.20]:5721 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751608Ab1FLPOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Jun 2011 11:14:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,355,1304319600"; 
   d="scan'208";a="13469763"
Subject: Re: [PATCH] iwlagn: fix *_UCODE_API_MAX output in the firmware
 field
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Evgeni Golov <sargentd@die-welt.net>
Cc: "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1307882071-767-1-git-send-email-sargentd@die-welt.net>
References: <1307882071-767-1-git-send-email-sargentd@die-welt.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 12 Jun 2011 07:44:12 -0700
Message-ID: <1307889852.13397.128.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-06-12 at 05:34 -0700, Evgeni Golov wrote:
> Currently (3.0-rc2), modinfo iwlagn shows:
>     firmware:       iwlwifi-5150-IWL5150_UCODE_API_MAX.ucode
>     firmware:       iwlwifi-5000-IWL5000_UCODE_API_MAX.ucode
>     firmware:       iwlwifi-6000g2b-IWL6000G2_UCODE_API_MAX.ucode
>     firmware:       iwlwifi-6000g2a-IWL6000G2_UCODE_API_MAX.ucode
>     firmware:       iwlwifi-6050-IWL6050_UCODE_API_MAX.ucode
>     firmware:       iwlwifi-6000-IWL6000_UCODE_API_MAX.ucode
>     firmware:       iwlwifi-100-IWL100_UCODE_API_MAX.ucode
>     firmware:       iwlwifi-1000-IWL1000_UCODE_API_MAX.ucode
>     firmware:       iwlwifi-105-IWL105_UCODE_API_MAX.ucode
>     firmware:       iwlwifi-2030-IWL2030_UCODE_API_MAX.ucode
>     firmware:       iwlwifi-2000-IWL2000_UCODE_API_MAX.ucode
> 
> which is obviously wrong, the user should not see the *_UCODE_API_MAX
> macros but the actual ucode API versions here.
> 
> The problem are the
>     #define *_MODULE_FIRMWARE(api) *_FW_PRE #api ".ucode"
> which do not expand api correctly (because this is a macro itself).
> 
> Fixed by using __stringify() from linux/stringify.h.
> 
> Further information about macro stringification can be found here:
>     http://gcc.gnu.org/onlinedocs/cpp/Stringification.html
> 
> Signed-off-by: Evgeni Golov <sargentd@die-welt.net>
Signed-off-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

Good catch, thank you very much

Wey




