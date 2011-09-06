Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755174Ab1IFQCh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 12:02:37 -0400
Received: from cdptpa-bc-oedgelb.mail.rr.com ([75.180.133.32]:42413 "EHLO
	cdptpa-bc-oedgelb.mail.rr.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754951Ab1IFQCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 12:02:30 -0400
Authentication-Results: cdptpa-bc-oedgelb.mail.rr.com smtp.user=rpearson@systemfabricworks.com; auth=pass (LOGIN)
X-Authority-Analysis: v=1.1 cv=40Z/dbZBr1wgzPkGSf8y7qdCkiWp+M7NvixVUiz+qMg= c=1 sm=0 a=ozIaqLvjkoIA:10 a=kj9zAlcOel0A:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:17 a=Z4Rwk6OoAAAA:8 a=VwQbUJbxAAAA:8 a=YORvzBCaAAAA:8 a=zEZBlQ7k8u9UCEbd7NgA:9 a=GmUm-tWQDQD_YOP9c_4A:7 a=CjuIK1q_8ugA:10 a=jbrJJM5MRmoA:10 a=VV2__AUApEoA:10 a=DCwX0kaxZCiV3mmbfDr8nQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.79.195.91
From: "Bob Pearson" <rpearson@systemfabricworks.com>
To: "'Andrew Morton'" <akpm@linux-foundation.org>
Cc: <linux-kernel@vger.kernel.org>, <fzago@systemfabricworks.com>,
        "'Joakim Tjernlund'" <joakim.tjernlund@transmode.se>,
        "'George Spelvin'" <linux@horizon.com>
References: <4E5EB5CC.1010605@systemfabricworks.com> <20110902165020.7c6b5382.akpm@linux-foundation.org>
In-Reply-To: <20110902165020.7c6b5382.akpm@linux-foundation.org>
Subject: RE: [PATCH v6 00/10] crc32
Date: Tue, 6 Sep 2011 11:02:27 -0500
Message-ID: <01c001cc6cae$60a95080$21fbf180$@systemfabricworks.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQHgK6q1u/qSwu46AKbi0/Eq11WY+AD5Z0mJlRE20KA=
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I took the holiday weekend off so this is somewhat delayed.

> -----Original Message-----
> From: Andrew Morton [mailto:akpm@linux-foundation.org]
> Sent: Friday, September 02, 2011 6:50 PM
> To: Bob Pearson
> Cc: linux-kernel@vger.kernel.org; fzago@systemfabricworks.com; Joakim
> Tjernlund; George Spelvin
> Subject: Re: [PATCH v6 00/10] crc32
> 
> On Wed, 31 Aug 2011 17:29:32 -0500
> Bob Pearson <rpearson@systemfabricworks.com> wrote:
> 
> > This is an attempt to resolve all the issues that were left in the last
review.
> > There is one proposed change that is still causing a difference of
opinion
> > which has to do with the form of the loops and their performance on x86
> and ppc
> > This version has the change to the form that runs faster on x86 as an
ifdef.
> >
> > This patch series provides improved performance for computing the crc32
> > polynomial on common hardware by adding the Slicing-by-8 algorithm to
> the
> > existing algorithms already included. The new algorithm is very closely
> > related to the existing algorithm so the extension requires small
changes
> > to implement.  Additionally it cleans up some warnings in the existing
> > code and adds a kernel mode optional self test to replace the existing
> > user mode self test.
> >
> > A description of the existing and new algorithm is included in
> > Documentation/crc32.txt.
> 
> So...  are the crc wars over yet?  I hope it's safe to look at the
> patches now ;)

I hope so.

> 
> Please see Documentation/SubmittingPatches Section 15's discussion of
> patch Subject: lines.

Which sin am I committing? Use of 'vn' seems widespread but is not
specifically mentioned in the document. I am not sure about whether crc32
rises to the level of a 'subsystem' but chose that label. I am missing a
colon though.

> 
> Is there any code in the kernel which uses the crc code so much that we
> actually care about its performance?

I can only speak for myself. I am working on a project to write a software
emulation of an RDMA (InfiniBand like) protocol called RoCE or RDMA over
Converged Ethernet. This protocol uses CRC32 as an L3 CRC that is carried
end to end. Without this change to CRC32 the best performance on a single
core was well below 1GB/src. With it, performance is closer to the wire
speed of hardware implementations, i.e. around 1GB/sec.

