Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752277Ab0LVUg1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 15:36:27 -0500
Received: from claw.goop.org ([74.207.240.146]:52393 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751927Ab0LVUgZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 15:36:25 -0500
Message-ID: <4D126142.8010808@goop.org>
Date: Wed, 22 Dec 2010 12:36:18 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Lightning/1.0b3pre Thunderbird/3.1.7
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: linux-kernel@vger.kernel.org, hpa@zytor.com,
        Jan Beulich <JBeulich@novell.com>, xen-devel@lists.xensource.com,
        Konrad Rzeszutek Wilk <konrad@kernel.org>
Subject: Re: [PATCH 02/10] xen/p2m: change p2m_missing_* to p2m_identity_*
References: <1292967460-15709-1-git-send-email-konrad.wilk@oracle.com> <1292967460-15709-3-git-send-email-konrad.wilk@oracle.com> <4D112D13.8010208@goop.org> <20101222145917.GB1760@dumpdata.com>
In-Reply-To: <20101222145917.GB1760@dumpdata.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/22/2010 06:59 AM, Konrad Rzeszutek Wilk wrote:
> On Tue, Dec 21, 2010 at 02:41:23PM -0800, Jeremy Fitzhardinge wrote:
>> On 12/21/2010 01:37 PM, Konrad Rzeszutek Wilk wrote:
>>> From: Konrad Rzeszutek Wilk <konrad@kernel.org>
>>>
>>> We are going to alter how we think about P2M. Most of the
>>> P2M contains MFN, and areas that are not populated are
>>> considered to be "missing". Missing means that the PFN
>>> is either not set for this guest (not have that much memory
>>> allocated) or is under the balloon driver ownership.
>>>
>>> We are instead now going to think of those not populated
>>> areas as "identity." Meaning that that the PFN for which
>>> we would get the p2m_identity we will provide the the PFN
>>> value back instead of P2M_MISSING. Essentially treating
>>> those regions as PFN==MFN.
>>>
>> This renames missing -> identity, but does it actually change the
>> functionality?  Doesn't it just leave it being misnamed?  It would
>> probably be better to fold in the actual identity implementation as well.
> You sure? It would be a lot of changes in one patch. This patch is
> a nop - so no functional changes except the name change.
>
> Let me annotate the git tree to mention this.

Yeah, I'm in two minds.  I like small single-purpose patches, but the
rename really does leave things v. misnamed.  I guess it doesn't really
matter for one commit, so long as its still bisectable (and the commit
comment makes it clear that the name is misleading).

>>>  		mid_mfn_mfn = virt_to_mfn(mid_mfn);
>>> -		if (cmpxchg(top_mfn_p, missing_mfn, mid_mfn_mfn) != missing_mfn)
>>> +		if (cmpxchg(top_mfn_p, identity_mfn, mid_mfn_mfn) !=
>>> +		    identity_mfn)
>> Don't wrap this.
> Checkpatch.pl was unhappy without it. I can ignore this.

Checkpatch is generally wrong on the subject of long lines.

    J

