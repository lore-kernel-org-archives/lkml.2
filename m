Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932356Ab1J1OYN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Oct 2011 10:24:13 -0400
Received: from mga11.intel.com ([192.55.52.93]:30995 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755896Ab1J1OYJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Oct 2011 10:24:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,418,1315206000"; 
   d="scan'208";a="83533693"
Message-ID: <4EAABB07.3000305@linux.intel.com>
Date: Fri, 28 Oct 2011 07:24:07 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
CC: khilman@ti.com, venki@google.com, ak@linux.intel.com, len.brown@intel.com,
        peterz@infradead.org, rjw@sisk.pl, santosh.shilimkar@ti.com,
        lenb@kernel.org, linux-pm@vger.kernel.org, linux-sh@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-omap@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v9 2/4] cpuidle: Remove CPUIDLE_FLAG_IGNORE and dev->prepare()
References: <20111028104945.7520.83828.stgit@localhost6.localdomain6> <20111028105020.7520.68014.stgit@localhost6.localdomain6>
In-Reply-To: <20111028105020.7520.68014.stgit@localhost6.localdomain6>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1
 
On 10/28/2011 3:50 AM, Deepthi Dharwar wrote:
> The cpuidle_device->prepare() mechanism causes updates to the
> cpuidle_state[].flags, setting and clearing CPUIDLE_FLAG_IGNORE
> to tell the governor not to chose a state on a per-cpu basis at
> run-time. State demotion is now handled by the driver and it returns
> the actual state entered. Hence, this mechanism is not required.
> Also this removes per-cpu flags from cpuidle_state enabling
> it to be made global.
>
 
having worked on some newer platforms....
this one is really still needed. doing this inside the actual states
does not work,
because if the deepest 3 states are invalid, the same (somewhat
expensive) test would have to be done 3 times,
and each of the states would have to fail before the 4th one gets chosen.
that's just not going to work
 
(in the state handler you can't know what other state to fall back to,
and especially not how to enter such a fallback state)
 
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (MingW32)
 
iQEcBAEBAgAGBQJOqrsGAAoJEEHdSxh4DVnEu7EH/i5lEJctBAIubJOcZz/tvBFp
XYmAe/HqNtSXeHOVsJkTf8y4ppE8487exF7xxMik4GRN0CZNCtkyMezqDVu+eDim
O/UUbScsAc5cSY6mkjOFXLFup+mi1nkRUnAbxXEyTMhWwcbfr2OvcuO7l7TmATML
hu87P3PVEafEop3q2+uWMc57fFxnNFfEDqRx6N9V+OJKV5dHrRYL4G4E01fYGFLo
xTR0IW7nB15L0C29zk9uk/Dqow8SoJZA83c7p7AieP5zdntb6p7noIf03qmdp19f
fulwMwembCHivo+pLO+jAMhKD1T6VYoCyiYW0LHrQ2E07fayBhFJCxlazgKFcl0=
=FL6o
-----END PGP SIGNATURE-----

