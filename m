Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751354Ab0KSGdo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 01:33:44 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:59302 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173Ab0KSGdn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 01:33:43 -0500
Date: Fri, 19 Nov 2010 01:33:32 -0500
From: Gene Cooperman <gene@ccs.neu.edu>
To: Anton Blanchard <anton@au1.ibm.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Oren Laadan <orenl@cs.columbia.edu>,
        ksummit-2010-discuss@lists.linux-foundation.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, akpm@linux-foundation.org,
        tj@kernel.org, Kapil Arya <kapil@ccs.neu.edu>,
        Gene Cooperman <gene@ccs.neu.edu>
Subject: Re: [Ksummit-2010-discuss] checkpoint-restart: naked patch
Message-ID: <20101119063332.GA6662@sundance.ccs.neu.edu>
References: <Pine.LNX.4.64.1011021530470.12128@takamine.ncl.cs.columbia.edu>
 <AANLkTimOG-iFw-yg8rgNHJOEn49_v=0ZaDu_XK7KRRs1@mail.gmail.com>
 <20101117162922.0f874a8e@kryten>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101117162922.0f874a8e@kryten>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 1. Resource management. Any large HPC cluster should be 100% busy and
> as such you will often fill in the gaps with low priority jobs which
> may need to be preempted. These low priority jobs need to give up their
> resources (memory, interconnect resources etc) whenever something
> important comes in.
>
> 2. Fault tolerance. Failures are a fact of life for any decent sized
> cluster. As the cluster gets larger these failures become very common.
> Speaking from an industry perspective, MTBF rates measured in the order
> of several hours for large commodity clusters are not surprising. We at
> IBM improve on that with hardware and system design, but there is only
> so much you can do. The failures also happen at the Linux kernel level
> so even if we had 100% reliable systems we would still have issues.

We have also been somewhat involved in HPC. Grant provides a nice 
summary of the two usage scenarios of checkpoint-restart that we have also
observed.

Since there is continuing discussion of HPC, I was a little surprised that
there has not been more discussion of BLCR (Berkeley Lab Checkpoint/Restart).
A brief introduction to BLCR follows, in case it's of interest.

    https://ftg.lbl.gov/CheckpointRestart/CheckpointRestart.shtml

In the HPC space, we have observed that many sites use BLCR for
checkpoint-restart. BLCR is based on a kernel module, and so represents a third
approach. As mentioned on the FAQ, BLCR can checkpoint/restart a
process tree/group/session but has certain limitations, such as not supporting
sockets, ptys, and restoring original pids on restart only if there is no
collision with current pids. Nevertheless, BLCR has achieved wide usage in the
HPC community. Quoting from the BLCR FAQ: 

    Q: Does BLCR support checkpointing parallel/distributed applications?

    Not by itself. But by using checkpoint callbacks (see previous FAQ). some
    MPI implementations have made themselves checkpointable by BLCR. You can
    checkpoint/restart an MPI application running across an entire cluster of
    machines with BLCR, without any application code modifications, if you use
    one of these MPI implementations (listed alphabetically):
        * LAM/MPI 7.x or later
        * MPICH-V 1.0.x
        * MVAPICH2 0.9.8 or later
        * Open MPI 1.3 or later

    Q: Is BLCR integrated with any batch systems?

    We are aware of the following, but we are not always informed of new
    efforts to integrate with BLCR. For the most up-to-date information you
    should consult the support channels of your favorite batch system.
    * TORQUE version 2.3 and later
      Support for serial and parallel jobs, including periodic checkpoints and
      qhold/qrls.
    * SLURM version 2.0 and later
      Support for automatic (periodic) and manually requested checkpoints.
    * SGE (aka Sun Grid Engine)
      Information on configuring SGE to use BLCR can be found here. There is
      also a thread on the checkpoint@lbl.gov list about modifications to those
      instructions. The thread begins with this posting.
    * LSF
      Information on configuring LSF to use BLCR can be found in this posting
      on the checkpoint@lbl.gov list.
    * Condor
      Information on configuring Condor to use BLCR to checkpoint "Vanilla
      Universe" jobs with the help of Parrot can be found here.

- Gene
