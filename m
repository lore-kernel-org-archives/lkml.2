Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab2HFSUY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 14:20:24 -0400
Received: from out03.mta.xmission.com ([166.70.13.233]:48851 "EHLO
	out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932114Ab2HFSUV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 14:20:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Jan Ariyasu <jan.ariyasu@gmail.com>
Cc: Vlad Yasevich <vyasevich@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, linux-sctp@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Ariyasu <jan.ariyasu@hp.com>
References: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com>
Date: Mon, 06 Aug 2012 11:20:08 -0700
In-Reply-To: <1344115837-6150-1-git-send-email-jan.ariyasu@hp.com> (Jan
	Ariyasu's message of "Sat, 4 Aug 2012 15:30:37 -0600")
Message-ID: <87mx27rig7.fsf@xmission.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX195/T2g4xBanDKScxdXhvlEuyyCkBDzhpQ=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  1.5 XMNoVowels Alpha-numberic number with no vowels
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -0.0 BAYES_20 BODY: Bayes spam probability is 5 to 20%
	*      [score: 0.0876]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa06 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 T_XMDrugObfuBody_04 obfuscated drug references
X-Spam-DCC: XMission; sa06 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Jan Ariyasu <jan.ariyasu@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: [PATCH 00/13] SCTP: Enable netns
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Ariyasu <jan.ariyasu@gmail.com> writes:

> The following set of patches enable network-namespaces for the SCTP protocol.
>
> The multitude of global parameters are stored in a net_generic
> structure, and the bulk of the patches enable the protocol to access
> the parameters on a per-namespace basis.  The first five patches
> enable netns handling of the protocol, procfs and sysfs.

I am going to do something to muddy the waters here, that I had hoped to
avoid when I saw your patchset.

A few weeks ago I wanted to play with sctp and also made a network
namespace enabled version.  I am not deeply attached to my changes,
however when comparing the differences I realized that your code fails
to make the lookup of associations per network namespace.

Given that we only have source and destination port to lookup
assoications by this almost guarantees one network namespace can
accidentially use the association of another network namespace meerly
by reusing the same ports.

The downside with my version is that it does not make all of the sctp
tunables per network namespace the way yours does, but making all of
the tunables per network namespace should be straight forward from
my base.

My patchset also misses some nice to haves like making the association
id allocation per network namespace.  It is not important for
correctness of the code but it might allow an information leak between
namespaces.

So Jan I am going to send my patchset and hopefully you can rebase your
changes to make all of the tunables per network namespace on top of
mine.

Since my patchset is half the size of your I think that is the most
reasonable way to go.

Eric

