Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab2HIOgi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 10:36:38 -0400
Received: from sentry-two.sandia.gov ([132.175.109.14]:48139 "EHLO
	sentry-two.sandia.gov" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752725Ab2HIOgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 10:36:36 -0400
X-WSS-ID: 0M8HSKW-0B-2JM-02
X-M-MSG: 
X-Server-Uuid: AF72F651-81B1-4134-BA8C-A8E1A4E620FF
Message-ID: <5023CADC.801@sandia.gov>
Date: Thu, 9 Aug 2012 08:36:12 -0600
From: "Jim Schutt" <jaschut@sandia.gov>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.5) Gecko/20120607
 Thunderbird/10.0.5
MIME-Version: 1.0
To: "Mel Gorman" <mgorman@suse.de>
cc: Linux-MM <linux-mm@kvack.org>, "Rik van Riel" <riel@redhat.com>,
        "Minchan Kim" <minchan@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH 0/5] Improve hugepage allocation success rates
 under load V3
References: <1344520165-24419-1-git-send-email-mgorman@suse.de>
In-Reply-To: <1344520165-24419-1-git-send-email-mgorman@suse.de>
X-TMWD-Spam-Summary: TS=20120809143619; ID=1; SEV=2.3.1;
 DFV=B2012080914; IFV=NA; AIF=B2012080914; RPD=5.03.0010; ENG=NA;
 RPDID=7374723D303030312E30413031303230362E35303233434145332E303030453A534346535441543838363133332C73733D312C6667733D30;
 CAT=NONE; CON=NONE; SIG=AAAAAAAAAAAAAAAAAAAAAAAAfQ==
X-MMS-Spam-Filter-ID: B2012080914_5.03.0010
X-WSS-ID: 7C3D156B2I0630698-01-01
Content-Type: text/plain;
 charset=utf-8;
 format=flowed
Content-Transfer-Encoding: 7bit
X-RSA-Inspected: yes
X-RSA-Classifications: Healthcare Dictionaries, public
X-RSA-Action: allow
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mel,

On 08/09/2012 07:49 AM, Mel Gorman wrote:
> Changelog since V2
> o Capture !MIGRATE_MOVABLE pages where possible
> o Document the treatment of MIGRATE_MOVABLE pages while capturing
> o Expand changelogs
>
> Changelog since V1
> o Dropped kswapd related patch, basically a no-op and regresses if fixed (minchan)
> o Expanded changelogs a little
>
> Allocation success rates have been far lower since 3.4 due to commit
> [fe2c2a10: vmscan: reclaim at order 0 when compaction is enabled]. This
> commit was introduced for good reasons and it was known in advance that
> the success rates would suffer but it was justified on the grounds that
> the high allocation success rates were achieved by aggressive reclaim.
> Success rates are expected to suffer even more in 3.6 due to commit
> [7db8889a: mm: have order>  0 compaction start off where it left] which
> testing has shown to severely reduce allocation success rates under load -
> to 0% in one case.  There is a proposed change to that patch in this series
> and it would be ideal if Jim Schutt could retest the workload that led to
> commit [7db8889a: mm: have order>  0 compaction start off where it left].

I was successful at resolving my Ceph issue on 3.6-rc1, but ran
into some other issue that isn't immediately obvious, and prevents
me from testing your patch with 3.6-rc1.  Today I will apply your
patch series to 3.5 and test that way.

Sorry for the delay.

-- Jim

