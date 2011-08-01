Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab1HAK0W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 06:26:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19265 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752895Ab1HAK0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 06:26:13 -0400
Date: Mon, 1 Aug 2011 13:26:43 +0300
From: "Michael S. Tsirkin" <mst@redhat.com>
To: Liu Yuan <namei.unix@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] vhost-blk: An in-kernel accelerator for virtio-blk
Message-ID: <20110801102643.GG5439@redhat.com>
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com>
 <1311863346-4338-2-git-send-email-namei.unix@gmail.com>
 <20110728152244.GA31888@redhat.com>
 <4E3646E0.9050400@gmail.com>
 <20110801081237.GC5439@redhat.com>
 <4E366A1A.2090004@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E366A1A.2090004@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 04:55:54PM +0800, Liu Yuan wrote:
> Nope, V1 completion thread doesn't has any mutex, thus can run
> parallel with the vhost worker.

It's true, it doesn't, but I think it's a bug :)
It calls vhost_add_used which definitely needs the
vq mutex.
