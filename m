Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab1K2O6c (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Nov 2011 09:58:32 -0500
Received: from mx1.redhat.com ([209.132.183.28]:24447 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752261Ab1K2O6a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Nov 2011 09:58:30 -0500
Message-ID: <4ED4F30F.8000603@redhat.com>
Date: Tue, 29 Nov 2011 16:58:23 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: "Michael S. Tsirkin" <mst@redhat.com>
CC: Sasha Levin <levinsasha928@gmail.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
References: <1322559196-11139-1-git-send-email-levinsasha928@gmail.com> <20111129125622.GB19157@redhat.com> <1322573688.4395.11.camel@lappy> <20111129135406.GB30966@redhat.com> <1322576464.7003.6.camel@lappy> <20111129145451.GD30966@redhat.com>
In-Reply-To: <20111129145451.GD30966@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/2011 04:54 PM, Michael S. Tsirkin wrote:
> > 
> > Which is actually strange, weren't indirect buffers introduced to make
> > the performance *better*? From what I see it's pretty much the
> > same/worse for virtio-blk.
>
> I know they were introduced to allow adding very large bufs.
> See 9fa29b9df32ba4db055f3977933cd0c1b8fe67cd
> Mark, you wrote the patch, could you tell us which workloads
> benefit the most from indirect bufs?
>

Indirects are really for block devices with many spindles, since there
the limiting factor is the number of requests in flight.  Network
interfaces are limited by bandwidth, it's better to increase the ring
size and use direct buffers there (so the ring size more or less
corresponds to the buffer size).

-- 
error compiling committee.c: too many arguments to function

