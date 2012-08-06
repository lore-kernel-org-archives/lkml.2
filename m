Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932569Ab2HFTvV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 15:51:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:45750 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932500Ab2HFTvT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 15:51:19 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Vlad Yasevich <vyasevich@gmail.com>
Cc: Jan Ariyasu <jan.ariyasu@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Ariyasu <jan.ariyasu@hp.com>
References: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
	<87mx27rig7.fsf@xmission.com> <50201928.2030802@gmail.com>
Date: Mon, 06 Aug 2012 12:50:46 -0700
In-Reply-To: <50201928.2030802@gmail.com> (Vlad Yasevich's message of "Mon, 06
	Aug 2012 15:21:12 -0400")
Message-ID: <874noflrzd.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/dZK4Yw6RvE1GCJLd0EVggaw9IDNYlcGY=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0846]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa01 1397; Body=1 Fuz1=1 Fuz2=1]
X-Spam-DCC: XMission; sa01 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Vlad Yasevich <vyasevich@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 00/13] SCTP: Enable netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vlad Yasevich <vyasevich@gmail.com> writes:


> Hi Eric
>
> Associations are looked up by ports, but then verifyed by addresses.
> Also, associations belong to sockets and simply validating the socket
> namespace should be sufficient.

True.  Your set of patches isn't quite as likely to malfunction as it
looked at first glance.  It requires address reuse which happens accross
namespaces but not too frequently.

As for validating the socket namespace I agree that is the fix and my
patchset winds up doing it.

>> The downside with my version is that it does not make all of the sctp
>> tunables per network namespace the way yours does, but making all of
>> the tunables per network namespace should be straight forward from
>> my base.
>>
>> My patchset also misses some nice to haves like making the association
>> id allocation per network namespace.  It is not important for
>> correctness of the code but it might allow an information leak between
>> namespaces.
>
> Hmm.. this one might be nice to have not from the perspective of leak,
> but from resource limitation.  Without this, once the id space is
> global is can be exhausted faster.

It takes a lot of associtations to exhaust the id space, but I have no
fundamental problems problems with the id allocation being per
namespace.  I had actually overlooked the local association id when I
did my patches.   After looking it became clear that making the
association id global was not necessary so I left it.

The sctp association id is a strange beast.  My personal inclination is
that the sctp association id really ought to be per sctp socket, but I
have not looked enough at the sctp userspace API to see if that works in
practice.  Shrug.

Mostly I am in favor of simple and correct.

Eric
