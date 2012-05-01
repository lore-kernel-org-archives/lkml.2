Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753154Ab2EAIKA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2012 04:10:00 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:40757 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751584Ab2EAIJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2012 04:09:58 -0400
Message-ID: <4F9F9A52.8010100@redhat.com>
Date: Tue, 01 May 2012 10:09:54 +0200
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120425 Thunderbird/12.0
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@HansenPartnership.com>
CC: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hu Tao <hutao@cn.fujitsu.com>
Subject: Re: [PATCH for 3.4] virtio-scsi: fix TMF use-after-free
References: <1334756761-12312-1-git-send-email-pbonzini@redhat.com> <1334758148.4410.51.camel@dabdike>
In-Reply-To: <1334758148.4410.51.camel@dabdike>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 18/04/2012 16:09, James Bottomley ha scritto:
>> > Fix a race in TMF path, where cmd may have been already freed
>> > by virtscsi_complete_free after waking up from the completion.
> There's no may about this; the command will be freed long before the
> completion waiter is awoken.  The description could be clearer.
> 
> The problem is a use after free in virtscsi_tmf because the
> virtio_scsi_command is freed before the completion returns.
> 
> The fix is to make callers specifying a completion responsible for
> freeing the command in all cases.

I don't see this in the pull request, were you waiting for v2 with a
better commit message?

Paolo
