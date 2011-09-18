Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932284Ab1IRO4N (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Sep 2011 10:56:13 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:28020 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894Ab1IRO4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Sep 2011 10:56:12 -0400
Content-Type: text/plain; charset=UTF-8
From: Chris Mason <chris.mason@oracle.com>
To: Jeff liu <jeff.liu@oracle.com>
Cc: Marco Stornelli <marco.stornelli@gmail.com>,
        Andi Kleen <ak@linux.intel.com>, Andreas Dilger <adilger@dilger.ca>,
        Christoph Hellwig <hch@infradead.org>,
        Andi Kleen <andi@firstfloor.org>,
        "viro@zeniv.linux.org.uk" <viro@zeniv.linux.org.uk>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/7] BTRFS: Fix lseek return value for error
In-reply-to: <8444301C-856F-44FA-94A3-D3583DFA0FFB@oracle.com>
References: <1316128013-21980-1-git-send-email-andi@firstfloor.org> <1316128013-21980-2-git-send-email-andi@firstfloor.org> <20110916154815.GA27150@infradead.org> <4E7439EB.7080100@oracle.com> <41C7FF67-8658-4E7F-BB50-E9AAEA1F755C@dilger.ca> <20110918014608.GA16198@alboin.amr.corp.intel.com> <4E759DE5.3020907@oracle.com> <4E75AEFD.105@gmail.com> <8444301C-856F-44FA-94A3-D3583DFA0FFB@oracle.com>
Date: Sun, 18 Sep 2011 10:55:49 -0400
Message-Id: <1316357705-sup-2667@shiny>
User-Agent: Sup/git
Content-Transfer-Encoding: 8bit
X-Source-IP: rtcsinet22.oracle.com [66.248.204.30]
X-CT-RefId: str=0001.0A090203.4E760682.0001,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excerpts from Jeff liu's message of 2011-09-18 06:33:38 -0400:
> 
> 在 2011-9-18，下午4:42， Marco Stornelli 写道：
> 
> > Il 18/09/2011 09:29, Jeff Liu ha scritto:
> >> Hi Andreas and Andi,
> >> 
> >> Thanks for your comments.
> >> 
> >> On 09/18/2011 09:46 AM, Andi Kleen wrote:
> >> 
> >>>>> with an additional improvement if the offset is larger or equal to the
> >>>>> file size, return -ENXIO in directly:
> >>>>> 
> >>>>>                if (offset>= inode->i_size) {
> >>>>>                        mutex_unlock(&inode->i_mutex);
> >>>>>                        return -ENXIO;
> >>>>>                }
> >>>> 
> >>>> Except that is wrong, because it would then be impossible to write sparse files.
> >> 
> >> Per my tryout, except that, if the offset>= source file size, call
> >> lseek(fd, offset, SEEK_DATA/SEEK_HOLE) against Btrfs will always return
> >> the total file size rather than -ENXIO.  however, our desired result it
> >> -ENXIO in this case, Am I right?
> >> 
> > 
> > Yes, ENXIO should be the operation result.
> 
> Thanks for your kind confirmation.

Thanks everyone, I've put Jeff's last version of this in my queue.

-chris
