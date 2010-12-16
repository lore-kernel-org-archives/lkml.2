Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab0LPAmp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 19:42:45 -0500
Received: from smtp-out.google.com ([74.125.121.35]:17886 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab0LPAmo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 19:42:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=ETLOksuvkqRgwDwDd7NgwnfMMg0R/VlSn4MxuRq6KlMAQYFvOcB+bX6cnioTgNv0L8
         Gifws+h4HM09XB8PYDPQ==
Date: Wed, 15 Dec 2010 16:42:33 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hughd@tigran.mtv.corp.google.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
cc: Ric Wheeler <ricwheeler@gmail.com>, Christian Brandt <brandtc@psi5.com>,
        linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
Subject: Re: swap storage alignment and stride size
In-Reply-To: <yq18vzq6dgb.fsf@sermon.lab.mkp.net>
Message-ID: <alpine.LSU.2.00.1012151627400.8734@tigran.mtv.corp.google.com>
References: <4CFFBA7D.6060802@psi5.com> <4CFFE2EA.9040909@gmail.com> <yq1d3p486qe.fsf@sermon.lab.mkp.net> <alpine.LSU.2.00.1012142038430.13004@tigran.mtv.corp.google.com> <yq18vzq6dgb.fsf@sermon.lab.mkp.net>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010, Martin K. Petersen wrote:
> >>>>> "Hugh" == Hugh Dickins <hughd@google.com> writes:
> 
> Hugh> (scan_swap_map does try to allocate in 1MB clusters, but they're
> Hugh> not written out that way, and there's no attempt to align: if it
> Hugh> worked out better for the lower level to require that these 1MB
> Hugh> clusters are aligned, we could probably go for that - though the
> Hugh> swap header page might then be a nuisance.)
> 
> You called it a "header page". Does that imply that it is page sized?

Yes.  (Rather a nuisance on a PowerPC system which sometimes uses
a kernel with 4k pages and sometimes a kernel with 64k pages.)

> Or will it cause pages written to a 4k-aligned swap device to be
> misaligned?

No, the 4k-aligned remains 4k-aligned, of course.  But if you aligned
your swap partition on, say, a 1MB boundary, and are thinking of
working in aligned 1MB blocks, then it may be awkward that there's
always this special 4k at the start (it could be written back each
time even though it hasn't changed, but it's still an odd case).

Hugh
