Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328Ab2AWPt3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 10:49:29 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:45405
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643Ab2AWPt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 10:49:28 -0500
X-SpamScore: -11
X-BigFish: PS-11(zzbb2dI9371I1432N98dKzz1202hzzz2fhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:207.46.4.139;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0602HT005.namprd06.prod.outlook.com;RD:none;EFVD:NLI
X-FB-SS: 13,
Message-ID: <4F1D8180.9030509@ixiacom.com>
Date: Mon, 23 Jan 2012 07:49:20 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>
Subject: Re: [PATCH] Support single byte reads from integers published in
 procfs by kernel/sysctl.c
References: <4F1C5995.3060806@ixiacom.com> <m1fwf6pjal.fsf@fess.ebiederm.org>
In-Reply-To: <m1fwf6pjal.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.23.154.50]
X-MS-Exchange-CrossPremises-AuthSource: SN2PRD0602HT005.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Rules-Execution-History: Support - Juniper
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN2PRD0602HT005.namprd06.prod.outlook.com
X-OriginatorOrg: ixiacom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/2012 6:47 AM, Eric W. Biederman wrote:
> The difference between strings and integers is that with strings
> single byte reads/writes actually make sense.
> 
> Single decimal digits reads don't make much sense at all for integers.
> 
> Is there any compelling reason to support this complete idiocy from user
> space programs?

Eric,

[ I also note that the patch allows multiple short reads (not necessarily
  just a single byte at a time) from these entries in procfs. ]

I think there is a reasonable userspace expectation that entities
that present themselves as text files to produce results that are
consistent with the userspace model of a text file.

For a more concrete example, consider the following BusyBox ash(1) code:

read X < /proc/sys/kernel/threads-max
Y=$(cat /proc/sys/kernel/threads-max)

read A < /proc/sys/kernel/core_pattern
B=$(cat /proc/sys/kernel/core_pattern)

The fact that these yield different results is surprising given that
the user sees these as text files.

I think it is worthwhile asking the opposite question,

" Is there any compelling reason for the kernel to require userspace
  programs to access /proc/sys/kernel/threads-max any differently
  from, say, /etc/fstab ? "

If the answer is in the affirmative, then it requires some layer in
the userspace program (presumably the IO layer) to make some
special accommodation for some entries in /proc.

As can be seen in the case of BusyBox, this approach might be difficult
to swallow in something as generic as ash(1), so it is left to the user to
puzzle out why read fails, but cat works -- but only sometimes.

Earl

