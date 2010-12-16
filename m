Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753469Ab0LPXrH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 18:47:07 -0500
Received: from rcsinet10.oracle.com ([148.87.113.121]:30122 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751690Ab0LPXrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 18:47:04 -0500
To: Hugh Dickins <hughd@google.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ric Wheeler <ricwheeler@gmail.com>,
        Christian Brandt <brandtc@psi5.com>, linux-kernel@vger.kernel.org,
        Mike Snitzer <snitzer@redhat.com>
Subject: Re: swap storage alignment and stride size
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <4CFFBA7D.6060802@psi5.com> <4CFFE2EA.9040909@gmail.com>
	<yq1d3p486qe.fsf@sermon.lab.mkp.net>
	<alpine.LSU.2.00.1012142038430.13004@tigran.mtv.corp.google.com>
	<yq18vzq6dgb.fsf@sermon.lab.mkp.net>
	<alpine.LSU.2.00.1012151627400.8734@tigran.mtv.corp.google.com>
Date: Thu, 16 Dec 2010 18:46:41 -0500
In-Reply-To: <alpine.LSU.2.00.1012151627400.8734@tigran.mtv.corp.google.com>
	(Hugh Dickins's message of "Wed, 15 Dec 2010 16:42:33 -0800 (PST)")
Message-ID: <yq11v5h46xq.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Hugh" == Hugh Dickins <hughd@google.com> writes:

>> You called it a "header page". Does that imply that it is page sized?

Hugh> Yes.  (Rather a nuisance on a PowerPC system which sometimes uses
Hugh> a kernel with 4k pages and sometimes a kernel with 64k pages.)

Ok.


>> Or will it cause pages written to a 4k-aligned swap device to be
>> misaligned?

Hugh> No, the 4k-aligned remains 4k-aligned, of course.  But if you
Hugh> aligned your swap partition on, say, a 1MB boundary, and are
Hugh> thinking of working in aligned 1MB blocks, then it may be awkward
Hugh> that there's always this special 4k at the start (it could be
Hugh> written back each time even though it hasn't changed, but it's
Hugh> still an odd case).

Yeah, I got that. I just wanted to make sure that the header was not 32
bytes or something like that because that would be highly painful from
an I/O alignment perspective.

-- 
Martin K. Petersen	Oracle Linux Engineering
