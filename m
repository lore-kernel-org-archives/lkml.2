Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757917Ab2CPBwP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 21:52:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:54429 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752606Ab2CPBwI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 21:52:08 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="129584940"
Message-ID: <4F629CC5.60402@linux.intel.com>
Date: Thu, 15 Mar 2012 18:52:05 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120312 Thunderbird/11.0
MIME-Version: 1.0
To: Colin Cross <ccross@android.com>
CC: Kevin Hilman <khilman@ti.com>, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>, Trinabh Gupta <g.trinabh@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        linux-pm@lists.linux-foundation.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCHv2 3/5] cpuidle: add support for states that affect multiple
 cpus
References: <1331749794-8056-1-git-send-email-ccross@android.com> <1331749794-8056-4-git-send-email-ccross@android.com> <87lin18l7o.fsf@ti.com> <CAMbhsRS3J2vruru8i4r1-cB9aJLYW9y1bP0vv7=L3q1JP77ttg@mail.gmail.com>
In-Reply-To: <CAMbhsRS3J2vruru8i4r1-cB9aJLYW9y1bP0vv7=L3q1JP77ttg@mail.gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/2012 5:20 PM, Colin Cross wrote:
> Oops, dropped the atomic_dec when I merged from two separate functions
> for up and down to a single function that takes a bool.

generally in Linux we tend to not like "multiplexer" common functions
like this.

my suggestion: make your current function a __ prefixed one, then
provide 2 small inlines that call the __ one...

