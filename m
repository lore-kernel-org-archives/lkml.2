Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932589Ab2DKQZY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 12:25:24 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:30693 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932471Ab2DKQZX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 12:25:23 -0400
To: Mike Snitzer <snitzer@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        linux kernel mailing list <linux-kernel@vger.kernel.org>,
        martin.petersen@oracle.com
Subject: Re: [RFC PATCH] block: Change default IO scheduler to deadline except SATA
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <20120410133708.GE21801@redhat.com> <4F843C17.5050004@kernel.dk>
	<20120410142148.GG21801@redhat.com>
	<20120410151042.GH21801@redhat.com>
	<CAMM=eLf5qi_PL8vFh_b5V_nq_mxg0CN0asE8E9XYJn48J4mdPA@mail.gmail.com>
Date: Wed, 11 Apr 2012 12:25:15 -0400
In-Reply-To: <CAMM=eLf5qi_PL8vFh_b5V_nq_mxg0CN0asE8E9XYJn48J4mdPA@mail.gmail.com>
	(Mike Snitzer's message of "Tue, 10 Apr 2012 12:13:07 -0400")
Message-ID: <yq14nsqck2c.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090206.4F85B06F.0024,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> I'm not aware of any discrete attribute (comparable to
Mike> 'rotational' flag) that SCSI devices will advertise that indicates
Mike> "I'm a raid array".

Sadly, no.


Mike> That said, we can have a _very_ good hint that a SCSI device is a
Mike> raid array if:

Mike> 1) optimal_io_size is not zero, minimum_io_size is not equal to
Mike> optimal_io_size, and optimal_io_size is a multiple of
Mike> minimum_io_size

Unfortunately there are still a lot of arrays out there that don't
export the relevant VPDs.

I know there's a lot of resistance to doing stuff in the kernel that can
be done in udev. But with my distro hat on we update the kernel much,
much more frequently than we update udev rules. For a multitude of
reasons.

Also, when it comes to disk arrays we already have a significant portion
of them hardwired in the kernel anyway (quirks, LUN discovery, device
handlers). So I'd personally be fine with having a BLIST_ARRAY flag that
we could trigger off of.

-- 
Martin K. Petersen	Oracle Linux Engineering
