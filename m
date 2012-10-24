Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932899Ab2JXQ7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:59:30 -0400
Received: from userp1050.oracle.com ([156.151.31.82]:29268 "EHLO
	userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757177Ab2JXQ72 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:59:28 -0400
To: Tejun Heo <tj@kernel.org>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, axboe@kernel.dk
Subject: Re: [PATCH v4 1/2] block: Fix a buffer overrun in bio_integrity_split()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
	<1350331769-14856-28-git-send-email-koverstreet@google.com>
	<20121019203015.GS13370@google.com> <20121022153907.GC3401@redhat.com>
	<yq1mwzbbzi1.fsf@sermon.lab.mkp.net>
	<CAOS58YPFq_rt1Pw-v1XtX7-tnPGceXP5Chpp9JhkkMtnWnNQsg@mail.gmail.com>
Date: Wed, 24 Oct 2012 12:57:45 -0400
In-Reply-To: <CAOS58YPFq_rt1Pw-v1XtX7-tnPGceXP5Chpp9JhkkMtnWnNQsg@mail.gmail.com>
	(Tejun Heo's message of "Wed, 24 Oct 2012 12:42:46 -0400")
Message-ID: <yq1ehknbyeu.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: userp1040.oracle.com [156.151.31.81]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:

Tejun> If Martin is happy with it, I'm not gonna push it but putting the
Tejun> respective storage member after one containing vararray at the
Tejun> end is a legit way to allocate the area statically. As long as
Tejun> the storage field is marked as such and not accessed directly, it
Tejun> doesn't matter whether there's padding inbetween or not. 

The embedded array is still at the end. Kent just added an explicit
pointer for use in the bio_pair corner case.

-- 
Martin K. Petersen	Oracle Linux Engineering
