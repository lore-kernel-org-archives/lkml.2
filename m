Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab1FPLlC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 07:41:02 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:50419 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422Ab1FPLk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 07:40:57 -0400
Date: Thu, 16 Jun 2011 13:40:45 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Christoph Hellwig <hch@infradead.org>
Cc: Pekka Enberg <penberg@kernel.org>, Anthony Liguori <anthony@codemonkey.ws>,
        Alexander Graf <agraf@suse.de>,
        Prasad Joshi <prasadjoshi124@gmail.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel@vger.kernel.org, kvm@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <levinsasha928@gmail.com>,
        Cyrill Gorcunov <gorcunov@gmail.com>, Asias He <asias.hejun@gmail.com>,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [ANNOUNCE] Native Linux KVM tool v2
Message-ID: <20110616114045.GA27060@elte.hu>
References: <4DF935C1.4020000@codemonkey.ws>
 <BANLkTikmUpF_fsZcpiuMzZQZa17U-cPQAw@mail.gmail.com>
 <BANLkTi=mS43KwRG13ROmZX+HmbrPMVgV=g@mail.gmail.com>
 <20110616092429.GA5484@infradead.org>
 <BANLkTinnSW=EEunCu_d51Mapiv=V03ncQw@mail.gmail.com>
 <20110616094810.GA19965@infradead.org>
 <BANLkTikoMZCFzA6jUw+ddHZ3x2cvO_NzhA@mail.gmail.com>
 <20110616100239.GA29262@infradead.org>
 <20110616112230.GD26110@elte.hu>
 <20110616112552.GA15816@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110616112552.GA15816@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Christoph Hellwig <hch@infradead.org> wrote:

> On Thu, Jun 16, 2011 at 01:22:30PM +0200, Ingo Molnar wrote:

> > Such as? I don't think apps can actually know whether disk blocks 
> > have been 'instantiated' by a particular filesystem or not, so 
> > the manpage:
> 
> In general they can't.  The only good use case for sync_file_range 
> is to paper over^H^H^H^H^H^H^H^H^Hcontrol write back behaviour.

Well, if overwrite is fundamentally safe on a filesystem (which is 
most of them) then sync_file_range() would work - and it has the big 
advantage that it's a pretty simple facility.

Filesystems that cannot guarantee that should map their 
sync_file_range() implementation to fdatasync() or so, right?

Thanks,

	Ingo
