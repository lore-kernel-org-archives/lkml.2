Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758495Ab0J1PYt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 11:24:49 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:40128 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756307Ab0J1PYm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 11:24:42 -0400
Subject: Re: [RFC PATCH 1/1] vhost: TX used buffer guest signal accumulation
From: Shirley Ma <mashirle@us.ibm.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20101028052021.GD5599@redhat.com>
References: <1288216693.17571.38.camel@localhost.localdomain>
	 <1288240804.14342.1.camel@localhost.localdomain>
	 <20101028052021.GD5599@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 28 Oct 2010 08:24:37 -0700
Message-ID: <1288279477.11251.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-10-28 at 07:20 +0200, Michael S. Tsirkin wrote:
> My concern is this can delay signalling for unlimited time.
> Could you pls test this with guests that do not have
> 2b5bbe3b8bee8b38bdc27dd9c0270829b6eb7eeb
> b0c39dbdc204006ef3558a66716ff09797619778
> that is 2.6.31 and older?

I will test it out.

> This seems to be slighltly out of spec, even though
> for TX, signals are less important.
> Two ideas:
> 1. How about writing out used, just delaying the signal?
>    This way we don't have to queue separately.
> 2. How about flushing out queued stuff before we exit
>    the handle_tx loop? That would address most of
>    the spec issue. 

I will modify the patch to test out the performance for both 1 & 2
approaches.

Thanks
Shirley



