Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab2BHRoq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 12:44:46 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:10639
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756807Ab2BHRoo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 12:44:44 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LZ35AB-02-AUK-02
X-M-MSG: 
Date: Wed, 8 Feb 2012 18:44:34 +0100
From: Joerg Roedel <joerg.roedel@amd.com>
To: David Ahern <dsahern@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        LKML <linux-kernel@vger.kernel.org>, Jason Wang <jasowang@redhat.com>
Subject: Re: perf: record segfaults for cycles event when collecting data on
 a VM
Message-ID: <20120208174434.GI22598@amd.com>
References: <4F32A907.6030505@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <4F32A907.6030505@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 09:55:35AM -0700, David Ahern wrote:
> perf record -e cycles -p 21483 -- sleep 1
> [ perf record: Woken up 1 times to write data ]
> [ perf record: Captured and wrote 0.012 MB perf.data (~503 samples) ]
> Segmentation fault

The problem is similar to the one Jason is seeing. I am working on a fix
right now.
Bottom line is that the perf-tool may receive samples tagged as
GUEST_KERNEL even when guest-sampling is disabled (probably a
race-condition). The perf-tool can not find a valid machine pointer for
such a sample and passes NULL down to the other functions. And some
functions don't seem to handle this.

David, can you try to change the default for perf_guest back to false
amd re-test? Not with 'sleep 1' probably, on my setup it takes a busy
guest and a few seconds to trigger.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

