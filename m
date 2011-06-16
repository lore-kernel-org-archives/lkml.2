Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755Ab1FPLwJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:52:09 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:53417
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756627Ab1FPLwG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:52:06 -0400
Date: Thu, 16 Jun 2011 07:51:56 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Christoph Hellwig <hch@infradead.org>, Pekka Enberg <penberg@kernel.org>,
        Anthony Liguori <anthony@codemonkey.ws>,
        Alexander Graf <agraf@suse.de>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
Message-ID: <20110616115156.GA3766@infradead.org>
References: <BANLkTikmUpF_fsZcpiuMzZQZa17U-cPQAw@mail.gmail.com>
 <BANLkTi=mS43KwRG13ROmZX+HmbrPMVgV=g@mail.gmail.com>
 <20110616092429.GA5484@infradead.org>
 <BANLkTinnSW=EEunCu_d51Mapiv=V03ncQw@mail.gmail.com>
 <20110616094810.GA19965@infradead.org>
 <BANLkTikoMZCFzA6jUw+ddHZ3x2cvO_NzhA@mail.gmail.com>
 <20110616100239.GA29262@infradead.org>
 <20110616112230.GD26110@elte.hu>
 <20110616112552.GA15816@infradead.org>
 <20110616114045.GA27060@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616114045.GA27060@elte.hu>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 16, 2011 at 01:40:45PM +0200, Ingo Molnar wrote:
> Filesystems that cannot guarantee that should map their 
> sync_file_range() implementation to fdatasync() or so, right?

Filesystems aren't even told about sync_file_range, it's purely a VM
thing, which is the root of the problem.

In-kernel we have all the infrastructure for a real ranged
fsync/fdatasync, and once we get a killer users for that can triviall
export it at the syscall level.  I don't think mapping sync_file_range
with it's weird set of flags and confusing behaviour to it is a good
idea, though.

