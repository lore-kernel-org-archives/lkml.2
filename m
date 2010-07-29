Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757720Ab0G2O4w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 10:56:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:32926 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754412Ab0G2O4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 10:56:51 -0400
Date: Thu, 29 Jul 2010 10:56:32 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Heinz Diehl <htd@fancy-poultry.org>, linux-kernel@vger.kernel.org,
        jaxboe@fusionio.com, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com, czoccolo@gmail.com,
        "Ted Ts'o" <tytso@mit.edu>
Subject: Re: cfq fsync patch testing results (Was: Re: [RFC PATCH]
 cfq-iosched: IOPS mode for group scheduling and new group_idle tunable)
Message-ID: <20100729145632.GC25863@redhat.com>
References: <1279834172-4227-1-git-send-email-vgoyal@redhat.com>
 <20100723140343.GA8478@fancy-poultry.org>
 <20100723141303.GB13104@redhat.com>
 <20100723145631.GA8844@fancy-poultry.org>
 <20100723183720.GD13104@redhat.com>
 <20100724080613.GA6554@fancy-poultry.org>
 <20100728202212.GD16314@redhat.com>
 <20100728235716.GA12945@infradead.org>
 <20100729043443.GB21736@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100729043443.GB21736@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 29, 2010 at 12:34:43AM -0400, Vivek Goyal wrote:
> On Wed, Jul 28, 2010 at 07:57:16PM -0400, Christoph Hellwig wrote:
> > On Wed, Jul 28, 2010 at 04:22:12PM -0400, Vivek Goyal wrote:
> > > I also did "time firefox &" testing to see how long firefox takes to
> > > launch when linus torture test is running and without patch it took
> > > around 20 seconds and with patch it took around 17 seconds. 
> > > 
> > > So to me above test results suggest that this patch does not worsen
> > > the performance. In fact it helps. (at least on ext3 file system.)
> > > 
> > > Not sure why are you seeing different results with XFS.
> > 
> > So why didn't you test it with XFS to verify his results?
> 
> Just got little lazy. Find the testing results with ext3, ext4 and
> xfs below.
> 
> >  We all know
> > that different filesystems have different I/O patters, and we have
> > a history of really nasty regressions in one filesystem by good meaning
> > changes to the I/O scheduler.
> > 
> > ext3 in fact is a particularly bad test case as it not only doesn't have
> > I/O barriers enabled, but also has particularly bad I/O patterns
> > compared to modern filesystems.
> 
> Ext3 results
> ============
> ext3 (2.6.35-rc6)	ext3 (35-rc6-fsync)
> -----------------	-------------------
> fsync time: 3.4173	fsync time: 0.0171
> fsync time: 0.8831	fsync time: 0.0951
> fsync time: 0.6985	fsync time: 0.0848
> fsync time: 8.9449	fsync time: 0.1206
> fsync time: 4.3075	fsync time: 0.4150
> fsync time: 6.0146	fsync time: 0.0856
> fsync time: 9.7134	fsync time: 0.1151
> fsync time: 9.2247	fsync time: 0.1083
> fsync time: 6.5061	fsync time: 0.1218
> fsync time: 6.1862	fsync time: 4.1666
> fsync time: 6.1136	fsync time: 0.1075
> fsync time: 3.3593	fsync time: 0.3442
> fsync time: 4.3309	fsync time: 0.1062
> fsync time: 2.3596	fsync time: 2.8502
> fsync time: 0.0151	fsync time: 0.0433
> fsync time: 0.0180	fsync time: 4.0526
> fsync time: 0.3685	fsync time: 0.1819
> fsync time: 2.7396	fsync time: 0.1479
> fsync time: 3.1537	fsync time: 0.1480
> fsync time: 2.4474	fsync time: 0.1715
> fsync time: 2.7085	fsync time: 0.0079
> fsync time: 3.1629	fsync time: 0.0181
> fsync time: 2.9186	fsync time: 0.0134
> 
> XFS results
> ==========
> XFS (2.6.35-rc6)	XFS (with fsync patch)
> fsync time: 5.0746	fsync time: 1.8025
> fsync time: 3.0057	fsync time: 2.3392
> fsync time: 3.0960	fsync time: 2.2810
> fsync time: 2.8392	fsync time: 2.2894
> fsync time: 2.4901	fsync time: 2.3059
> fsync time: 2.3151	fsync time: 2.3061
> fsync time: 2.3066	fsync time: 2.9825
> fsync time: 0.6608	fsync time: 2.3144
> fsync time: 0.0595	fsync time: 2.2894
> fsync time: 2.0977	fsync time: 0.0508
> fsync time: 2.3236	fsync time: 2.3396
> fsync time: 2.3229	fsync time: 2.3310
> fsync time: 2.3065	fsync time: 2.3061
> fsync time: 2.3234	fsync time: 2.3060
> fsync time: 2.3150	fsync time: 2.3561
> fsync time: 2.3149	fsync time: 2.3313
> fsync time: 2.3234	fsync time: 2.0221
> fsync time: 2.3066	fsync time: 2.2891
> fsync time: 2.3232	fsync time: 2.3144
> fsync time: 2.3317	fsync time: 2.3144
> fsync time: 2.3321	fsync time: 2.2894
> fsync time: 2.3232	fsync time: 2.3228
> fsync time: 0.0514	fsync time: 2.3144
> fsync time: 2.2480	fsync time: 0.0506
> 
> Ext4
> ====
> ext4 (vanilla)		ext4 (patched)
> fsync time: 3.4080	fsync time: 2.9109
> fsync time: 17.8330	fsync time: 25.0503
> fsync time: 0.0922	fsync time: 2.5495
> fsync time: 0.0710	fsync time: 0.0943
> fsync time: 19.7977	fsync time: 0.0770
> fsync time: 20.6592	fsync time: 16.3287
> fsync time: 0.1020	fsync time: 24.4983
> fsync time: 0.0689	fsync time: 0.1006
> fsync time: 19.9981	fsync time: 0.0783
> fsync time: 20.6605	fsync time: 19.1181
> fsync time: 0.0930	fsync time: 22.0860
> fsync time: 0.0776	fsync time: 0.0909
> 
> 
> Notes:
> ======
> - Above results are with and without corrado's fsync issue patch. We
>   happen to be discussing it in a different thread though, hence
>   specifying it specifically.
> 
> - I am running linus torture test and also running ted so's fsync-tester
>   to monitor fsync latencies.
> 
> - Looks like ext3 fsync times have improved.
> - XFS fsync times have remained unchanged.
> - ext4 fsync times seems to have gone up a bit.
> 
> I used default mount options. So I am assuming high fsync times of ext4
> comes from the fact that barriers much be enabled by default. Will do
> some blktracing on ext4 case tomorrow, otherwise I think this patch
> looks good.

