Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932827Ab1EZP3Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 11:29:25 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:39652 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932621Ab1EZP3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 11:29:23 -0400
In-Reply-To: <cover.1305846412.git.mst@redhat.com>
References: <cover.1305846412.git.mst@redhat.com>
Subject: [PERF RESULTS] virtio and vhost-net performance enhancements
X-KeepSent: 0EFA7BA9:BB2C2860-6525789C:0053EE3A;
 type=4; name=$KeepSent
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: Christian Borntraeger <borntraeger@de.ibm.com>,
        Carsten Otte <cotte@de.ibm.com>, habanero@linux.vnet.ibm.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>, kvm@vger.kernel.org,
        lguest@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-s390@vger.kernel.org, linux390@de.ibm.com,
        netdev@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>, steved@us.ibm.com,
        Tom Lendacky <tahm@linux.vnet.ibm.com>,
        virtualization@lists.linux-foundation.org, Shirley Ma <xma@us.ibm.com>
X-Mailer: Lotus Notes Release 8.5.1 September 28, 2009
Message-ID: <OF0EFA7BA9.BB2C2860-ON6525789C.0053EE3A-6525789C.005513CC@in.ibm.com>
From: Krishna Kumar2 <krkumar2@in.ibm.com>
Date: Thu, 26 May 2011 21:02:11 +0530
X-MIMETrack: Serialize by Router on d23ml172/23/M/IBM(Release 8.5.1FP5|September 29, 2010) at
 26/05/2011 21:02:18
MIME-Version: 1.0
Content-type: text/plain; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Michael S. Tsirkin" <mst@redhat.com> wrote on 05/20/2011 04:40:07 AM:

> OK, here is the large patchset that implements the virtio spec update
> that I sent earlier (the spec itself needs a minor update, will send
> that out too next week, but I think we are on the same page here
> already). It supercedes the PUBLISH_USED_IDX patches I sent
> out earlier.

I was able to get this tested by applying the v2 patches
to git-next tree (somehow MST's git tree hung on my guest
which never got resolved). Testing was from Guest -> Remote
node, using an ixgbe 10g card. The test results are
*excellent* (table: #netperf sesssions, BW% improvement,
SD% improvement, CPU% improvement):

___________________________________
           512 byte I/O
#     BW%     SD%      CPU%
____________________________________
1     151.6   -65.1    -10.7
2     180.6   -66.6    -6.4
4     15.5    -35.8    -26.1
8     1.8     -28.4    -26.7
16    3.1     -29.0    -26.5
32    1.1     -27.4    -27.5
64    3.8     -30.9    -26.7
96    5.4     -21.7    -24.2
128   5.7     -24.4    -25.5
____________________________________
BW: 16.6%   SD: -24.6%    CPU: -25.5%


____________________________________
            1K I/O
#     BW%     SD%      CPU%
____________________________________
1     233.9   -76.5    -18.0
2     112.2   -64.0    -23.2
4     9.2     -31.6    -26.1
8    -1.7     -26.8    -30.3
16    3.5     -31.5    -30.6
32    4.8     -25.2    -30.5
64    5.7     -31.0    -28.9
96    5.3     -32.2    -31.7
128   4.6     -38.2    -33.6
____________________________________
BW: 16.4%   SD: -35.%    CPU: -31.5%


____________________________________
             16K I/O
#     BW%     SD%      CPU%
____________________________________
1     18.8    -27.2    -18.3
2     14.8    -36.7    -27.7
4     12.7    -45.2    -38.1
8     4.4     -56.4    -54.4
16    4.8     -38.3    -36.1
32    0        78.0     79.2
64    3.8     -38.1    -37.5
96    7.3     -35.2    -31.1
128   3.4     -31.1    -32.1
____________________________________
BW: 7.6%   SD: -30.1%   CPU: -23.7%


I plan to run some more tests tomorrow. Please let
me know if any other scenario will help.

Thanks,

- KK

