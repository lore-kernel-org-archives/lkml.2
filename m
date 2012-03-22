Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932264Ab2CVSd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 14:33:28 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:42907 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755983Ab2CVSdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 14:33:22 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: eqqlUUQVM1mDbOSDWqM.ooEkTkW.4UQVd3nxHbU4d21puLG
 WHW9b8wxchERgR0dv46WhJmYsyW6T11fMCSeg0i9g3cHmDwYCdgJTY7voX9O
 .HmYfGjZxWcy3hUV7zQe3e9m7wG7W_m.T_.8hluKHVcX4MID45OaLB5knO32
 Qn.p6rwJFjYKT4RtIjTD.mmY2ToIbt3yfG8VsdgzpkvlpQScWMO_XT9iY8UL
 5adhuLSCxTdRdFKy3T3oQvwuwT_lOIIupEyo3ijCtsQKUhTLGkrrsFgRcIMh
 WGTslR7bahGJWMnRa_7KJye3yaHZ_oih7EaD46Ee2yECoMRT5_y2yTNamhhh
 afEYbES.Sye9bAqgZDMNGDsLyEMFlkvCTphsM8eugn.Y443vIQ3jCasT8KYY
 4ayb5swGxsIpR4zAO8yCtJleRjnyHXCzg_y_L
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 22 Mar 2012 13:33:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Borislav Petkov <bp@amd64.org>
cc: Ingo Molnar <mingo@elte.hu>, Arnaldo Carvalho de Melo <acme@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH 2/2] tools: Add a toplevel Makefile
In-Reply-To: <1332435713-32143-3-git-send-email-bp@amd64.org>
Message-ID: <alpine.DEB.2.00.1203221332390.25011@router.home>
References: <1332435713-32143-1-git-send-email-bp@amd64.org> <1332435713-32143-3-git-send-email-bp@amd64.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Mar 2012, Borislav Petkov wrote:

> index 000000000000..97631367e0db
> --- /dev/null
> +++ b/tools/Makefile
> @@ -0,0 +1,24 @@
> +include scripts/Makefile.lib
> +
> +perf firewire lguest slub usb virtio: FORCE
> +	$(QUIET_SUBDIR0)$@/ $(QUIET_SUBDIR1)
> +
> +cpupower: FORCE
> +	$(QUIET_SUBDIR0)power/$@/ $(QUIET_SUBDIR1)
> +
> +turbostat x86_energy_perf_policy: FORCE
> +	$(QUIET_SUBDIR0)power/x86/$@/ $(QUIET_SUBDIR1)
> +
> +firewire_clean lguest_clean perf_clean slub_clean usb_clean virtio_clean:
> +	$(QUIET_SUBDIR0)$(@:_clean=)/ $(QUIET_SUBDIR1) clean
> +
> +cp_clean:
> +	$(QUIET_SUBDIR0)power/cpupower/ $(QUIET_SUBDIR1) clean
> +
> +turbostat_clean x86_energy_perf_policy_clean:
> +	$(QUIET_SUBDIR0)power/x86/$(@:_clean=)/ $(QUIET_SUBDIR1) clean
> +
> +clean: cp_clean firewire_clean lguest_clean perf_clean slub_clean turbostat_clean \

slub_clean? Where is that target defined?

> diff --git a/tools/slub/Makefile b/tools/slub/Makefile
> new file mode 100644
> index 000000000000..b2cf6b467bbe
> --- /dev/null
> +++ b/tools/slub/Makefile
> @@ -0,0 +1,4 @@
> +slabinfo: slabinfo.c
> +
> +clean:
> +	rm -rf slabinfo

That portion looks okay.