For the sake of completeness, I also ran same tests on ext3 with barrier
enabled.

ext3 (barrier=1)	ext3 (barrier=1)
fsync time: 2.7601	fsync time: 1.5323
fsync time: 2.2352	fsync time: 1.5254
fsync time: 2.1689	fsync time: 1.4228
fsync time: 2.1666	fsync time: 1.8404
fsync time: 2.3017	fsync time: 5.6249
fsync time: 2.2256	fsync time: 1.6099
fsync time: 2.1588	fsync time: 1.5318
fsync time: 5.1648	fsync time: 2.0092
fsync time: 5.8390	fsync time: 1.9966
fsync time: 0.2109	fsync time: 2.0055
fsync time: 0.0906	fsync time: 2.0054
fsync time: 3.6327	fsync time: 0.1778
fsync time: 3.0161	fsync time: 0.0827
fsync time: 2.3194	fsync time: 2.3796
fsync time: 2.0581	fsync time: 1.5960
fsync time: 2.2850	fsync time: 1.5074
fsync time: 2.2002	fsync time: 1.8653
fsync time: 2.1932	fsync time: 1.8910
fsync time: 2.1753	fsync time: 1.9091
fsync time: 2.1669	fsync time: 1.8322
fsync time: 2.1671	fsync time: 1.8744
fsync time: 1.9552	fsync time: 1.8254
fsync time: 3.9870	fsync time: 1.8662
fsync time: 2.5140	fsync time: 1.8587
fsync time: 0.0867	fsync time: 1.7981

It is hard to say whether things improved or not with patch. I guess
slight improvement is there.

What is interesting though that this fsync-tester test case works well
with ext3 and xfs but with ext4 there seems to be large spikes in 
fsync times.

[CCing Ted Tso]

Thanks
Vivek
