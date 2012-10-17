Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757493Ab2JQRBV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 13:01:21 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:49394 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756475Ab2JQRBU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 13:01:20 -0400
Date: Wed, 17 Oct 2012 13:02:03 -0400 (EDT)
From: Vince Weaver <vincent.weaver@maine.edu>
To: linux-kernel@vger.kernel.org
cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>, eranian@gmail.com,
        "Meadows, Lawrence F" <lawrence.f.meadows@intel.com>,
        vincent.weaver@maine.edu
Subject: [PATCH 0/3] perf_event: enable overflow interrupts on KNC
Message-ID: <alpine.DEB.2.02.1210171256550.23243@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello

the following patchset enables overflow interrupts on Knights Corner,
the initial KNC PMU driver that was included in 3.7-rc1 did not
support this.

The first patch should be straightforward.
The second should be too, but it relates to a problem with the p6 PMU
    that I brought up in a separate thread.
The third patch copies code over from the perf_event_intel.c interrupt
    handler.  Unfortunately KNC and x86 architectural perfmon use
    different MSR numbers.  The proper fix might be to make this
    generic and have function vectors for the status/ack functions,
    but since they are inline and probably performance critical
    I took the easy way out and just duplicated the code.

Thanks,

Vince Weaver
vincent.weaver@maine.edu
-- 
char x,_,*O="yyyyl1f41mm65mm5OU5m5_55m5555mmGUml1ED1ooG_ol\\lDClN:eml9niiobTQO"
"m8dlYoo=HUmmaNEnCDY[l1G@7oo975l1>UImmSG3m5`@Om5<OGm5__5mm4S_l1DTiyyyy";void X(
int x){while(x>-1)printf("\033[4%dm  ",x%2*7),x-=2;}int main(){while(*O){for(x=
30;x--;)_=*O-48,X(_>>6?59:(_>>x%6)&1),x*=_<64,O+=!(x%6);X(5),X(0),puts("");}}
