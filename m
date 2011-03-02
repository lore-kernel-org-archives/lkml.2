Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997Ab1CBQNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 11:13:46 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52464 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940Ab1CBQNp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 11:13:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Z1rK5kocNRRjRoozwoI1B75UYMJnAtQ2rWu0B5oUMKiFWrohSDLzKuLscKz5xcT6wK
         tTrGi+efkXAPBOUs2pq78Sqh6IzBgVIGGFOyxSk5eNcJNXx3AXLftsko9R8ln/jHlV6b
         STLNd5fub8YTjKKmfhtJtrhXnwoeMiC1s1zdw=
Message-ID: <4D6E6CB6.7000700@openvz.org>
Date: Wed, 02 Mar 2011 19:13:42 +0300
From: Cyrill Gorcunov <gorcunov@openvz.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Don Zickus <dzickus@redhat.com>, "Huang, Ying" <ying.huang@intel.com>,
        "Maciej W. Rozycki" <macro@linux-mips.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -tip 2/2 resend] x86, traps: Drop nmi_reason_lock until
 it is really needed
References: <4D6E631B.6040701@openvz.org> <20110302154645.GA11827@elte.hu> <4D6E6886.2060707@openvz.org> <20110302160315.GA12620@elte.hu>
In-Reply-To: <20110302160315.GA12620@elte.hu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/02/2011 07:03 PM, Ingo Molnar wrote:
...
> 
> Well, the lock serializes the read-out of the 'NMI reason' port, the handling of 
> whatever known reason and then the reassertion of the NMI (on 32-bit). 
> 
> EDAC has a callback in pci_serr_error() - and this lock serializes that. So we 
> cannot just remove a lock like that, if there's any chance of parallel execution on 
> multiple CPUs.
> 
> Thanks,
> 
> 	Ingo

OK, probably we need some UV person CC'ed (not sure whom) just to explain the
reason for such nmi-listening model. Meanwhile -- lets drop my patch.

-- 
    Cyrill
