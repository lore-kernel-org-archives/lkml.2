Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab2A3BN2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jan 2012 20:13:28 -0500
Received: from am1ehsobe003.messaging.microsoft.com ([213.199.154.206]:1631
	"EHLO AM1EHSOBE003.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751286Ab2A3BN1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jan 2012 20:13:27 -0500
X-SpamScore: -6
X-BigFish: PS-6(zz179dNzz1202hzzz2fhc1bhc31hc1ah2a8h668h839h)
X-Forefront-Antispam-Report: CIP:207.46.4.139;KIP:(null);UIP:(null);IPV:NLI;H:SN2PRD0602HT003.namprd06.prod.outlook.com;RD:none;EFVD:NLI
Message-ID: <4F25EEAE.6030908@ixiacom.com>
Date: Sun, 29 Jan 2012 17:13:18 -0800
From: Earl Chew <echew@ixiacom.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: "Eric W. Biederman" <ebiederm@xmission.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Eric Paris <eparis@redhat.com>,
        "Serge E. Hallyn" <serge.hallyn@canonical.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        <adobriyan@gmail.com>
Subject: Re: [PATCH] Support single byte reads from integers published in
 procfs by kernel/sysctl.c
References: <4F1C5995.3060806@ixiacom.com> <m1fwf6pjal.fsf@fess.ebiederm.org> <4F1D8180.9030509@ixiacom.com> <m1mx9enzr0.fsf@fess.ebiederm.org> <4F1D8F37.6020806@ixiacom.com> <4F25CEB5.8070704@ixiacom.com> <m1ty3ekpv5.fsf@fess.ebiederm.org>
In-Reply-To: <m1ty3ekpv5.fsf@fess.ebiederm.org>
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

> I suspect what we want for writes is to read the existing value into an
> internal buffer, and then allow partial writes to the internal buffer.

Oh I see. Hmm ... I get the feeling that doubles the scope of the exercise ;-)

I'll give it some more thought.

> I don't know if writable seq_files exist.

No, they don't -- at least not out-of-the-box. From fs/seq_file.c :

>         /*
>          * seq_files support lseek() and pread().  They do not implement
>          * write() at all, but we clear FMODE_PWRITE here for historical
>          * reasons.
>          *
>          * If a client of seq_files a) implements file.write() and b) wishes to
>          * support pwrite() then that client will need to implement its own
>          * file.open() which calls seq_open() and then sets FMODE_PWRITE.
>          */
>         file->f_mode &= ~FMODE_PWRITE;

Earl

