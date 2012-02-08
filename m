Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757060Ab2BHR5S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:57:18 -0500
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:23686
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756793Ab2BHR5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:57:17 -0500
X-SpamScore: -16
X-BigFish: VPS-16(zz1432N98dK853kzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ35VB-01-EL6-02
X-M-MSG: 
Date: Wed, 8 Feb 2012 18:57:09 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: perf: record segfaults for cycles event when collecting data on
 a VM
Message-ID: <20120208175709.GK22598@amd.com>
References: <4F32A907.6030505@gmail.com>
 <20120208174434.GI22598@amd.com>
 <4F32B680.3090502@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F32B680.3090502@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 10:53:04AM -0700, David Ahern wrote:

> The segfault is in the event processing once the collection is done
> (perf-record), so the time length should not matter.

Yes, but I wanted to make sure there is a GUEST_KERNEL sample in there
to process. It usually takes some time (at least in my tests) to get a
spurious one.

> Either way, this fixes the segafult:
> 
> diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
> index 8131410..fb25d13 100644
> --- a/tools/perf/util/util.c
> +++ b/tools/perf/util/util.c
> @@ -6,7 +6,7 @@
>   * XXX We need to find a better place for these things...
>   */
>  bool perf_host  = true;
> -bool perf_guest = true;
> +bool perf_guest = false;
> 
>  void event_attr_init(struct perf_event_attr *attr)
>  {
> 
> which makes sense. It forces perf_session__find_machine_for_cpumode() to
> return the host machine always.

Great, thanks. I will send two patches tomorrow to fix Jason's problem
and change the default for perf_guest.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

