Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753404Ab2AWQsY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 11:48:24 -0500
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:22704
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753181Ab2AWQsW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 11:48:22 -0500
X-SpamScore: -5
X-BigFish: PS-5(zzbb2dI9371I98dKzz1202hzzz2fhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:207.46.4.139;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0602HT003.namprd06.prod.outlook.com;RD:none;EFVD:NLI
Message-ID: <4F1D8F37.6020806@ixiacom.com>
Date: Mon, 23 Jan 2012 08:47:51 -0800
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
References: <4F1C5995.3060806@ixiacom.com> <m1fwf6pjal.fsf@fess.ebiederm.org> <4F1D8180.9030509@ixiacom.com> <m1mx9enzr0.fsf@fess.ebiederm.org>
In-Reply-To: <m1mx9enzr0.fsf@fess.ebiederm.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [216.23.154.50]
X-MS-Exchange-CrossPremises-AuthSource: SN2PRD0602HT003.namprd06.prod.outlook.com
X-MS-Exchange-CrossPremises-AuthAs: Internal
X-MS-Exchange-CrossPremises-AuthMechanism: 06
X-MS-Exchange-CrossPremises-Rules-Execution-History: Support - Juniper
X-MS-Exchange-CrossPremises-Processed-By-Journaling: Journal Agent
X-OrganizationHeadersPreserved: SN2PRD0602HT003.namprd06.prod.outlook.com
X-OriginatorOrg: ixiacom.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/2012 8:35 AM, Eric W. Biederman wrote:
> read X < file seems like a reasonable case to support.
> Bash doesn't have that problem so presumably BusyBox is simply
> inefficient.

I think you are correct. In BusyBox, I believe there is a conscious
design decision to favour minimum size over maximum speed where it makes sense.

> If you are interested in fixing this properly with a tiny buffer
> reachable from struct file I think this can be worth fixing.  I think
> this is doable by using seq_file in proc_sys_read.

I did think about using seq_file, but my initial thoughts were that it
would end up being a much bigger change and I was reluctant to take that
on without some indication that it would be a more acceptable approach.

> Rereading different bytes of the integer multiple times when the integer
> may be changing does not seem like a reasonable implementation.

Yes. I agree with you. I shall re-work the patch as per your suggestion.

Earl

