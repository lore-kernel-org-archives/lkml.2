Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754217Ab0GXJHM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Jul 2010 05:07:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:46838 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab0GXJHJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Jul 2010 05:07:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=hhvBr+BVLxvoRmrFhDHjvLbHDW3lhV91Vx9DLcmnXzI7ljJo9+jlAcaccM1iZ1mMTs
         hOFvYWE/z/yvSqUZE354joD/h97vCTr21XsHD7wBuX6T8gTTt3dcsGdOVY/XrBLFNQkw
         0ou2b9+ICR7KCI+UfWeuFt81NW+SHolbu6q9E=
MIME-Version: 1.0
In-Reply-To: <20100724085135.GB32006@infradead.org>
References: <1279739181-24482-1-git-send-email-vgoyal@redhat.com>
	<20100722055602.GA18566@infradead.org>
	<20100722140044.GA28684@redhat.com>
	<20100724085135.GB32006@infradead.org>
Date: Sat, 24 Jul 2010 11:07:07 +0200
Message-ID: <AANLkTi=d-2-1R_Bpk_1J7AXhTc2Kv3p8S7tE0ZsFKFDe@mail.gmail.com>
Subject: Re: [RFC PATCH] cfq-iosced: Implement IOPS mode and group_idle 
	tunable V3
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, nauman@google.com, dpshah@google.com,
        guijianfeng@cn.fujitsu.com, jmoyer@redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 24, 2010 at 10:51 AM, Christoph Hellwig <hch@infradead.org> wrote:
> To me this sounds like slice_idle=0 is the right default then, as it
> gives useful behaviour for all systems linux runs on.
No, it will give bad performance on single disks, possibly worse than
deadline (deadline at least sorts the requests between different
queues, while CFQ with slice_idle=0 doesn't even do this for readers).
Setting slice_idle to 0 should be considered only when a single
sequential reader cannot saturate the disk bandwidth, and this happens
only on smart enough hardware with large number of spindles.
>  Setups with
> more than a few spindles are for sure more common than setups making
> use of cgroups.  Especially given that cgroups are more of a high end
> feature you'd rarely use on a single SATA spindle anyway.  So setting
> a paramter to make this useful sounds like the much better option.
>
> Especially given that the block cgroup code doesn't work particularly
> well in presence of barriers, which are on for any kind of real life
> production setup anyway.
>
>



-- 
__________________________________________________________________________

dott. Corrado Zoccolo                          mailto:czoccolo@gmail.com
PhD - Department of Computer Science - University of Pisa, Italy
--------------------------------------------------------------------------
The self-confidence of a warrior is not the self-confidence of the average
man. The average man seeks certainty in the eyes of the onlooker and calls
that self-confidence. The warrior seeks impeccability in his own eyes and
calls that humbleness.
                               Tales of Power - C. Castaneda
