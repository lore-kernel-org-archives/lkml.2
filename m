Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757608Ab1K3QRi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:17:38 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:34580 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757172Ab1K3QRf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:17:35 -0500
Message-ID: <1322669842.3985.10.camel@lappy>
Subject: Re: [PATCH] virtio-ring: Use threshold for switching to indirect
 descriptors
From: Sasha Levin <levinsasha928@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>,
        virtualization@lists.linux-foundation.org, kvm@vger.kernel.org,
        markmc@redhat.com
Date: Wed, 30 Nov 2011 18:17:22 +0200
In-Reply-To: <1322669511.3985.8.camel@lappy>
References: <1322559196-11139-1-git-send-email-levinsasha928@gmail.com>
	 <20111129125622.GB19157@redhat.com> <1322573688.4395.11.camel@lappy>
	 <20111129135406.GB30966@redhat.com> <1322576464.7003.6.camel@lappy>
	 <20111129145451.GD30966@redhat.com> <4ED4F30F.8000603@redhat.com>
	 <1322669511.3985.8.camel@lappy>
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry, I forgot to copy-paste one of the results :)

On Wed, 2011-11-30 at 18:11 +0200, Sasha Levin wrote:
> I did some testing of indirect descriptors under different workloads.
> 
> All tests were on a 2 vcpu guest with vhost on. Simple TCP_STREAM using
> netperf.
> 
> Indirect desc off:
> guest -> host, 1 stream: ~4600mb/s
> host -> guest, 1 stream: ~5900mb/s
> guest -> host, 8 streams: ~620mb/s (on average)
> host -> guest, 8 stream: ~600mb/s (on average)
> 
> Indirect desc on:
> guest -> host, 1 stream: ~4900mb/s
> host -> guest, 1 stream: ~5400mb/s
> guest -> host, 8 streams: ~620mb/s (on average)
> host -> guest, 8 stream: ~600mb/s (on average)
Should be:
host -> guest, 8 stream: ~515mb/s (on average)

> 
> Which means that for one stream, guest to host gets faster while host to
> guest gets slower when indirect descriptors are on.
> 

-- 

Sasha.

