Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759446Ab1EMPRd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 11:17:33 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:45707 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757522Ab1EMPRb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 11:17:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=PJolADvthk6LRcZxGOaoPMeevMdEc0utrXBW5+NnmQ3iF6ZsSaET+MNlxbMJt8+dQR
         LE4Oxjy6CVjriONWohNjvBLEL6GviMyvm5gaRju7NbyybjosfgZ8ogL+xEazCsKiE96V
         FrdMvBdGUTi4vNRv/JkQUsDLJmfrVpQLUqLmA=
Message-ID: <4DCD4B85.3040702@gmail.com>
Date: Fri, 13 May 2011 19:17:25 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Thunderbird/3.1.10
MIME-Version: 1.0
To: Huang Ying <ying.huang@intel.com>
CC: Ingo Molnar <mingo@elte.hu>, Don Zickus <dzickus@redhat.com>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Robert Richter <robert.richter@amd.com>,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [RFC] x86, NMI, Treat unknown NMI as hardware error
References: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
In-Reply-To: <1305275018-20596-1-git-send-email-ying.huang@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2011 12:23 PM, Huang Ying wrote:
> In general, unknown NMI is used by hardware and firmware to notify
> fatal hardware errors to OS. So the Linux should treat unknown NMI as
> hardware error and go panic upon unknown NMI for better error
> containment.
> 
> But there are some legacy machine which would randomly send unknown
> NMIs for no good reason.  To support these machines, a white list
> mechanism is provided to treat unknown NMI as hardware error only on
> some known working system.
> 
> These systems are identified via the presentation of APEI HEST or
> some PCI ID of the host bridge. The PCI ID of host bridge instead of
> DMI ID is used, so that the checking can be done based on the platform
> type instead of motherboard. This should be simpler and sufficient.
> 
> The method to identify the platforms is designed by Andi Kleen.
> 
> Signed-off-by: Huang Ying <ying.huang@intel.com>
> Cc: Andi Kleen <ak@linux.intel.com>
> Cc: Don Zickus <dzickus@redhat.com>
> ---
...

Hi Ying,

just curious (regardless the concerns Don and Ingo have) -- if there still a need
for such semi-unknown nmi handling maybe it's worth to register a *notifier* for it
and we panic only when user *explicitly* specify how to treat this class of NMIs
(via say "hest-nmi-panic" boot option or something like that). Maybe such partially
modular scheme would be better? If only I don't miss anything.

-- 
            Cyrill
