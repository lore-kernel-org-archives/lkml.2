Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757066Ab0IHFzE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 01:55:04 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:49310 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab0IHFzB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 01:55:01 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: jovi zhang <bookjovi@gmail.com>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes.berg@intel.com>,
        Alexey Dobriyan <adobriyan@openvz.org>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
References: <AANLkTikp0m8cQYfEBHP_E8XpGZqdMj6Cr4M=aWCnei=X@mail.gmail.com>
	<1283923185.2634.772.camel@edumazet-laptop>
	<AANLkTim+=vj+k3=1hzT3=J4ssOopp5Eq=g+DHis=pZFN@mail.gmail.com>
Date: Tue, 07 Sep 2010 22:54:52 -0700
In-Reply-To: <AANLkTim+=vj+k3=1hzT3=J4ssOopp5Eq=g+DHis=pZFN@mail.gmail.com>
	(jovi zhang's message of "Wed, 8 Sep 2010 13:33:28 +0800")
Message-ID: <m1tym0vkyb.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.157.188;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 98.207.157.188
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa03 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa03 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;jovi zhang <bookjovi@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH] netlink: Fix kfree NULL pointer
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

jovi zhang <bookjovi@gmail.com> writes:

> On Wed, Sep 8, 2010 at 1:19 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
>>
>>
>> This patch is not needed
>>
>> kfree(NULL) is legal
>>
>>
>>
>>
>
> YES, maybe kfree(NULL) is legal, but I cannot see there have any need
> to invoke kfree(NULL) in this function.
>  Also I check kfree usage in other code, I havn't find any kfree(NULL)
> usage.

Usually kfree(NULL) is not explicit, but "var = NULL; kfree(var)" is
common in error handling paths to reduce the complexity of error
handling, making bugs less likely.


Eric

